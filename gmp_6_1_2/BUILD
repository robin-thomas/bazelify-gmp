exports_files([
    "gmpxx.h",
])

### Rules based on compiler/platform

config_setting(
    name = "Wno_unused_variable_linux",
    constraint_values = [
        "@bazel_tools//platforms:linux",
    ],
    visibility = ["//visibility:public"],
)

config_setting(
    name = "Wno_unused_variable_osx",
    constraint_values = [
        "@bazel_tools//platforms:osx",
    ],
    visibility = ["//visibility:public"],
)

config_setting(
    name = "Wno_unused_but_set_variable",
    constraint_values = [
        "@bazel_tools//platforms:linux",
    ],
    visibility = ["//visibility:public"],
)

################################################################################

load("@io_bazel_rules_m4//:m4.bzl", "m4")

m4(
    name = "hdrs",
    srcs = ["gmp-h.in"],
    out = "dummy",
)

genrule(
    name = "gen_gmp_hdrs",
    srcs = glob([
        "gmp-impl.h",
        "configure",
        "mpn/**",
        "install*",
        "shtool",
    ]),
    outs = [
        "config.h",
        "gmp.h",
        "gmp-mparam.h",
        "gmp_limb_bits",
        "gmp_nail_bits",
        "config.m4",
        "ccas",
        "cpp_flags",
        "mpn_srcs.tar.gz",
    ],
    cmd = """
        if [ ! -f $(location gmp.h) ]; then
          m4_PATH=`pwd`"/bazel-out/host/bin/external/m4_v1.4.18/bin"
          PATH=$${PATH}:$${m4_PATH}
          [ -d external/bazelify_gmp ] && cd external/bazelify_gmp
          cd gmp_6_1_2

          ./configure >/dev/null
          cat gmp.h | grep "#define GMP_LIMB_BITS" | tr -s [:blank:] | cut -f3 -d' ' > gmp_limb_bits
          cat gmp.h | grep "#define GMP_NAIL_BITS" | tr -s [:blank:] | cut -f3 -d' ' > gmp_nail_bits

          grep "CCAS =" Makefile | cut -d'=' -f2 > ccas
          hdrs_path=`pwd`"/"`dirname $(location gmp.h)`
          CPP_FLAGS_="-DHAVE_CONFIG_H -D__GMP_WITHIN_GMP -I. -I.. -I$${hdrs_path}"
          CPP_FLAGS_=$${CPP_FLAGS_}`grep "CFLAGS =" Makefile | sed 's/^[^=]*=//g'`
          echo $${CPP_FLAGS_} > cpp_flags

          tar -czf mpn_srcs.tar.gz mpn/*

          cd ../
          [ -d ../../external/bazelify_gmp ] && cd ../..
          if [ -d external/bazelify_gmp ]; then
            cp external/bazelify_gmp/gmp_6_1_2/config.h $(location config.h)
            cp external/bazelify_gmp/gmp_6_1_2/gmp.h $(location gmp.h)
            cp external/bazelify_gmp/gmp_6_1_2/gmp_limb_bits $(location gmp_limb_bits)
            cp external/bazelify_gmp/gmp_6_1_2/gmp_nail_bits $(location gmp_nail_bits)
            cp external/bazelify_gmp/gmp_6_1_2/gmp-mparam.h $(location gmp-mparam.h)
            cp external/bazelify_gmp/gmp_6_1_2/config.m4 $(location config.m4)
            cp external/bazelify_gmp/gmp_6_1_2/ccas $(location ccas)
            cp external/bazelify_gmp/gmp_6_1_2/cpp_flags $(location cpp_flags)
            cp external/bazelify_gmp/gmp_6_1_2/mpn_srcs.tar.gz $(location mpn_srcs.tar.gz)
          else
            cp gmp_6_1_2/config.h $(location config.h)
            cp gmp_6_1_2/gmp.h $(location gmp.h)
            cp gmp_6_1_2/gmp_limb_bits $(location gmp_limb_bits)
            cp gmp_6_1_2/gmp_nail_bits $(location gmp_nail_bits)
            cp gmp_6_1_2/gmp-mparam.h $(location gmp-mparam.h)
            cp gmp_6_1_2/config.m4 $(location config.m4)
            cp gmp_6_1_2/ccas $(location ccas)
            cp gmp_6_1_2/cpp_flags $(location cpp_flags)
            cp gmp_6_1_2/mpn_srcs.tar.gz $(location mpn_srcs.tar.gz)
          fi
        fi
    """,
    local = 1,
    tools = ["dummy"],
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

cc_library(
    name = "gmp_hdrs",
    hdrs = [
        "gmp.h",
        "config.h",
        "gmp-mparam.h",
        "fib_table.h",
        "fac_table.h",
        "mp_bases.h",
        "jacobitab.h",
        "perfsqr.h",
        "trialdivtab.h",
    ],
    visibility = ["//visibility:public"],
)

################################################################################

### mpf
cc_library(
    name = "mpf",
    srcs = glob(["mpf/*.c"]),
    hdrs = glob([
        "mpf/*.h",
        "gmp-impl.h",
        "longlong.h",
    ]),
    copts = ["-DHAVE_CONFIG_H", "-D__GMP_WITHIN_GMP"] + [
        "-Igmp_6_1_2",
        "-Iexternal/bazelify_gmp/gmp_6_1_2",
        "-I$(GENDIR)/gmp_6_1_2",
        "-I$(GENDIR)/external/bazelify_gmp/gmp_6_1_2",
    ],
    deps = ["gmp_hdrs"],
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
        "gmp.h",
        "gmp-impl.h",
        "longlong.h",
        "config.h",
        "gmp-mparam.h",
        "config.m4",
        "ccas",
        "cpp_flags",
        "mpn_srcs.tar.gz",
    ],
    outs = ["mpn_generated.tar.gz", "libmpn_generated.a"],
    cmd = """
        if [ ! -f $(location mpn_generated.tar.gz) ]; then
          m4_PATH=`pwd`"/bazel-out/host/bin/external/m4_v1.4.18/bin"
          PATH=$${PATH}:$${m4_PATH}

          CCAS_=`cat $(location ccas)`
          CPP_FLAGS_=`cat $(location cpp_flags)`
          config_path=`pwd`"/"`dirname $(location config.m4)`
          mpn_srcs_path=`pwd`"/"$(location mpn_srcs.tar.gz)
          add_path="-I../gmp_6_1_2 -I../external/bazelify_gmp/gmp_6_1_2"

          tar xzf $${mpn_srcs_path}
          cd mpn
          ln -s $${config_path}/config.m4 ../config.m4

          for file in *.asm; do
              prefix=$${file%.*}
              m4 -DOPERATION_$${prefix} -DPIC -I.. $${file} > tmp-$${prefix}.s
              $${CCAS_} -DOPERATION_$${prefix} $${CPP_FLAGS_} -Wa,--noexecstack tmp-$${prefix}.s -fPIC -DPIC -o $${prefix}.o
          done
          for file in *.c; do
              prefix=$${file%.*}
              $${CCAS_} -DOPERATION_$${prefix} $${CPP_FLAGS_} $${add_path} -I$${config_path} -Wa,--noexecstack $${file} -fPIC -DPIC -o $${prefix}.o
          done

          ar cq libmpn_generated.a *.o
          tar -czf mpn_generated.tar.gz *.o
          cp mpn_generated.tar.gz /tmp

          cd ..
          cp mpn/mpn_generated.tar.gz $(location mpn_generated.tar.gz)
          cp mpn/libmpn_generated.a $(location libmpn_generated.a)
        fi
    """,
    tools = ["dummy"],
    visibility = ["//:__pkg__"],
    local = 1,
)

