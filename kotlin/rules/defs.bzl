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
