### Rules based on compiler/platform

config_setting(
    name = "Wno_unused_variable_linux",
    constraint_values = [
        "@bazel_tools//platforms:linux",
    ],
)

config_setting(
    name = "Wno_unused_variable_osx",
    constraint_values = [
        "@bazel_tools//platforms:osx",
    ],
)

config_setting(
    name = "Wno_unused_but_set_variable",
    constraint_values = [
        "@bazel_tools//platforms:linux",
    ],
)

################################################################################

# Unable to get the new http_archive gets working unless the BUILD
# file is under external/
# Refer: https://stackoverflow.com/questions/51802681/does-bazel-need-external-repo-build-files-to-be-in-workspace-root-external
genrule(
    name = "gmp_hdrs",
    srcs = glob(["**/*"]),
    outs = [
        "config.h",
        "gmp.h",
        "gmp-mparam.h",
        "gmp_limb_bits",
        "gmp_nail_bits",
    ],
    ####
    # Configure script creates *.asm and *.c files in mpn declare_directory.
    #
    # As we do not know the names of these files, it cannot be copied to
    # output directory (since Bazel requires the names in "outs" beforehand).
    # So we package all the *.asm and *.c files into a tar.gz, whose name is
    # mentioned in "outs".
    #
    # Bazel do not support the "srcs" of a cc_library to be compressed file.
    # Hence we use Tree Artifacts to hack the cc_library to compress and get
    # them all compiled.
    # Refer: https://stackoverflow.com/questions/48417712/how-to-build-static-library-from-the-generated-source-files-using-bazel-build
    #
    ####
    cmd = """
        cd external/gmp_6_1_2
        ./configure >/dev/null
        cat gmp.h | grep "#define GMP_LIMB_BITS" | tr -s [:blank:] | cut -f3 -d' ' > gmp_limb_bits
        cat gmp.h | grep "#define GMP_NAIL_BITS" | tr -s [:blank:] | cut -f3 -d' ' > gmp_nail_bits

        cd ../..
        cp external/gmp_6_1_2/config.h $(location config.h)
        cp external/gmp_6_1_2/gmp.h $(location gmp.h)
        cp external/gmp_6_1_2/gmp_limb_bits $(location gmp_limb_bits)
        cp external/gmp_6_1_2/gmp_nail_bits $(location gmp_nail_bits)
        cp external/gmp_6_1_2/gmp-mparam.h $(location gmp-mparam.h)
    """,
    visibility = ["//visibility:public"],
)

### fac_table.h
genrule(
    name = "gen_fac_table_h",
    srcs = [
        "gmp_nail_bits",
        "gmp_limb_bits",
    ],
    outs = ["fac_table.h"],
    cmd = """
        $(location gen_fac) `cat $(location gmp_limb_bits)` `cat $(location gmp_nail_bits)` > $@
    """,
    tools = [":gen_fac"],
    visibility = ["//visibility:public"],
)

cc_binary(
    name = "gen_fac",
    deps = [":gen_fac_deps"],
)

cc_library(
    name = "gen_fac_deps",
    srcs = ["gen-fac.c"],
    hdrs = glob([
        "mini-gmp/mini-gmp.*",
        "bootstrap.c",
    ]),
    copts = select({
        ":Wno_unused_variable_linux": ["-Wno-unused-variable"],
        ":Wno_unused_variable_osx": ["-Wno-unused-variable"],
        "//conditions:default": [],
    }),
)

### fib-table.*
genrule(
    name = "gen_fib_table_c",
    srcs = [
        "gmp_nail_bits",
        "gmp_limb_bits",
    ],
    outs = ["fib_table.c"],
    cmd = """
        $(location gen_fib) table `cat $(location gmp_limb_bits)` `cat $(location gmp_nail_bits)` > $@
    """,
    tools = [":gen_fib"],
)

genrule(
    name = "gen_fib_table_h",
    srcs = [
        "gmp_nail_bits",
        "gmp_limb_bits",
    ],
    outs = ["fib_table.h"],
    cmd = """
        $(location gen_fib) header `cat $(location gmp_limb_bits)` `cat $(location gmp_nail_bits)` > $@
    """,
    tools = [":gen_fib"],
)

