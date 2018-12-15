genrule(
    name = "gmp_hdrs",
    srcs = glob(["**/*"]),
    outs = [
        "config.h",
        "gmp.h",
        "gmp-mparam.h",
    ],
    cmd = """
        cd external/gmp_6_1_2
        ./configure >/dev/null
        cd ../..
        cp external/gmp_6_1_2/config.h $(location config.h)
        cp external/gmp_6_1_2/gmp.h $(location gmp.h)
        cp external/gmp_6_1_2/gmp-mparam.h $(location gmp-mparam.h)
    """,
)

### fac_table.h
#TODO: figure out how to get the value of 64 and 0 from configure script
genrule(
    name = "gen_fac_table_h",
    outs = ["fac_table.h"],
    tools = [":gen_fac"],
    cmd = """
        $(location gen_fac) 64 0 > $@
    """,
)
cc_binary(
    name = "gen_fac",
    deps = [":gen_fac_deps"],
)
cc_library(
    name = "gen_fac_deps",
    srcs = ["gen-fac.c"],
    hdrs = glob(["mini-gmp/mini-gmp.*", "bootstrap.c"]),
    copts = ["-Wno-unused-variable"],
)

### fib-table.*
#TODO: figure out how to get the value of 64 and 0 from configure script
genrule(
    name = "gen_fib_table_c",
    outs = ["fib_table.c"],
    tools = [":gen_fib"],
    cmd = """
        $(location gen_fib) table 64 0 > $@
    """,
)
genrule(
    name = "gen_fib_table_h",
    outs = ["fib_table.h"],
    tools = [":gen_fib"],
    cmd = """
        $(location gen_fib) header 64 0 > $@
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
    copts = ["-Wno-unused-variable"],
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
    copts = ["-Wno-unused-variable"],
)

### mp_bases.*
#TODO: figure out how to get the value of 64 and 0 from configure script
genrule(
    name = "gen_mp_bases_c",
    outs = ["mp_bases.c"],
    tools = [":gen_bases"],
    cmd = """
        $(location gen_bases) table 64 0 > $@
    """,
)
genrule(
    name = "gen_mp_bases_h",
    outs = ["mp_bases.h"],
    tools = [":gen_bases"],
    cmd = """
        $(location gen_bases) header 64 0 > $@
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
    copts = ["-Wno-unused-variable"],
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
    copts = ["-Wno-unused-variable"],
)

### trialdivtab.h
genrule(
    name = "gen_trialdivtab_h",
    outs = ["trialdivtab.h"],
    tools = [":gen_trialdivtab"],
    cmd = """
        $(location gen_trialdivtab) 64 8000 > $@
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
    copts = ["-Wno-unused-variable"],
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
    copts = ["-Wno-unused-but-set-variable"],
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
    srcs = [":gen_fib_table_c", ":gen_mp_bases_c"],
    hdrs = [
        ":gmp_hdrs",
        ":gen_fib_table_h",
        ":gen_fac_table_h",
        ":gen_mp_bases_h",
        "gmp-impl.h"
    ],
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
    copts = ["-Wno-unused-but-set-variable"],
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
    copts = ["-Wno-unused-but-set-variable"],
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
    copts = ["-Wno-unused-but-set-variable"],
)

################################################################################

### gmp
cc_library(
    name = "gmp",
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
    ],
    hdrs = ["gmp-impl.h", "longlong.h"],
    deps = [":mpf", ":mpz", ":mpq", ":mpn", ":printf", ":scanf", ":random"],
    visibility = ["//visibility:public"],
)

### gmpxx
cc_library(
    name = "gmpxx",
    srcs = ["cxx/dummy.cc"],
    deps = [":gmp", ":cxx"],
    visibility = ["//visibility:public"],
)

### tests
cc_library(
    name = "tests",
    srcs = [
        "tests/memory.c",
        "tests/misc.c",
        "tests/refmpf.c",
        "tests/refmpn.c",
        "tests/refmpq.c",
        "tests/refmpz.c",
        "tests/spinner.c",
        "tests/trace.c",
        "tests/tests.h",
#        "tests/amd64call.asm",
#        "tests/amd64check.c",
#        "tests/x86call.asm",
#        "tests/x86check.c",
#        "tests/arm32call.asm",
#        "tests/arm32check.c",
    ],
    deps = [":gmp"],
    visibility = ["//visibility:public"],
    copts = ["-Wno-unused-but-set-variable"],
)

################################################################################

### speed

cc_library(
    name = "speed",
    srcs = [
        "tune/common.c",
        "tune/divrem1div.c",
        "tune/divrem1inv.c",
        "tune/divrem2div.c",
        "tune/divrem2inv.c",
        "tune/div_qr_1n_pi1_1.c",
        "tune/div_qr_1n_pi1_2.c",
        "tune/div_qr_1_tune.c",
        "tune/freq.c",
        "tune/gcdext_single.c",
        "tune/gcdext_double.c",
        "tune/gcdextod.c",
        "tune/gcdextos.c",
        "tune/hgcd_lehmer.c",
        "tune/hgcd_appr_lehmer.c",
        "tune/hgcd_reduce_1.c",
        "tune/hgcd_reduce_2.c",
        "tune/jacbase1.c",
        "tune/jacbase2.c",
        "tune/jacbase3.c",
        "tune/jacbase4.c",
        "tune/mod_1_div.c",
        "tune/mod_1_inv.c",
        "tune/mod_1_1-1.c",
        "tune/mod_1_1-2.c",
        "tune/modlinv.c",
        "tune/noop.c",
        "tune/powm_mod.c",
        "tune/powm_redc.c",
        "tune/pre_divrem_1.c",
        "tune/set_strb.c",
        "tune/set_strs.c",
        "tune/set_strp.c",
        "tune/time.c",
    ],
    hdrs = [
        ":gmp_hdrs",
        "gmp-impl.h",
        "mpn/generic/divrem_1.c",
        "mpn/generic/divrem_2.c",
        "mpn/generic/div_qr_1.c",
        "mpn/generic/div_qr_1n_pi1.c",
        "mpn/generic/gcdext.c",
        "mpn/generic/hgcd.c",
        "mpn/generic/hgcd_appr.c",
        "mpn/generic/hgcd_reduce.c",
        "mpn/generic/jacbase.c",
        "mpn/generic/mod_1.c",
        "mpn/generic/mod_1_1.c",
        "mpn/generic/set_str.c",
        "mpz/powm.c",
        "mp_clz_tab.c",
        "tests/tests.h",
        "tune/speed.h",
    ],
    deps = [":tests", ":gmp"],
    includes = ["tests"],
    visibility = ["//visibility:public"],
    copts = ["-Wno-unused-variable", "-Wno-unused-but-set-variable", "-Wno-maybe-uninitialized", "-Wno-unused-value"],
)
