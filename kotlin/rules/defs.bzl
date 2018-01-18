# The name of the rules repo. Centralised so it's easy to change.
REPO_ROOT = "io_bazel_rules_kotlin"

# The name of the Kotlin compiler workspace.
KOTLIN_REPO_ROOT = "com_github_jetbrains_kotlin"

########################################################################################################################
# Providers
########################################################################################################################
KotlinInfo = provider(
    fields = {
        "src": "the source files. [intelij-aspect]",
        "outputs": "output jars produced by this rule. [intelij-aspect]",
    },
)
