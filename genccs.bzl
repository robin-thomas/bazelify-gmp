def _impl(ctx):
    tree = ctx.actions.declare_directory(ctx.attr.name + ".cc")
    ctx.actions.run(
        inputs = [],
        outputs = [tree],
        arguments = [tree.path],
        executable = ctx.executable._tool,
    )

    return [DefaultInfo(files = depset([tree]))]

genccs = rule(
    implementation = _impl,
    attrs = {
        "_tool": attr.label(
            executable = True,
            cfg = "host",
            allow_files = True,
            default = Label("//:genccs"),
        ),
    },
)
