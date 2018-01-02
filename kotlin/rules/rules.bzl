load(
    "//kotlin/rules:compile.bzl",
    _kotlin_compile_action = "kotlin_compile_action",
    _kotlin_make_providers = "kotlin_make_providers",
)
load(
    "//kotlin/rules:util.bzl",
    _kotlin_write_launcher_action = "kotlin_write_launcher_action",
)

def kotlin_library_impl(ctx):
  return _kotlin_make_providers(ctx, _kotlin_compile_action(ctx))

def kotlin_binary_impl(ctx):
    java_info = _kotlin_compile_action(ctx)
    _kotlin_write_launcher_action(
        ctx,
        java_info.transitive_runtime_jars,
        ctx.attr.main_class,
        ctx.attr.jvm_flags
    )
    return _kotlin_make_providers(
        ctx,
        java_info,
        depset(
            order = "default",
            transitive=[java_info.transitive_runtime_jars],
            direct=[ctx.outputs.wrapper, ctx.executable._java]
        )
    )

def kotlin_junit_test_impl(ctx):
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