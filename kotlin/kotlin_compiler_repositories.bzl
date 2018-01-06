"""This file contains the Kotlin compiler repository definitions.
"""

load("//kotlin/rules:defs.bzl", "KOTLIN_REPO_ROOT")

KOTLIN_RELEASES = {
    "1.2.10": {
        "version": "1.2.10",
        "url": "https://github.com/JetBrains/kotlin/releases/download/v1.2.10/kotlin-compiler-1.2.10.zip",
        "sha256": "95874568919121acb694bec0d6c92c60bdceea53f4c202e23ab734e94a0c26e3",
    },
    "1.2.0": {
        "version": "1.2.0",
        "url": "https://github.com/JetBrains/kotlin/releases/download/v1.2.0/kotlin-compiler-1.2.0.zip",
        "sha256": "895d0f8286db3e4f43d67cd5e09b600af6e0a5017cb74072d1b09c78b697775a",
    },
}

KOTLIN_COMPILER_REPO_BUILD_FILE = """
package(default_visibility = ["//visibility:public"])

filegroup(
    name = "home",
    srcs = glob(["lib/*.jar"], exclude = ["lib/*-sources.jar"]),
)

java_import(
    name = "runtime",
    jars = ["lib/kotlin-runtime.jar"],
    srcjar = "lib/kotlin-runtime-sources.jar"
)

java_import(
    name = "stdlib",
    jars = ["lib/kotlin-stdlib.jar"],
    srcjar = "lib/kotlin-stdlib-sources.jar"
)

java_import(
    name = "stdlib-jdk7",
    jars = ["lib/kotlin-stdlib-jdk7.jar"],
    srcjar = "lib/kotlin-stdlib-jdk7-sources.jar"
)

java_import(
    name = "stdlib-jdk8",
    jars = ["lib/kotlin-stdlib-jdk8.jar"],
    srcjar = "lib/kotlin-stdlib-jdk8-sources.jar"
)

java_import(
    name = "reflect",
    jars = ["lib/kotlin-reflect.jar"],
    srcjar = "lib/kotlin-reflect-sources.jar"
)

java_import(
    name = "compiler",
    jars = ["lib/kotlin-compiler.jar"],
)

java_import(
    name = "script-runtime",
    jars = ["lib/kotlin-script-runtime.jar"],
)

java_import(
    name = "preloader",
    jars = ["lib/kotlin-preloader.jar"],
)

java_import(
    name = "test",
    jars = ["lib/kotlin-test.jar"],
)

sh_binary(
    name = "kotlin",
    srcs = ["bin/kotlin"],
)

sh_binary(
    name = "kotlinc",
    srcs = ["bin/kotlinc"],
)

exports_files(["src"])
"""

KOTLIN_CURRENT_RELEASE = "1.2.10"

_BAZEL_JAVA_LAUNCHER_VERSION = "0.8.1"

def kotlin_compiler_repository(
    kotlin_release_version=KOTLIN_CURRENT_RELEASE
):
    release=KOTLIN_RELEASES[kotlin_release_version]
    if not release:
        fail('"%s" not a valid kotlin release, current release is "%s"' % (kotlin_release_version, KOTLIN_CURRENT_RELEASE))

    native.new_http_archive(
        name = KOTLIN_REPO_ROOT,
        url = release["url"],
        sha256 = release["sha256"],
        build_file_content= KOTLIN_COMPILER_REPO_BUILD_FILE,
        strip_prefix = "kotlinc",
    )

    native.maven_jar(
        name = "io_bazel_rules_kotlin_protobuf_protobuf_java",
        artifact = "com.google.protobuf:protobuf-java:3.4.0",
        sha1 = "b32aba0cbe737a4ca953f71688725972e3ee927c",
    )


    native.http_file(
        name = "kt_java_stub_template",
        url = ("https://raw.githubusercontent.com/bazelbuild/bazel/" +
               _BAZEL_JAVA_LAUNCHER_VERSION +
           "/src/main/java/com/google/devtools/build/lib/bazel/rules/java/" +
           "java_stub_template.txt"),
        sha256 = "86660ee7d5b498ccf611a1e000564f45268dbf301e0b2b08c984dcecc6513f6e",
    )