workspace(name="io_bazel_rules_kotlin")

git_repository(
    name = "io_bazel_rules_sass",
    remote = "https://github.com/bazelbuild/rules_sass.git",
    tag = "0.0.3",
)
load("@io_bazel_rules_sass//sass:sass.bzl", "sass_repositories")
sass_repositories()

git_repository(
    name = "io_bazel_skydoc",
    remote = "https://github.com/bazelbuild/skydoc.git",
    commit = "b36d22c"
)
load("@io_bazel_skydoc//skylark:skylark.bzl", "skydoc_repositories")
skydoc_repositories()

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