cc_library(
    name = "mpn",
    srcs = [
        "fib_table.c",
        "mp_bases.c",
#        "@//:mpn_asm_tree",
        "libmpn_generated.a",
    ],
    hdrs = [
        "gmp-impl.h",
        "longlong.h",
    ],
    copts = ["-DHAVE_CONFIG_H", "-D__GMP_WITHIN_GMP"] + select({
        ":Wno_unused_variable_linux": ["-Wno-unused-variable"],
        ":Wno_unused_variable_osx": ["-Wno-unused-variable"],
        "//conditions:default": [],
    }) + [
        "-Igmp_6_1_2",
        "-Iexternal/bazelify_gmp/gmp_6_1_2",
        "-I$(GENDIR)/gmp_6_1_2",
        "-I$(GENDIR)/external/bazelify_gmp/gmp_6_1_2",
    ],
    deps = ["gmp-lib", "gmp_hdrs"],
)

### mpq
cc_library(
    name = "mpq",
    srcs = glob(["mpq/*.c"]),
    hdrs = glob([
        "mpq/*.h",
        "gmp-impl.h",
        "longlong.h",
    ]),
    copts = ["-DHAVE_CONFIG_H", "-D__GMP_WITHIN_GMP"] + [
        "-Igmp_6_1_2",
        "-Iexternal/bazelify_gmp/gmp_6_1_2",
        "-I$(GENDIR)/gmp_6_1_2",
        "-I$(GENDIR)/external/bazelify_gmp/gmp_6_1_2",
    ],
    deps = ["gmp_hdrs"],
)

