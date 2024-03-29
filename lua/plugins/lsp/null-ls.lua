return {
    "jose-elias-alvarez/null-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim" },
    config = function()
        local nls = require "null-ls"
        local b = nls.builtins
        local sources = {
            b.formatting.deno_fmt,
            b.formatting.prettier.with({
                filetypes = { "html", "markdown", "css" },
                extra_args = { "--indent-width=4", "--single-quote", "--jsx-single-quote" }
            }),
            b.formatting.stylua,
            b.formatting.shfmt,
            b.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
            b.formatting.clang_format,
            b.formatting.black.with({ extra_args = { "--fast" } }),
            b.diagnostics.flake8,
            b.diagnostics.ruff.with { extra_args = { "--max-line-length=180" } }
        }
        nls.setup({ debug = true, sources = sources })
    end
}
