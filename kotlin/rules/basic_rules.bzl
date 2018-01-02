load(
    "//kotlin/rules:defs.bzl",
    _binary_outputs = "binary_outputs",
    _common_attr = "common_attr",
    _common_outputs = "common_outputs",
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

def _kotlin_library_impl(ctx):
  return _kotlin_make_providers(ctx, _kotlin_compile_action(ctx))

kotlin_library = rule(
    attrs = _common_attr + {
        "exports": attr.label_list(providers = [JavaInfo]),
    },
    outputs = _common_outputs,
    implementation = _kotlin_library_impl,
)

def _kotlin_binary_impl(ctx):
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

kotlin_binary = rule(
    attrs = _runnable_common_attr + {
        "main_class": attr.string(mandatory = True),
    },
    executable = True,
    outputs = _binary_outputs,
    implementation = _kotlin_binary_impl,
)
