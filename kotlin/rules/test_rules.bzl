load(
    "//kotlin/rules:defs.bzl",
    _binary_outputs = "binary_outputs",
    _runnable_common_attr = "runnable_common_attr",
)
load(
    "//kotlin/rules:compile.bzl",
    _kotlin_compile_action = "kotlin_compile_action",
    _kotlin_make_providers = "kotlin_make_providers",
)
load(
    "//kotlin/rules:util.bzl",
    _kotlin_write_launcher_action = "kotlin_write_launcher_action",
)

_test_attr = _runnable_common_attr + {
    "_bazel_test_runner": attr.label(
        default = Label("@bazel_tools//tools/jdk:TestRunner_deploy.jar"),
        allow_files = True,
    ),
    "test_class": attr.string(),
    "main_class": attr.string(),
}

def _kotlin_junit_test_impl(ctx):
    java_info = _kotlin_compile_action(ctx)

    runtime_jars = java_info.transitive_runtime_jars + ctx.files._bazel_test_runner
    launcherJvmFlags = ["-ea", "-Dbazel.test_suite=%s"% ctx.attr.test_class]

    _kotlin_write_launcher_action(
        ctx,
        runtime_jars,
        main_class = "com.google.testing.junit.runner.BazelTestRunner",
        jvm_flags = launcherJvmFlags + ctx.attr.jvm_flags,
    )
    return _kotlin_make_providers(
        ctx,
        java_info,
        depset(
            order = "default",
            transitive=[runtime_jars],
            direct=[ctx.outputs.wrapper, ctx.executable._java]
        )
    )

kotlin_test = rule(
    attrs = _test_attr,
    executable = True,
    outputs = _binary_outputs,
    test = True,
    implementation = _kotlin_junit_test_impl,
)
