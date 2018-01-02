java_binary(
    name = "jvm",
    srcs= glob(["*.java"]),
    main_class = "io.bazel.kotlin.workers.compiler.jvm.KotlinJVMCompilerWorker",
    visibility = ["//visibility:public"],
    deps = [
        "@com_github_jetbrains_kotlin//:preloader",
        "//kotlin/workers/lib"
    ],
)