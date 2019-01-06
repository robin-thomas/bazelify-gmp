# Copyright 2018 the rules_m4 authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

load(
    "//m4:toolchain.bzl",
    _M4_TOOLCHAIN = "M4_TOOLCHAIN",
    _m4_context = "m4_context",
)

_LATEST = "1.4.14"

_VERSION_URLS = {
    "1.4.15": {
        "urls": ["https://ftp.gnu.org/gnu/m4/m4-1.4.14.tar.xz"],
    },
}

M4_VERSIONS = list(_VERSION_URLS)

def _m4_impl(ctx):
    out = ctx.outputs.out
    build = ctx.attr.build
    if build == "yes":
        m4 = _m4_context(ctx)

        args = ctx.actions.args()
        args.add_all([out, m4.executable])
        inputs = m4.inputs + ctx.files.srcs
        if ctx.attr.template:
            args.add("--reload-state", ctx.file.template.path)
            inputs += depset([ctx.file.template])
        args.add_all(ctx.attr.opts)
        args.add_all(ctx.files.srcs)
        ctx.actions.run(
            executable = m4.toolchain._m4_internal.capture_stdout,
            arguments = [args],
            inputs = inputs,
            input_manifests = m4.input_manifests,
            outputs = [out],
            tools = [m4.executable],
            env = m4.env,
            mnemonic = "ExpandTemplate",
            progress_message = "Expanding M4 template {} ({} files)".format(ctx.label, len(ctx.files.srcs)),
        )
    else:
        ctx.actions.write(output = out, content = "")
    return DefaultInfo(
        files = depset([out]),
    )

m4 = rule(
    _m4_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_empty = False,
            mandatory = True,
            allow_files = True,
        ),
        "template": attr.label(
            mandatory = False,
            allow_single_file = [".m4f"],
        ),
        "opts": attr.string_list(
            allow_empty = True,
        ),
        "out": attr.output(),
        "build": attr.string(),
    },
    toolchains = [_M4_TOOLCHAIN],
)

def _check_version(version):
    if version not in _VERSION_URLS:
        fail("GNU M4 version {} not supported by rules_m4.".format(repr(version)))

def _m4_download(ctx):
    version = ctx.attr.version
    _check_version(version)
    source = _VERSION_URLS[version]

    ctx.download_and_extract(
        url = source["urls"],
        stripPrefix = "m4-{}".format(version),
    )

    ctx.file("WORKSPACE", "workspace(name = {name})\n".format(name = repr(ctx.name)))
    ctx.symlink(ctx.attr._overlay_BUILD, "BUILD.bazel")
    ctx.symlink(ctx.attr._overlay_bin_BUILD, "bin/BUILD.bazel")
    ctx.symlink(ctx.attr._overlay_configmake_h, "stub-config/configmake.h")
    ctx.template("stub-config/config.h", ctx.attr._overlay_config_h, {
        "{VERSION}": version,
    })

    # Hardcode getprogname() to "m4" to avoid digging into the gnulib shims.
    ctx.template("lib/error.c", "lib/error.c", substitutions = {
        "#define program_name getprogname ()": '#define program_name "m4"',
    }, executable = False)

m4_download = repository_rule(
    _m4_download,
    attrs = {
        "version": attr.string(mandatory = True),
        "_overlay_BUILD": attr.label(
            default = "//m4/internal:overlay/m4.BUILD",
            single_file = True,
        ),
        "_overlay_bin_BUILD": attr.label(
            default = "//m4/internal:overlay/m4_bin.BUILD",
            single_file = True,
        ),
        "_overlay_config_h": attr.label(
            default = "//m4/internal:overlay/config.h",
            single_file = True,
        ),
        "_overlay_configmake_h": attr.label(
            default = "//m4/internal:overlay/configmake.h",
            single_file = True,
        ),
    },
)

def m4_register_toolchains(version =  _LATEST):
    _check_version(version)
    repo_name = "m4_v{}".format(version)
    if repo_name not in native.existing_rules().keys():
        m4_download(
            name = repo_name,
            version = version,
        )
    native.register_toolchains("//m4/toolchains:v{}_toolchain".format(version))