cc_binary(
    name = "gen_fib",
    deps = [":gen_fib_deps"],
)

cc_library(
    name = "gen_fib_deps",
    srcs = ["gen-fib.c"],
    hdrs = glob([
        "mini-gmp/mini-gmp.*",
        "bootstrap.c",
    ]),
    copts = select({
        ":Wno_unused_variable_linux": ["-Wno-unused-variable"],
        ":Wno_unused_variable_osx": ["-Wno-unused-variable"],
        "//conditions:default": [],
    }),
)

### jacobitab.h
genrule(
    name = "gen_jacobitab_h",
    outs = ["jacobitab.h"],
    cmd = """
        $(location gen_jacobitab) > $@
    """,
    tools = [":gen_jacobitab"],
)

cc_binary(
    name = "gen_jacobitab",
    deps = [":gen_jacobitab_deps"],
)

cc_library(
    name = "gen_jacobitab_deps",
    srcs = ["gen-jacobitab.c"],
    hdrs = glob([
        "mini-gmp/mini-gmp.*",
        "bootstrap.c",
    ]),
)

### mp_bases.*
genrule(
    name = "gen_mp_bases_c",
    srcs = [
        "gmp_nail_bits",
        "gmp_limb_bits",
    ],
    outs = ["mp_bases.c"],
    cmd = """
        $(location gen_bases) table `cat $(location gmp_limb_bits)` `cat $(location gmp_nail_bits)` > $@
    """,
    tools = [":gen_bases"],
)

genrule(
    name = "gen_mp_bases_h",
    srcs = [
        "gmp_nail_bits",
        "gmp_limb_bits",
    ],
    outs = ["mp_bases.h"],
    cmd = """
        $(location gen_bases) header `cat $(location gmp_limb_bits)` `cat $(location gmp_nail_bits)` > $@
    """,
    tools = [":gen_bases"],
)

cc_binary(
    name = "gen_bases",
    deps = [":gen_bases_deps"],
)

cc_library(
    name = "gen_bases_deps",
    srcs = ["gen-bases.c"],
    hdrs = glob([
        "mini-gmp/mini-gmp.*",
        "bootstrap.c",
    ]),
    copts = select({
        ":Wno_unused_variable_linux": ["-Wno-unused-variable"],
        ":Wno_unused_variable_osx": ["-Wno-unused-variable"],
        "//conditions:default": [],
    }),
)

### perfsqr.h
genrule(
    name = "gen_perfsqr_h",
    srcs = [
        "gmp_nail_bits",
        "gmp_limb_bits",
    ],
    outs = ["perfsqr.h"],
    cmd = """
        $(location gen_psqr) `cat $(location gmp_limb_bits)` `cat $(location gmp_nail_bits)`> $@
    """,
    tools = [":gen_psqr"],
)

cc_binary(
    name = "gen_psqr",
    deps = [":gen_psqr_deps"],
)

cc_library(
    name = "gen_psqr_deps",
    srcs = ["gen-psqr.c"],
    hdrs = glob([
        "mini-gmp/mini-gmp.*",
        "bootstrap.c",
    ]),
    copts = select({
        ":Wno_unused_variable_linux": ["-Wno-unused-variable"],
        ":Wno_unused_variable_osx": ["-Wno-unused-variable"],
        "//conditions:default": [],
    }),
)

### trialdivtab.h
genrule(
    name = "gen_trialdivtab_h",
    srcs = ["gmp_limb_bits"],
    outs = ["trialdivtab.h"],
    cmd = """
        $(location gen_trialdivtab) `cat $(location gmp_limb_bits)` 8000 > $@
    """,
    tools = [":gen_trialdivtab"],
)

cc_binary(
    name = "gen_trialdivtab",
    deps = [":gen_trialdivtab_deps"],
)

