exports_files([
  "gmp.h",
  "gmpxx.h",
])

cc_import(
    name = "libgmp",
    hdrs = [
        "gmp.h",
        "gmpxx.h",
    ],
    static_library = "libgmp.a",
    visibility = ["//:__pkg__"],
)
