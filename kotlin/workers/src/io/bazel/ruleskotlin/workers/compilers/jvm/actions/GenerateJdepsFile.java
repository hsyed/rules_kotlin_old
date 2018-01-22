/*
 * Copyright 2018 The Bazel Authors. All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package io.bazel.ruleskotlin.workers.compilers.jvm.actions;

import com.google.devtools.build.lib.view.proto.Deps;
import io.bazel.ruleskotlin.workers.compilers.jvm.utils.JdepsParser;
import io.bazel.ruleskotlin.workers.compilers.jvm.BuildContext;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStreamReader;
import java.nio.file.Paths;
import java.util.function.Predicate;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import static io.bazel.ruleskotlin.workers.compilers.jvm.BuildContext.Field.*;

public final class GenerateJdepsFile implements BuildAction {
    private static final String JDEPS_PATH = Paths.get("external", "local_jdk", "bin", "jdeps").toString();

    private static final Predicate<String> IS_KOTLIN_IMPLICIT = JdepsParser.pathSuffixMatchingPredicate(
            Paths.get("external", "com_github_jetbrains_kotlin", "lib"),
            "kotlin-stdlib.jar",
            "kotlin-stdlib-jdk7.jar",
            "kotlin-stdlib-jdk8.jar");

    public static GenerateJdepsFile INSTANCE = new GenerateJdepsFile();

    private GenerateJdepsFile() {}

    @Override
    public Integer apply(BuildContext ctx) {
        final String
                classJar = OUTPUT_CLASSJAR.get(ctx),
                classPath = CLASSPATH.get(ctx),
                output = OUTPUT_JDEPS.get(ctx);

        try {
            String[] jdepLines = executeCommand(classJar, classPath);
            Deps.Dependencies jdepsContent = JdepsParser.parse(
                    LABEL.get(ctx),
                    classJar,
                    classPath,
                    Stream.of(jdepLines),
                    IS_KOTLIN_IMPLICIT
            );
            File file = new File(output);
            if(file.exists()) {
                file.delete();
            }
            file.createNewFile();
            FileOutputStream fileOutputStream = new FileOutputStream(file);
            jdepsContent.writeTo(fileOutputStream);
        } catch (Exception e) {
            System.err.println("failed generating jdeps file for artifact: " + classJar);
            e.printStackTrace(System.err);
            return 1;
        }
        return 0;
    }

    private static String[] executeCommand(String classJarPath, String compileClasspath) throws Exception {
        String command = Stream.of(JDEPS_PATH, "-cp", compileClasspath, classJarPath).collect(Collectors.joining(" "));
        Process process = Runtime.getRuntime().exec(command);
        try (
                BufferedReader stdInput = new BufferedReader(new InputStreamReader(process.getInputStream()));
                BufferedReader errInput = new BufferedReader(new InputStreamReader(process.getErrorStream()))
        ) {
            int status = process.waitFor();
            if (status != 0)
                throw new RuntimeException("could not get jdeps, status: " + status + "error:\n" + errInput.lines().collect(Collectors.joining("\n")));
            return stdInput.lines().toArray(String[]::new);
        }
    }
}
