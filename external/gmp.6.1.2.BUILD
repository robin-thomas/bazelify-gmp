### Rules based on compiler/platform

config_setting(
    name = "Wno_unused_variable_linux",
    constraint_values = [
        "@bazel_tools//platforms:linux",
    ]
)

config_setting(
    name = "Wno_unused_variable_osx",
    constraint_values = [
        "@bazel_tools//platforms:osx",
    ]
)

config_setting(
    name = "Wno_unused_but_set_variable",
    constraint_values = [
        "@bazel_tools//platforms:linux",
    ]
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
        "mpn_generated.tar.gz",
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
    # But since these files are symmlinks and Bazel do not allow symlinks inside
    # a Tree Artifact, whose target is outside the Tree Artifact, we create
    # copies of *.c files to put inside the tar.gz
    ####
    cmd = """
        cd external/gmp_6_1_2
        ./configure >/dev/null
        cat gmp.h | grep "#define GMP_LIMB_BITS" | tr -s [:blank:] | cut -f3 -d' ' > gmp_limb_bits
        cat gmp.h | grep "#define GMP_NAIL_BITS" | tr -s [:blank:] | cut -f3 -d' ' > gmp_nail_bits
        cd mpn
        for file in *.asm; do
            prefix=$${file%.*}
            m4 -DOPERATION_$${prefix} -I.. $${file} > tmp-$${prefix}.s
        done
        for file in *.c; do
            cp $${file} tmp-$${file}
        done
        tar -czf ../mpn_generated.tar.gz *.s tmp-*.c
        cp ../mpn_generated.tar.gz /tmp
        cd ../../..
        cp external/gmp_6_1_2/config.h $(location config.h)
        cp external/gmp_6_1_2/gmp.h $(location gmp.h)
        cp external/gmp_6_1_2/gmp_limb_bits $(location gmp_limb_bits)
        cp external/gmp_6_1_2/gmp_nail_bits $(location gmp_nail_bits)
        cp external/gmp_6_1_2/gmp-mparam.h $(location gmp-mparam.h)
        cp external/gmp_6_1_2/mpn_generated.tar.gz $(location mpn_generated.tar.gz)
    """,
    visibility = ["//visibility:public"],
)

### fac_table.h
genrule(
    name = "gen_fac_table_h",
    srcs = ["gmp_nail_bits", "gmp_limb_bits"],
    outs = ["fac_table.h"],
    tools = [":gen_fac"],
    cmd = """
        $(location gen_fac) `cat $(location gmp_limb_bits)` `cat $(location gmp_nail_bits)` > $@
    """,
    visibility = ["//visibility:public"],
)
cc_binary(
    name = "gen_fac",
    deps = [":gen_fac_deps"],
)
cc_library(
    name = "gen_fac_deps",
    srcs = ["gen-fac.c"],
    hdrs = glob(["mini-gmp/mini-gmp.*", "bootstrap.c"]),
    copts = select({
        ":Wno_unused_variable_linux": ["-Wno-unused-variable"],
        ":Wno_unused_variable_osx": ["-Wno-unused-variable"],
        "//conditions:default": [],
    }),
)

### fib-table.*
genrule(
    name = "gen_fib_table_c",
    srcs = ["gmp_nail_bits", "gmp_limb_bits"],
    outs = ["fib_table.c"],
    tools = [":gen_fib"],
    cmd = """
        $(location gen_fib) table `cat $(location gmp_limb_bits)` `cat $(location gmp_nail_bits)` > $@
    """,
)
genrule(
    name = "gen_fib_table_h",
    srcs = ["gmp_nail_bits", "gmp_limb_bits"],
    outs = ["fib_table.h"],
    tools = [":gen_fib"],
    cmd = """
        $(location gen_fib) header `cat $(location gmp_limb_bits)` `cat $(location gmp_nail_bits)` > $@
    """,
)
cc_binary(
    name = "gen_fib",
    deps = [":gen_fib_deps"],
)
cc_library(
    name = "gen_fib_deps",
    srcs = ["gen-fib.c"],
    hdrs = glob(["mini-gmp/mini-gmp.*", "bootstrap.c"]),
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
    tools = [":gen_jacobitab"],
    cmd = """
        $(location gen_jacobitab) > $@
    """,
)
cc_binary(
    name = "gen_jacobitab",
    deps = [":gen_jacobitab_deps"],
)
cc_library(
    name = "gen_jacobitab_deps",
    srcs = ["gen-jacobitab.c"],
    hdrs = glob(["mini-gmp/mini-gmp.*", "bootstrap.c"]),
)

### mp_bases.*
genrule(
    name = "gen_mp_bases_c",
    srcs = ["gmp_nail_bits", "gmp_limb_bits"],
    outs = ["mp_bases.c"],
    tools = [":gen_bases"],
    cmd = """
        $(location gen_bases) table `cat $(location gmp_limb_bits)` `cat $(location gmp_nail_bits)` > $@
    """,
)
genrule(
    name = "gen_mp_bases_h",
    srcs = ["gmp_nail_bits", "gmp_limb_bits"],
    outs = ["mp_bases.h"],
    tools = [":gen_bases"],
    cmd = """
        $(location gen_bases) header `cat $(location gmp_limb_bits)` `cat $(location gmp_nail_bits)` > $@
    """,
)
cc_binary(
    name = "gen_bases",
    deps = [":gen_bases_deps"],
)
cc_library(
    name = "gen_bases_deps",
    srcs = ["gen-bases.c"],
    hdrs = glob(["mini-gmp/mini-gmp.*", "bootstrap.c"]),
    copts = select({
        ":Wno_unused_variable_linux": ["-Wno-unused-variable"],
        ":Wno_unused_variable_osx": ["-Wno-unused-variable"],
        "//conditions:default": [],
    }),
)

