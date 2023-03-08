for _, source in ipairs({
    "config.autocmd",
    "config.keymap",
    "config.option",
    "config.lazy",

}) do
    local status_ok, fault = pcall(require, source)
    if not status_ok then
        local err = "Failed to load " .. source .. "\n\n" .. fault
        -- notify(err, "error", { title = "Require Error" })
    end
end