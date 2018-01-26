java_library(
    name = "lib",
    srcs = glob(["src/**/*.java"]),
    deps = [
        "//kotlin/workers/proto",
        "@com_github_jetbrains_kotlin//:preloader"
    ],
    exports = ["//kotlin/workers/proto"],
    visibility = ["//visibility:private"]
)

java_binary(
    name = "compiler_jvm",
    main_class = "io.bazel.ruleskotlin.workers.compilers.jvm.KotlinJvmBuilder",
    visibility = ["//visibility:public"],
    runtime_deps = ["lib"]
)

java_test(
    name = "unittests",
    test_class = "io.bazel.ruleskotlin.workers.compilers.jvm.utils.JdepsParserTest",
    srcs = glob(["unittests/**/*.java"]),
    deps = ["lib"],
    size = "small"
)