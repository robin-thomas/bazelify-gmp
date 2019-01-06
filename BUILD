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

cc_library(
    name = "gmp",
    visibility = ["//visibility:public"],
    deps = ["@gmp_6_1_2//:libgmp"],
)
