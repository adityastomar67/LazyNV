for _, source in ipairs({
    "config.lazy",
    "config.option",
}) do
    local status_ok, fault = pcall(require, source)
    if not status_ok then
        local err = "Failed to load " .. source .. "\n\n" .. fault
        -- notify(err, "error", { title = "Require Error" })
    end
end

require "config.autocmd"
vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
        require "config.keymap"
    end,
})