cc_library(
    name = "gen_trialdivtab_deps",
    srcs = ["gen-trialdivtab.c"],
    hdrs = glob([
        "mini-gmp/mini-gmp.*",
        "bootstrap.c",
    ]),
    copts = select({
        ":Wno_unused_variable_linux": ["-Wno-unused-variable"],
        ":Wno_unused_variable_osx": ["-Wno-unused-variable"],
        "//conditions:default": [],
    }),
)

################################################################################

### cxx
cc_library(
    name = "cxx",
    srcs = glob(["cxx/*.cc"]),
    hdrs = [
        ":gmp_hdrs",
        ":gen_fib_table_h",
        ":gen_fac_table_h",
        ":gen_mp_bases_h",
    ] + ["gmp-impl.h"],
    copts = select({
        ":Wno_unused_but_set_variable": ["-Wno-unused-but-set-variable"],
        "//conditions:default": [],
    }),
)

### mpf
cc_library(
    name = "mpf",
    srcs = glob(["mpf/*.c"]),
    hdrs = [
        ":gmp_hdrs",
        ":gen_fib_table_h",
        ":gen_fac_table_h",
        ":gen_mp_bases_h",
    ] + glob([
        "mpf/*.h",
        "gmp-impl.h",
        "longlong.h",
    ]),
)

### mpn
genrule(
    name = "gen_mpn_objs",
    srcs = [
        "fac_table.h",
        "fib_table.h",
        "jacobitab.h",
        "mp_bases.h",
        "perfsqr.h",
        "trialdivtab.h",
    ] + glob(["**/*"]),
    outs = ["mpn_generated.tar.gz"],
    cmd = """
        cp $(location fac_table.h) external/gmp_6_1_2
        cp $(location fib_table.h) external/gmp_6_1_2
        cp $(location jacobitab.h) external/gmp_6_1_2
        cp $(location mp_bases.h) external/gmp_6_1_2
        cp $(location perfsqr.h) external/gmp_6_1_2
        cp $(location trialdivtab.h) external/gmp_6_1_2

        cd external/gmp_6_1_2
        ./configure >/dev/null

        cd mpn
        CCAS_=`grep "CCAS =" Makefile | cut -d'=' -f2`
        CPP_FLAGS_="-DHAVE_CONFIG_H -D__GMP_WITHIN_GMP -I. -I.. "
        CPP_FLAGS_=$${CPP_FLAGS_}`grep "CFLAGS =" Makefile | sed 's/^[^=]*=//g'`
        for file in *.asm; do
            prefix=$${file%.*}
            m4 -DOPERATION_$${prefix} -I.. $${file} > tmp-$${prefix}.s
            $${CCAS_} -DOPERATION_$${prefix} $${CPP_FLAGS_} tmp-$${prefix}.s -o $${prefix}.o
            rm -rf tmp-$${prefix}.s
        done
        for file in *.c; do
            prefix=$${file%.*}
            $${CCAS_} -DOPERATION_$${prefix} $${CPP_FLAGS_} $${file} -o $${prefix}.o
        done
        tar -czf mpn_generated.tar.gz *.o
        cp mpn_generated.tar.gz /tmp
        cd ../../..
        cp external/gmp_6_1_2/mpn/mpn_generated.tar.gz $(location mpn_generated.tar.gz)
    """,
    visibility = ["//visibility:public"],
)

cc_library(
    name = "mpn",
    srcs = [
        ":gen_fib_table_c",
        ":gen_mp_bases_c",
        ":gmp_hdrs",
        "@//:mpn_asm_tree",
    ],
    hdrs = [
        "fac_table.h",
        "fib_table.h",
        "gmp-impl.h",
        "jacobitab.h",
        "longlong.h",
        "mp_bases.h",
        "trialdivtab.h",
    ],
    copts = select({
        ":Wno_unused_variable_linux": ["-Wno-unused-variable"],
        ":Wno_unused_variable_osx": ["-Wno-unused-variable"],
        "//conditions:default": [],
    }),
    visibility = ["//visibility:public"],
)