### mpz
cc_library(
    name = "mpz",
    srcs = ["tal-reent.c"] + glob(["mpz/*.c", "rand/*.c"]),
    hdrs = glob([
        "mpz/*.h",
        "rand/*.h",
        "gmp-impl.h",
        "longlong.h",
    ]),
    copts = ["-DHAVE_CONFIG_H", "-D__GMP_WITHIN_GMP"] + select({
        ":Wno_unused_but_set_variable": ["-Wno-unused-but-set-variable"],
        "//conditions:default": [],
    }) + [
        "-Igmp_6_1_2",
        "-Iexternal/bazelify_gmp/gmp_6_1_2",
        "-I$(GENDIR)/gmp_6_1_2",
        "-I$(GENDIR)/external/bazelify_gmp/gmp_6_1_2",
    ],
    deps = ["gmp-lib", "gmp_hdrs"],
)

### printf
cc_library(
    name = "printf",
    srcs = glob(["printf/*.c"]),
    hdrs = [
        "gmp-impl.h",
        "longlong.h",
    ],
    copts = ["-DHAVE_CONFIG_H", "-D__GMP_WITHIN_GMP"] + select({
        ":Wno_unused_but_set_variable": ["-Wno-unused-but-set-variable"],
        "//conditions:default": [],
    }) + [
        "-Igmp_6_1_2",
        "-Iexternal/bazelify_gmp/gmp_6_1_2",
        "-I$(GENDIR)/gmp_6_1_2",
        "-I$(GENDIR)/external/bazelify_gmp/gmp_6_1_2",
    ],
    deps = ["gmp_hdrs"],
)

### scanf
cc_library(
    name = "scanf",
    srcs = glob(["scanf/*.c"]),
    hdrs = [
        "gmp-impl.h",
    ],
    copts = ["-DHAVE_CONFIG_H", "-D__GMP_WITHIN_GMP"] + select({
        ":Wno_unused_but_set_variable": ["-Wno-unused-but-set-variable"],
        "//conditions:default": [],
    }) + [
        "-Igmp_6_1_2",
        "-Iexternal/bazelify_gmp/gmp_6_1_2",
        "-I$(GENDIR)/gmp_6_1_2",
        "-I$(GENDIR)/external/bazelify_gmp/gmp_6_1_2",
    ],
    deps = ["gmp_hdrs"],
)

################################################################################

cc_library(
    name = "gmp-lib",
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
        "mp_get_fns.c",
        "mp_minv_tab.c",
        "mp_set_fns.c",
        "nextprime.c",
        "primesieve.c",
        "version.c",
    ],
    hdrs = [
        "gmp-impl.h",
        "longlong.h",
    ],
    copts = select({
        "Wno_unused_variable_linux": ["-Wno-unused-variable"],
        "Wno_unused_variable_osx": ["-Wno-unused-variable"],
        "//conditions:default": [],
    }) + [
        "-Igmp_6_1_2",
        "-Iexternal/bazelify_gmp/gmp_6_1_2",
        "-I$(GENDIR)/gmp_6_1_2",
        "-I$(GENDIR)/external/bazelify_gmp/gmp_6_1_2",
    ],
    deps = ["gmp_hdrs"],
)

cc_library(
    name = "libgmp",
    visibility = ["//:__pkg__"],
    deps = [
        ":mpf",
        ":mpq",
        ":mpz",
        ":mpn",
        ":printf",
        ":scanf",
  ],
)
