#load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

#http_archive(
#    name = "gmp_6_1_2",
#    build_file = "gmp.6.1.2.BUILD",
#    sha256 = "87b565e89a9a684fe4ebeeddb8399dce2599f9c9049854ca8c0dfbdea0e21912",
#    strip_prefix = "gmp-6.1.2",
#    url = "https://gmplib.org/download/gmp/gmp-6.1.2.tar.xz",
#)

load("//:m4.bzl", "m4_register_toolchains")

m4_register_toolchains()

# buildifier is written in Go and hence needs rules_go to be built.
# See https://github.com/bazelbuild/rules_go for the up to date setup instructions.
#http_archive(
#    name = "io_bazel_rules_go",
#    sha256 = "7be7dc01f1e0afdba6c8eb2b43d2fa01c743be1b9273ab1eaf6c233df078d705",
#    urls = ["https://github.com/bazelbuild/rules_go/releases/download/0.16.5/rules_go-0.16.5.tar.gz"],
#)

#http_archive(
#    name = "com_github_bazelbuild_buildtools",
#    strip_prefix = "buildtools-ab1d6a0ca532b7b7f3450a42d5cbcfdcd736fd41",
#    url = "https://github.com/bazelbuild/buildtools/archive/ab1d6a0ca532b7b7f3450a42d5cbcfdcd736fd41.zip",
#)

#http_archive(
#    name = "m4",
#    strip_prefix = "m4-1.4.18",
#    url = "https://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.xz",
#    build_file = "m4-1.4.18.BUILD",
#)

#load("@io_bazel_rules_go//go:def.bzl", "go_register_toolchains", "go_rules_dependencies")
#load("@com_github_bazelbuild_buildtools//buildifier:deps.bzl", "buildifier_dependencies")

#go_rules_dependencies()

#go_register_toolchains()

#buildifier_dependencies()

#load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

#git_repository(
#    name = "io_bazel_rules_m4",
#    remote = "https://github.com/jmillikin/rules_m4",
#    commit = "2bf69df77dfb6b3ba6b7fc95c304b0dc279375bc",
#)

#load("@io_bazel_rules_m4//:m4.bzl", "m4_register_toolchains")

#m4_register_toolchains()
