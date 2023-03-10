vim.g.plugin_enabled = require("config.user").plugins
for _, source in ipairs({
    "config.option",
    "config.lazy",
}) do
    local status_ok, fault = pcall(require, source)
    if not status_ok then
        local err = "Failed to load " .. source .. "\n\n" .. fault
        -- notify(err, "error", { title = "Require Error" })
    end
end

vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        require "config.autocmd"
        require "config.keymap"
    end,
})

-- TEMP
-- vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
