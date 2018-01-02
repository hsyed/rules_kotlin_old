java_binary(
    name = "jvm",
    srcs= glob(["*.java"]),
    main_class = "io.bazel.kotlin.workers.compiler.jvm.KotlinJVMCompilerWorker",
    visibility = ["//visibility:public"],
    deps = [
        "@com_github_jetbrains_kotlin//:preloader",
        "//kotlin/workers/lib"
    ],
    runtime_deps = [
#        "@com_github_jetbrains_kotlin//:compiler",
#        "@com_github_jetbrains_kotlin//:stdlib",
#        "@com_github_jetbrains_kotlin//:reflect",
#        "@com_github_jetbrains_kotlin//:script-runtime",
    ]
)