### mpq
cc_library(
    name = "mpq",
    srcs = glob(["mpq/*.c"]),
    hdrs = [
        ":gmp_hdrs",
        ":gen_fib_table_h",
        ":gen_fac_table_h",
        ":gen_mp_bases_h",
    ] + glob([
        "mpq/*.h",
        "gmp-impl.h",
        "longlong.h",
    ]),
)

### mpz
cc_library(
    name = "mpz",
    srcs = glob(["mpz/*.c"]),
    hdrs = [
        ":gmp_hdrs",
        ":gen_fib_table_h",
        ":gen_fac_table_h",
        ":gen_mp_bases_h",
    ] + glob([
        "mpz/*.h",
        "gmp-impl.h",
        "longlong.h",
    ]),
)

### printf
cc_library(
    name = "printf",
    srcs = glob(["printf/*.c"]),
    hdrs = [
        "gmp-impl.h",
        "longlong.h",
        ":gen_fac_table_h",
        ":gen_fib_table_h",
        ":gen_mp_bases_h",
        ":gmp_hdrs",
    ],
    copts = select({
        ":Wno_unused_but_set_variable": ["-Wno-unused-but-set-variable"],
        "//conditions:default": [],
    }),
)

### random
cc_library(
    name = "random",
    srcs = glob([
        "rand/*.c",
        "rand/*.h",
    ]),
    hdrs = [
        "gmp-impl.h",
        "longlong.h",
        ":gen_fac_table_h",
        ":gen_fib_table_h",
        ":gen_mp_bases_h",
        ":gmp_hdrs",
    ],
    copts = select({
        ":Wno_unused_but_set_variable": ["-Wno-unused-but-set-variable"],
        "//conditions:default": [],
    }),
)

### scanf
cc_library(
    name = "scanf",
    srcs = glob(["scanf/*.c"]),
    hdrs = [
        "gmp-impl.h",
        ":gen_fac_table_h",
        ":gen_fib_table_h",
        ":gen_mp_bases_h",
        ":gmp_hdrs",
    ],
    copts = select({
        ":Wno_unused_but_set_variable": ["-Wno-unused-but-set-variable"],
        "//conditions:default": [],
    }),
    visibility = ["//visibility:public"],
)

################################################################################

### gmp
# Need to build it like binary, as bazel doesnt support loading symbols from
# transitive static dependencies.
# Refer: https://docs.google.com/document/d/1d4SPgVX-OTCiEK_l24DNWiFlT14XS5ZxD7XhttFbvrI/
cc_binary(
    name = "libgmp.so",
    srcs = [
        "assert.c",
        "compat.c",
        "errno.c",
        "extract-dbl.c",
        "gmp-impl.h",
        "invalid.c",
        "longlong.h",
        "memory.c",
        "mp_bpl.c",
        "mp_clz_tab.c",
        "mp_dv_tab.c",
        "mp_get_fns.c",
        "mp_minv_tab.c",
        "mp_set_fns.c",
        "nextprime.c",
        "primesieve.c",
        "version.c",
        ":gen_fac_table_h",
        ":gen_fib_table_h",
        ":gen_mp_bases_h",
        ":gmp_hdrs",
    ],
    copts = select({
        ":Wno_unused_variable_linux": ["-Wno-unused-variable"],
        ":Wno_unused_variable_osx": ["-Wno-unused-variable"],
        "//conditions:default": [],
    }),
    linkopts = ["-shared"],
    visibility = ["//visibility:public"],
    deps = [
        ":mpf",
        ":mpn",
        ":mpq",
        ":mpz",
        ":printf",
        ":random",
        ":scanf",
    ],
)

### gmpxx
# Need to build it like binary, as bazel doesnt support loading symbols from
# transitive static dependencies.
# Refer: https://docs.google.com/document/d/1d4SPgVX-OTCiEK_l24DNWiFlT14XS5ZxD7XhttFbvrI/
cc_binary(
    name = "libgmpxx.so",
    srcs = [
        "cxx/dummy.cc",
        ":libgmp.so",
    ],
    linkopts = ["-shared"],
    visibility = ["//visibility:public"],
    deps = [":cxx"],
)
