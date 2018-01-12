package io.bazel.kotlin.workers.compiler.jvm;

import java.io.*;
import java.nio.file.Paths;


/**
 * Utility class to perform common pre-processing on the compiler output before it is passed onto a delegate
 * PrintStream.
 */
// The kotlin compiler produces absolute file paths but the intellij plugin expects workspace root relative paths to
// render errors.
class KotlinCompilerOutputProcessor {
    private ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
    // Get the absolute path to ensure the sandbox root is resolved.
    private final String executionRoot = Paths.get("").toAbsolutePath().toString() + File.separator;
    private final PrintStream delegate;


    private KotlinCompilerOutputProcessor(PrintStream delegate) {
        this.delegate = delegate;
    }

    static KotlinCompilerOutputProcessor delegatingTo(PrintStream delegate) {
        return new KotlinCompilerOutputProcessor(delegate);
    }

    PrintStream getCollector() {
        return new PrintStream(byteArrayOutputStream);
    }

    void process() {
        new BufferedReader(new InputStreamReader(new ByteArrayInputStream(byteArrayOutputStream.toByteArray())))
                .lines()
                .forEach(line -> delegate.println(line.replace(executionRoot, "")));
    }
}
