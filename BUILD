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

### gmp
# Need to build it like binary, as bazel doesnt support loading symbols from
# transitive static dependencies.
# Refer: https://docs.google.com/document/d/1d4SPgVX-OTCiEK_l24DNWiFlT14XS5ZxD7XhttFbvrI/
cc_binary(
    name = "gmp-lib",
    srcs = [
        "@gmp_6_1_2//:assert.c",
        "@gmp_6_1_2//:compat.c",
        "@gmp_6_1_2//:errno.c",
        "@gmp_6_1_2//:extract-dbl.c",
        "@gmp_6_1_2//:gmp-impl.h",
        "@gmp_6_1_2//:invalid.c",
        "@gmp_6_1_2//:longlong.h",
        "@gmp_6_1_2//:memory.c",
        "@gmp_6_1_2//:mp_bpl.c",
        "@gmp_6_1_2//:mp_clz_tab.c",
        "@gmp_6_1_2//:mp_dv_tab.c",
        "@gmp_6_1_2//:mp_get_fns.c",
        "@gmp_6_1_2//:mp_minv_tab.c",
        "@gmp_6_1_2//:mp_set_fns.c",
        "@gmp_6_1_2//:nextprime.c",
        "@gmp_6_1_2//:primesieve.c",
        "@gmp_6_1_2//:version.c",
        "@gmp_6_1_2//:gen_fac_table_h",
        "@gmp_6_1_2//:gen_fib_table_h",
        "@gmp_6_1_2//:gen_mp_bases_h",
        "@gmp_6_1_2//:gmp_hdrs",
    ],
    copts = select({
        "@gmp_6_1_2//:Wno_unused_variable_linux": ["-Wno-unused-variable"],
        "@gmp_6_1_2//:Wno_unused_variable_osx": ["-Wno-unused-variable"],
        "//conditions:default": [],
    }),
    linkopts = ["-shared", "-fPIC"],
    visibility = ["//visibility:public"],
    deps = [
        "@gmp_6_1_2//:mpf",
        "@gmp_6_1_2//:mpn",
        "@gmp_6_1_2//:mpq",
        "@gmp_6_1_2//:mpz",
        "@gmp_6_1_2//:printf",
        "@gmp_6_1_2//:random",
        "@gmp_6_1_2//:scanf",
    ],
)

load("@com_github_bazelbuild_buildtools//buildifier:def.bzl", "buildifier")

buildifier(
    name = "buildifier",
)