### perfsqr.h
genrule(
    name = "gen_perfsqr_h",
    outs = ["perfsqr.h"],
    tools = [":gen_perfsqr"],
    cmd = """
        $(location gen_perfsqr) > $@
    """,
)
cc_binary(
    name = "gen_perfsqr",
    deps = [":gen_perfsqr_deps"],
)
cc_library(
    name = "gen_perfsqr_deps",
    srcs = ["gen-perfsqr.c"],
    hdrs = glob(["mini-gmp/mini-gmp.*", "bootstrap.c"]),
)

### trialdivtab.h
genrule(
    name = "gen_trialdivtab_h",
    srcs = ["gmp_limb_bits"],
    outs = ["trialdivtab.h"],
    tools = [":gen_trialdivtab"],
    cmd = """
        $(location gen_trialdivtab) `cat $(location gmp_limb_bits)` 8000 > $@
    """,
)
cc_binary(
    name = "gen_trialdivtab",
    deps = [":gen_trialdivtab_deps"],
)
cc_library(
    name = "gen_trialdivtab_deps",
    srcs = ["gen-trialdivtab.c"],
    hdrs = glob(["mini-gmp/mini-gmp.*", "bootstrap.c"]),
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
        ":gen_mp_bases_h"] + ["gmp-impl.h"],
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
        ":gen_mp_bases_h"] + glob(["mpf/*.h", "gmp-impl.h", "longlong.h"]),
)

### mpn
cc_library(
    name = "mpn",
#    srcs = [":gen_fib_table_c", ":gen_mp_bases_c", ":gmp_hdrs", "@//:mpn_asm_tree"],
    srcs = [":gen_fib_table_c", ":gen_mp_bases_c", ":gmp_hdrs"],
    hdrs = [
        ":gen_fib_table_h",
        ":gen_fac_table_h",
        ":gen_mp_bases_h",
        "gmp-impl.h",
        "longlong.h",
    ] + glob(["mpn/*.h"]),
)

### mpq
cc_library(
    name = "mpq",
    srcs = glob(["mpq/*.c"]),
    hdrs = [
        ":gmp_hdrs",
        ":gen_fib_table_h",
        ":gen_fac_table_h",
        ":gen_mp_bases_h"] + glob(["mpq/*.h", "gmp-impl.h", "longlong.h"]),
)

### mpz
cc_library(
    name = "mpz",
    srcs = glob(["mpz/*.c"]),
    hdrs = [
        ":gmp_hdrs",
        ":gen_fib_table_h",
        ":gen_fac_table_h",
        ":gen_mp_bases_h"] + glob(["mpz/*.h", "gmp-impl.h", "longlong.h"]),
)

### printf
cc_library(
    name = "printf",
    srcs = glob(["printf/*.c"]),
    hdrs = [
        ":gmp_hdrs",
        ":gen_fib_table_h",
        ":gen_fac_table_h",
        ":gen_mp_bases_h",
        "gmp-impl.h",
        "longlong.h"
    ],
    copts = select({
        ":Wno_unused_but_set_variable": ["-Wno-unused-but-set-variable"],
        "//conditions:default": [],
    }),
)

### random
cc_library(
    name = "random",
    srcs = glob(["rand/*.c", "rand/*.h"]),
    hdrs = [
        ":gmp_hdrs",
        ":gen_fib_table_h",
        ":gen_fac_table_h",
        ":gen_mp_bases_h",
        "gmp-impl.h",
        "longlong.h"
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
        ":gmp_hdrs",
        ":gen_fib_table_h",
        ":gen_fac_table_h",
        ":gen_mp_bases_h",
        "gmp-impl.h"
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
        "invalid.c",
        "memory.c",
        "mp_bpl.c",
        "mp_clz_tab.c",
        "mp_dv_tab.c",
        "mp_minv_tab.c",
        "mp_get_fns.c",
        "mp_set_fns.c",
        "version.c",
        "nextprime.c",
        "primesieve.c",
        "gmp-impl.h",
        "longlong.h",
        ":gmp_hdrs",
        ":gen_fib_table_h",
        ":gen_fac_table_h",
        ":gen_mp_bases_h",
    ],
    linkopts = ["-shared"],
    deps = [":mpf", ":mpz", ":mpq", ":mpn", ":printf", ":scanf", ":random"],
    visibility = ["//visibility:public"],
    copts = select({
        ":Wno_unused_variable_linux": ["-Wno-unused-variable"],
        ":Wno_unused_variable_osx": ["-Wno-unused-variable"],
        "//conditions:default": [],
    }),
)

### gmpxx
# Need to build it like binary, as bazel doesnt support loading symbols from
# transitive static dependencies.
# Refer: https://docs.google.com/document/d/1d4SPgVX-OTCiEK_l24DNWiFlT14XS5ZxD7XhttFbvrI/
cc_binary(
    name = "libgmpxx.so",
    srcs = ["cxx/dummy.cc", ":libgmp.so"],
    deps = [":cxx"],
    linkopts = ["-shared"],
    visibility = ["//visibility:public"],
)
