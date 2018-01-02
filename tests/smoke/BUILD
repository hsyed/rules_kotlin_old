load("//kotlin:kotlin.bzl", "kotlin_library", "kotlin_binary", "kotlin_test")

#genquery(name = "lib_test", expression = 'filter("^//", kind(".*_library", deps(//:lib)))',scope = ["//:lib"])

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

"a library that exports a dependency"
kotlin_library(
    name = "testresources",
    srcs = glob(["testresources/*.kt"]),
    resources = glob(["testresources/resources/**"]),
    resource_jars = [":resourcejar"],
    resource_strip_prefix = "tests/smoke/testresources/resources",
)

kotlin_binary(
    name="helloworld",
    srcs=glob(["helloworld/Main.kt"]),
    main_class= "helloworld.Main",
    data=glob(["data/*"]),
    opts={
        "jvm-target": "1.8"
    },
)