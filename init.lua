vim.g.plugin_enabled = require("config.user").plugins
for _, source in ipairs({
    "config.bootstrap",
    "config.lazy",
    "config.option",
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

-- NOTE: work on toggler keybindings, i.e not working
-- NOTE: work on cmp menu, make it like NvChad