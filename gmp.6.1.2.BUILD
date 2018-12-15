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
    visibility = ["//visibility:public"],
)

### fib-table.h
#TODO: figure out how to get the value of 64 and 0 from configure script
genrule(
    name = "gen_fib_table_h",
    outs = ["fib_table.h"],
    tools = [":gen_fib"],
    cmd = """
        $(location gen_fib) header 64 0 > $@
    """,
    visibility = ["//visibility:public"],
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

### gen-fac
#TODO: figure out how to get the value of 64 and 0 from configure script
genrule(
    name = "gen_fac_table_h",
    outs = ["fac_table.h"],
    tools = [":gen_fac"],
    cmd = """
        $(location gen_fac) 64 0 > $@
    """,
    visibility = ["//visibility:public"],
)
cc_binary(
    name = "gen_fac",
    deps = [":gen_fac_deps"],
    visibility = ["//visibility:public"],
)
cc_library(
    name = "gen_fac_deps",
    srcs = ["gen-fac.c"],
    hdrs = glob(["mini-gmp/mini-gmp.*", "bootstrap.c"]),
    copts = ["-Wno-unused-variable"],
)

### gen-bases
#TODO: figure out how to get the value of 64 and 0 from configure script
genrule(
    name = "gen_mp_bases_h",
    outs = ["mp_bases.h"],
    tools = [":gen_bases"],
    cmd = """
        $(location gen_bases) header 64 0 > $@
    """,
    visibility = ["//visibility:public"],
)
cc_binary(
    name = "gen_bases",
    deps = [":gen_bases_deps"],
    visibility = ["//visibility:public"],
)
cc_library(
    name = "gen_bases_deps",
    srcs = ["gen-bases.c"],
    hdrs = glob(["mini-gmp/mini-gmp.*", "bootstrap.c"]),
    copts = ["-Wno-unused-variable"],
)

################################################################################

### cxx
cc_library(
    name = "cxx",
    srcs = glob(["cxx/*.cc"]),
    hdrs = [":gmp_hdrs", ":gen_fib_table_h", ":gen_fac_table_h", ":gen_mp_bases_h"] + ["gmp-impl.h"],
    copts = ["-Wno-unused-but-set-variable"],
    visibility = ["//visibility:public"],
)

### mpf
cc_library(
    name = "mpf",
    srcs = glob(["mpf/*.c"]),
    hdrs = [":gmp_hdrs", ":gen_fib_table_h", ":gen_fac_table_h", ":gen_mp_bases_h"] + glob(["mpf/*.h", "gmp-impl.h", "longlong.h"]),
    visibility = ["//visibility:public"],
)

### mpq
cc_library(
    name = "mpq",
    srcs = glob(["mpq/*.c"]),
    hdrs = [":gmp_hdrs", ":gen_fib_table_h", ":gen_fac_table_h", ":gen_mp_bases_h"] + glob(["mpq/*.h", "gmp-impl.h", "longlong.h"]),
    visibility = ["//visibility:public"],
)

### mpz
cc_library(
    name = "mpz",
    srcs = glob(["mpz/*.c"]),
    hdrs = [":gmp_hdrs", ":gen_fib_table_h", ":gen_fac_table_h", ":gen_mp_bases_h"] + glob(["mpz/*.h", "gmp-impl.h", "longlong.h"]),
    visibility = ["//visibility:public"],
)

### printf
cc_library(
    name = "printf",
    srcs = glob(["printf/*.c"]),
    hdrs = [":gmp_hdrs", ":gen_fib_table_h", ":gen_fac_table_h", ":gen_mp_bases_h", "gmp-impl.h", "longlong.h"],
    copts = ["-Wno-unused-but-set-variable"],
    visibility = ["//visibility:public"],
)

### random
cc_library(
    name = "random",
    srcs = glob(["rand/*.c", "rand/*.h"]),
    hdrs = [":gmp_hdrs", ":gen_fib_table_h", ":gen_fac_table_h", ":gen_mp_bases_h", "gmp-impl.h", "longlong.h"],
    copts = ["-Wno-unused-but-set-variable"],
    visibility = ["//visibility:public"],
)

### scanf
cc_library(
    name = "scanf",
    srcs = glob(["scanf/*.c"]),
    hdrs = [":gmp_hdrs", ":gen_fib_table_h", ":gen_fac_table_h", ":gen_mp_bases_h", "gmp-impl.h"],
    copts = ["-Wno-unused-but-set-variable"],
    visibility = ["//visibility:public"],
)
