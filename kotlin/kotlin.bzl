load("//kotlin:kotlin_compiler_repositories.bzl", "kotlin_compiler_repository", "KOTLIN_CURRENT_RELEASE")
load("//kotlin/rules:test_rules.bzl", "kotlin_test")
load("//kotlin/rules:basic_rules.bzl", "kotlin_library", "kotlin_binary")

def kotlin_repositories(
    kotlin_release_version=KOTLIN_CURRENT_RELEASE
):
    kotlin_compiler_repository(kotlin_release_version)
