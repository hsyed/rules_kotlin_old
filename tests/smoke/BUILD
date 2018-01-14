load("//kotlin:kotlin.bzl", "kotlin_library", "kotlin_binary", "kotlin_test")

# a test resource library.
java_library(
    name = "resourcejar",
    resources = glob(["resourcejar/**"]),
    resource_strip_prefix = "tests/smoke/resourcejar"
)

kotlin_test(
    name = "junittest",
    srcs = glob(["junittest/JunitTest.kt"]),
    test_class="tests.smoke.junittest.JunitTest",
    size="small",
    data=glob(["data/*"]),
    deps = ["@junit_junit//jar"]
)

kotlin_library(
    name = "test_merge_resourcesjar",
    srcs = glob(["testresources/src/*.kt"]),
    resource_jars = [":resourcejar"],
)

kotlin_library(
    name = "test_embed_resources",
    srcs = glob(["testresources/src/*.kt"]),
    resources = glob(["testresources/resources/**/*"])
)

kotlin_library(
    name = "test_embed_resources_strip_prefix",
    srcs = glob(["testresources/src/*.kt"]),
    resources = glob(["testresources/resources/**/*"]),
    resource_strip_prefix = "tests/smoke/testresources/resources"
)

kotlin_library(
    name = "conventional_strip_resources",
    srcs = glob(["testresources/src/*.kt"]),
    resources = glob(["conventional_strip_resources/src/main/resources/**/*", "conventional_strip_resources/src/test/resources/**/*"])
)

kotlin_library(
    name = "propagation_test_exporter_lib",
    srcs = ["propagation/Stub.kt"],
    exports = ["@junit_junit//jar"]
)

kotlin_library(
    name = "propagation_test_runtime_lib",
    srcs = ["propagation/Stub.kt"],
    runtime_deps = ["@junit_junit//jar"]
)

java_binary(
    name = "propagation_ct_consumer",
    main_class = "testing.CompileTimeDependent",
    srcs = ["propagation/CompileTimeDependent.java"],
    deps = [":propagation_test_exporter_lib"]
)

java_binary(
    name = "propagation_ct_consumer_fail_on_runtime",
    main_class = "testing.CompileTimeDependent",
    srcs = ["propagation/CompileTimeDependent.java"],
    deps = [":propagation_test_runtime_lib"]
)

java_binary(
    name = "propagation_rt_via_export_consumer",
    main_class = "testing.RuntimeDependent",
    srcs = ["propagation/RuntimeDependent.java"],
    deps = [":propagation_test_exporter_lib"]
)

java_binary(
    name = "propagation_rt_via_runtime_deps_consumer",
    main_class = "testing.RuntimeDependent",
    srcs = ["propagation/RuntimeDependent.java"],
    deps = [":propagation_test_runtime_lib"]
)

kotlin_binary(
    name="helloworld",
    srcs=glob(["helloworld/Main.kt"]),
    main_class= "helloworld.Main",
    data=glob(["data/*"]),
)