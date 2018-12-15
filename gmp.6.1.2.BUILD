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
        ./configure
        ls *.h
        cd ../..
        cp external/gmp_6_1_2/config.h $(location config.h)
        cp external/gmp_6_1_2/gmp.h $(location gmp.h)
        cp external/gmp_6_1_2/gmp-mparam.h $(location gmp-mparam.h)
    """,
    visibility = ["//visibility:public"],
)
