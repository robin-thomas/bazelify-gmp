load(":genccs.bzl", "genccs")

genccs(
    name = "mpn_asm_tree",
    visibility = ["//visibility:public"],
)

genrule(
    name = "mpn_generated",
    srcs = ["@gmp_6_1_2//:mpn_generated.tar.gz"],
    outs = ["mpn_generated.sh"],
    cmd = """
        echo "#!/bin/sh" > $@
        echo "tar -xzf /tmp/mpn_generated.tar.gz -C \$$1" >> $@
    """,
)

sh_binary(
    name = "genccs",
    srcs = [":mpn_generated"],
    data = ["@gmp_6_1_2//:mpn_generated.tar.gz"],
    visibility = ["//visibility:public"],
)

config_setting(
    name = "gmp_win_select_dll",
    constraint_values = [
        "@bazel_tools//platforms:windows",
    ],
)

cc_library(
    name = "gmp",
    visibility = ["//visibility:public"],
    deps = select({
        ":gmp_win_select_dll": ["@gmp_win//:libgmp_win"],
        "//conditions:default": ["@gmp_6_1_2//:libgmp"],
    }),
)
