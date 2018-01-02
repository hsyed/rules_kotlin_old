workspace(name="io_bazel_rules_kotlin")

load("//kotlin:kotlin.bzl", "kotlin_repositories")
kotlin_repositories()


maven_jar(name = "junit_junit",artifact = "junit:junit:jar:4.12")



#load("//:bazel_versions.bzl", "BAZEL_VERSIONS")
#git_repository(
#  name="io_bazel_integration_testing",
#  remote="https://github.com/bazelbuild/bazel-integration-testing",
#  commit="55a6a70"
#)

# Used to demonstrate/test maven dependencies
#
#load("@io_bazel_integration_testing//tools:repositories.bzl", "bazel_binaries")
#bazel_binaries()
#load("@io_bazel_integration_testing//tools:bazel_java_integration_test.bzl", "bazel_java_integration_test")