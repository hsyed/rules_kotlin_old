/*
 * Copyright 2017 The Kotlin Rules Authors. All rights reserved.
 * Copyright 2016 The Closure Rules Authors. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package io.bazel.kotlin.workers.compiler.jvm;


import io.bazel.kotlin.workers.lib.CommandLineProgram;
import org.jetbrains.kotlin.preloading.ClassPreloadingUtils;
import org.jetbrains.kotlin.preloading.Preloader;

import java.io.File;
import java.io.PrintStream;
import java.lang.reflect.Method;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Stream;

import static java.util.stream.Collectors.toList;

final class KotlinJVMCompiler implements CommandLineProgram {
    private static final Object[] NO_ARGS = new Object[]{};
    private static final Path KOTLIN_REPO = Paths.get("external", "com_github_jetbrains_kotlin");
    private static final Path[] PRELOAD_JARS = new Path[]{
            Paths.get("lib", "kotlin-compiler.jar")
    };

    private final Object compiler;
    private final Method execMethod;
    private final Method getCodeMethod;

    private KotlinJVMCompiler(Object compiler, Method execMethod, Method getCodeMethod) {
        this.compiler = compiler;
        this.execMethod = execMethod;
        this.getCodeMethod = getCodeMethod;
    }

    @Override
    public Integer apply(Stream<String> args) {
        Integer exitCode;
        KotlinCompilerOutputProcessor outputProcessor = KotlinCompilerOutputProcessor.delegatingTo(System.out);
        try {
            final Object exitCodeInstance = execMethod.invoke(
                    compiler,
                    outputProcessor.getCollector(),
                    args.toArray(String[]::new)
            );
            exitCode = (Integer) getCodeMethod.invoke(exitCodeInstance, NO_ARGS);
        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            outputProcessor.process();
        }

        if (exitCode < 2) {
            // 1 is a standard compilation error
            // 2 is an internal error
            // 3 is the script execution error
            return exitCode;
        } else {
            throw new RuntimeException("KotlinCompile return terminal code: " + exitCode);
        }
    }

    /**
     * The compiler is loaded via an in memory class loader, uses some of the infrastructure from the Jetbrains
     * Preloader.
     */
    static KotlinJVMCompiler build() {
        try {
            ClassLoader classLoader = ClassPreloadingUtils.preloadClasses(
                    verifiedKotlinPreloadJarList(),
                    Preloader.DEFAULT_CLASS_NUMBER_ESTIMATE,
                    Thread.currentThread().getContextClassLoader(),
                    null
            );

            Class<?> compilerClass = classLoader.loadClass("org.jetbrains.kotlin.cli.jvm.K2JVMCompiler");
            Class<?> exitCodeClass = classLoader.loadClass("org.jetbrains.kotlin.cli.common.ExitCode");


            return new KotlinJVMCompiler(
                    compilerClass.newInstance(),
                    compilerClass.getMethod("exec", PrintStream.class, String[].class),
                    exitCodeClass.getMethod("getCode")
            );
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    /**
     * @return A verified list of files that the Kotlin Preloader should preload when the worker starts up.
     */
    private static List<File> verifiedKotlinPreloadJarList() {
        return Arrays.stream(PRELOAD_JARS).map(jar -> {
            File file = KOTLIN_REPO.resolve(jar).toFile();
            if (!file.exists()) {
                throw new RuntimeException("kotlin preload file did not exist: " + file);
            }
            return file;
        }).collect(toList());
    }
}