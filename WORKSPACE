load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "gmp_6_1_2",
    build_file = "gmp.6.1.2.BUILD",
    sha256 = "87b565e89a9a684fe4ebeeddb8399dce2599f9c9049854ca8c0dfbdea0e21912",
    strip_prefix = "gmp-6.1.2",
    url = "https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz",
)

load("//:m4.bzl", "m4_register_toolchains")

m4_register_toolchains()
