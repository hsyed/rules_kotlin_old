# The name of the rules repo. Centralised so it's easy to change.
REPO_ROOT = "io_bazel_rules_kotlin"

# The name of the Kotlin compiler workspace.
KOTLIN_REPO_ROOT = "com_github_jetbrains_kotlin"

# The files types that may be passed to the core Kotlin compile rule.
_kt_compile_filetypes = FileType([".kt"])

_jar_filetype = FileType([".jar"])

_srcjar_filetype = FileType([
    ".jar",
    "-sources.jar",
])

########################################################################################################################
# Providers
########################################################################################################################
KotlinInfo = provider(
    fields = {
        "src": "the source labels [intelij-aspect]",
        "outputs": "the output jars [intelij-aspect]",
        #   'transitive_exports': 'the transitive closure of all kotlin jars exported by this target'
    },
)

########################################################################################################################
# Rule Attributes
########################################################################################################################
_implicit_deps = {
    "_kotlinw": attr.label(
        default = Label("//kotlin/workers/compilers/jvm"),
        executable = True,
        cfg = "host",
    ),
    # The kotlin runtime
    "_kotlin_runtime": attr.label(
        single_file = True,
        default =
            Label("@" + KOTLIN_REPO_ROOT + "//:runtime"),
    ),
    # The kotlin stdlib
    "_kotlin_std": attr.label_list(default = [
        Label("@" + KOTLIN_REPO_ROOT + "//:stdlib"),
        Label("@" + KOTLIN_REPO_ROOT + "//:stdlib-jdk7"),
        Label("@" + KOTLIN_REPO_ROOT + "//:stdlib-jdk8"),
    ]),
    "_kotlin_reflect": attr.label(
        single_file = True,
        default =
            Label("@" + KOTLIN_REPO_ROOT + "//:reflect"),
    ),
    "_singlejar": attr.label(
        executable = True,
        cfg = "host",
        default = Label("@bazel_tools//tools/jdk:singlejar"),
        allow_files = True,
    ),
    "_zipper": attr.label(
        executable = True,
        cfg = "host",
        default = Label("@bazel_tools//tools/zip:zipper"),
        allow_files = True,
    ),
    "_java": attr.label(
        executable = True,
        cfg = "host",
        default = Label("@bazel_tools//tools/jdk:java"),
        allow_files = True,
    ),
    "_java_stub_template": attr.label(default = Label("@kt_java_stub_template//file")),
    #    "_jar": attr.label(executable=True, cfg="host", default=Label("@bazel_tools//tools/jdk:jar"), allow_files=True),
}

common_attr = _implicit_deps + {
    "srcs": attr.label_list(
        default = [],
        allow_files = _kt_compile_filetypes,
    ),
    # only accept deps which are java providers.
    "deps": attr.label_list(providers = [JavaInfo]),
    "runtime_deps": attr.label_list(default = []),
    # Add debugging info for any rules.
    "verbose": attr.int(default = 0),
    "opts": attr.string_dict(),
    # Advanced options
    "x_opts": attr.string_list(),
    # Plugin options
    "plugin_opts": attr.string_dict(),
    "resources": attr.label_list(
        default = [],
        allow_files = True,
    ),
    "resource_strip_prefix": attr.string(default = ""),
    # Set of archives containing Java resources.
    # If specified, the contents of these jars are merged into the output jar.
    "resource_jars": attr.label_list(default = []),

    # Other args for the compiler
}

runnable_common_attr = common_attr + {
    "data": attr.label_list(
        allow_files = True,
        cfg = "data",
    ),
    "jvm_flags": attr.label_list(
        allow_files = False,
        default = [],
    ),
}

########################################################################################################################
# Outputs: All the outputs produced by the various rules are modelled here.
########################################################################################################################
common_outputs = {
    "jar": "%{name}.jar",
    "srcjar": "%{name}-sources.jar",
}

binary_outputs = common_outputs + {
    "wrapper": "%{name}_wrapper.sh",
}
