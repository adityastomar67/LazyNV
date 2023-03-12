local table = vim.tbl_add_reverse_lookup({
    ["True"]   = "False",
    ["true"]   = "false",
    ["Left"]   = "Right",
    ["left"]   = "right",
    ["Up"]     = "Down",
    ["up"]     = "down",
    ["Enable"] = "Disable",
    ["enable"] = "disable",
    ["Active"] = "Inactive",
    ["active"] = "inactive",
    ["Start"]  = "Stop",
    ["start"]  = "stop",
    ["Begin"]  = "End",
    ["begin"]  = "end",
    ["Yes"]    = "No",
    ["yes"]    = "no",
    ["On"]     = "Off",
    ["on"]     = "off",
    ["1"]      = "0",
})

local mode = {
    ["n"] = "norm! ciw",
    ["v"] = "norm! c",
}

local toggler = function()
    local word = vim.tbl_get(table, vim.fn.expand("<cword>"))
    xpcall(function()
        vim.cmd(vim.tbl_get(mode, vim.api.nvim_get_mode().mode) .. word)
    end, function()
        print("toggler: unsupported value.")
    end)
end

return { toggle = toggler }