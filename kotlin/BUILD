package(default_visibility = ["//visibility:private"])
load("@io_bazel_skydoc//skylark:skylark.bzl", "skylark_doc", "skylark_library" )

skylark_library(
    name = "doc_public",
    srcs = [
        "kotlin.bzl"
    ],
    visibility=["//visibility:private"]
)

skylark_doc(
    name = "docs",
    deps = [
        ":doc_public",
    ],
    format = "html",
    site_root = select({
        ":local": "/tmp/rules_kotlin",
        "//conditions:default": "https://hsyed.github.io/rules_kotlin"
#        "//conditions:default": "https://bazelbuild.github.io/rules_kotlin"
    }),
    visibility = ["//visibility:public"]
)

config_setting(
    name = "local",
    values = {
        "define": "local=1",
    }
)