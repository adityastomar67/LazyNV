local function cmd(command)
    return table.concat({ "<Cmd>", command, "<CR>" })
end

local function gitsigns_menu()
    local gitsigns = require "gitsigns"

    local hint = [[
 _J_: Next hunk   _s_: Stage Hunk        _d_: Show Deleted   _b_: Blame Line
 _K_: Prev hunk   _u_: Undo Last Stage   _p_: Preview Hunk   _B_: Blame Show Full
 ^ ^              _S_: Stage Buffer      ^ ^                 _/_: Show Base File
 ^
 ^ ^              _<Enter>_: Neogit              _q_: Exit
]]

    return {
        name = "Git",
        hint = hint,
        config = {
            color = "pink",
            invoke_on_body = true,
            hint = {
                border = "rounded",
                position = "bottom",
            },
            on_enter = function()
                vim.cmd "mkview"
                vim.cmd "silent! %foldopen!"
                vim.bo.modifiable = false
                gitsigns.toggle_signs(true)
                gitsigns.toggle_linehl(true)
            end,
            on_exit = function()
                local cursor_pos = vim.api.nvim_win_get_cursor(0)
                vim.cmd "loadview"
                vim.api.nvim_win_set_cursor(0, cursor_pos)
                vim.cmd "normal zv"
                gitsigns.toggle_signs(false)
                gitsigns.toggle_linehl(false)
                gitsigns.toggle_deleted(false)
            end,
        },
        body = "<A-g>",
        heads = {
            {
                "J",
                function()
                    if vim.wo.diff then
                        return "]c"
                    end
                    vim.schedule(function()
                        gitsigns.next_hunk()
                    end)
                    return "<Ignore>"
                end,
                { expr = true, desc = "Next Hunk" },
            },
            {
                "K",
                function()
                    if vim.wo.diff then
                        return "[c"
                    end
                    vim.schedule(function()
                        gitsigns.prev_hunk()
                    end)
                    return "<Ignore>"
                end,
                { expr = true, desc = "Prev Hunk" },
            },
            { "s", ":Gitsigns stage_hunk<CR>", { silent = true, desc = "Stage Hunk" } },
            { "u", gitsigns.undo_stage_hunk,   { desc = "Undo Last Stage" } },
            { "S", gitsigns.stage_buffer,      { desc = "Stage Buffer" } },
            { "p", gitsigns.preview_hunk,      { desc = "Preview Hunk" } },
            { "d", gitsigns.toggle_deleted,    { nowait = true, desc = "Toggle Deleted" } },
            { "b", gitsigns.blame_line,        { desc = "Blame" } },
            {
                "B",
                function()
                    gitsigns.blame_line { full = true }
                end,
                { desc = "Blame Show Full" },
            },
            { "/",       gitsigns.show,     { exit = true, desc = "Show Base File" } }, -- show the base of the file
            { "<Enter>", "<Cmd>Neogit<CR>", { exit = true, desc = "Neogit" } },
            { "q",       nil,               { exit = true, nowait = true, desc = "Exit" } },
        },
    }
end

local function window_menu()
    local status_ok, winshift = pcall(require, "winshift")
    if not status_ok then return end

    local status_ok, picker = pcall(require, "window-picker")
    if not status_ok then return end



    local hint = [[
 Move    Size    Splits
 -----  ------  ---------
 ^ ^ _K_ ^ ^   ^ ^ _k_ ^ ^  _s_: horizontally
 _H_ ^ ^ _L_   _h_ ^ ^ _l_  _v_: vertically
 ^ ^ _J_ ^ ^   ^ ^ _j_ ^ ^  _c_: close

 _=_: equalize _W_: swap
 _p_: pick     _w_: shift
 ^
 _q_: exit
]]

    local pick_window = function()
        local picked_window_id = picker.pick_window() or vim.api.nvim_get_current_win()
        vim.api.nvim_set_current_win(picked_window_id)
    end

    local opts = { exit = true, nowait = true }

    return {
        name = "Windows",
        hint = hint,
        config = {
            color = "pink",
            invoke_on_body = true,
            hint = {
                position = "middle",
                border = "rounded",
            },
        },
        mode = "n",
        body = "<A-w>",
        heads = {
            { "s",     cmd("split"),         opts },
            { "v",     cmd("vsplit"),        opts },
            { "c",     cmd("close"),         opts }, -- close current window

            -- window resizing
            { "=",     cmd("wincmd =") },
            { "k",     cmd("wincmd +") },
            { "j",     cmd("wincmd -") },
            { "h",     cmd("wincmd <") },
            { "l",     cmd("wincmd >") },

            -- move window around
            { "H",     cmd("WinShift left") },
            { "J",     cmd("WinShift down") },
            { "K",     cmd("WinShift up") },
            { "L",     cmd("WinShift right") },

            { "p",     pick_window,          opts }, -- pick window
            -- WinShift modes
            { "w",     cmd("WinShift") },
            { "W",     cmd("WinShift swap") },
            { "q",     nil,                  opts },
            { "<ESC>", nil,                  opts },
        },
    }
end

local function assistance()
    local hint = [[
 _c_: ChatGPT                   _C_: cht.sh
 _p_: Copilot Panel             _P_: NeuralPrompt
 _s_: ShellGPT                  _S_: StackOverflow
 _i_: Interactive CheatSheet    _I_: Project Info
 _o_: OpenAI                    _O_: CheatSheet
 _h_: howto                     _H_: howdoi
 ^ ^               _q_: Quit
]]

    local opts = { exit = true, nowait = true }

    return {
        name = "Assistance",
        hint = hint,
        config = {
            color = "pink",
            invoke_on_body = true,
            hint = {
                position = "middle",
                border = "rounded",
            },
        },
        mode = "n",
        body = "<C-a>",
        heads = {
            { "c", cmd("ChatGPT"), opts },
            { "C", cmd("lua require('utils.assistance').cht()"), opts },
            { "p", cmd("Copilot panel"), opts },
            { "P", cmd("NeuralPrompt"), opts },
            { "s", cmd("lua require('utils.assistance').shell_gpt()"), opts },
            { "S", cmd("lua require('utils.assistance').so_input()"), opts },
            { "i", cmd("lua require('utils.assistance').interactive_cheatsheet_toggle()"), opts },
            { "I", cmd("lua require('utils.assistance').project_info_toggle()"), opts },
            { "o", cmd("lua require('utils.assistance').complete()"), opts },
            { "O", cmd("Cheatsheet"), opts },
            { "H", cmd("lua require('utils.assistance').howto()"), opts },
            { "h", cmd("lua require('utils.assistance').howdoi()"), opts },
        },
    }
end

local function dap_menu()
    local dap = require "dap"
    local dapui = require "dapui"
    local dap_widgets = require "dap.ui.widgets"

    local hint = [[
 _t_: Toggle Breakpoint             _R_: Run to Cursor
 _s_: Start                         _E_: Evaluate Input
 _c_: Continue                      _C_: Conditional Breakpoint
 _b_: Step Back                     _U_: Toggle UI
 _d_: Disconnect                    _S_: Scopes
 _e_: Evaluate                      _X_: Close
 _g_: Get Session                   _i_: Step Into
 _h_: Hover Variables               _o_: Step Over
 _r_: Toggle REPL                   _u_: Step Out
 _x_: Terminate                     _p_: Pause
 ^ ^               _q_: Quit
]]

    return {
        name = "Debug",
        hint = hint,
        config = {
            color = "pink",
            invoke_on_body = true,
            hint = {
                border = "rounded",
                position = "middle-right",
            },
        },
        mode = "n",
        body = "<A-d>",
        -- stylua: ignore
        heads = {
            { "C", function() dap.set_breakpoint(vim.fn.input "[Condition] > ") end, desc = "Conditional Breakpoint", },
            { "E", function() dapui.eval(vim.fn.input "[Expression] > ") end,        desc = "Evaluate Input", },
            { "R", function() dap.run_to_cursor() end,                               desc = "Run to Cursor", },
            { "S", function() dap_widgets.scopes() end,                              desc = "Scopes", },
            { "U", function() dapui.toggle() end,                                    desc = "Toggle UI", },
            { "X", function() dap.close() end,                                       desc = "Quit", },
            { "b", function() dap.step_back() end,                                   desc = "Step Back", },
            { "c", function() dap.continue() end,                                    desc = "Continue", },
            { "d", function() dap.disconnect() end,                                  desc = "Disconnect", },
            {
                "e",
                function() dapui.eval() end,
                mode = { "n", "v" },
                desc =
                "Evaluate",
            },
            { "g", function() dap.session() end,           desc = "Get Session", },
            { "h", function() dap_widgets.hover() end,     desc = "Hover Variables", },
            { "i", function() dap.step_into() end,         desc = "Step Into", },
            { "o", function() dap.step_over() end,         desc = "Step Over", },
            { "p", function() dap.pause.toggle() end,      desc = "Pause", },
            { "r", function() dap.repl.toggle() end,       desc = "Toggle REPL", },
            { "s", function() dap.continue() end,          desc = "Start", },
            { "t", function() dap.toggle_breakpoint() end, desc = "Toggle Breakpoint", },
            { "u", function() dap.step_out() end,          desc = "Step Out", },
            { "x", function() dap.terminate() end,         desc = "Terminate", },
            { "q", nil, {
                exit = true,
                nowait = true,
                desc = "Exit"
            } },
        },
    }
end

local function spelling()
    local hint = [[
 _J_: next                 _K_: previous
 _a_: add word             _l_: list corrections
 _f_: use first correction

 ^
 _q_: Exit
]]

    return {
        name = "Spelling",
        hint = hint,
        config = {
            invoke_on_body = true,
            hint = {
                position = "bottom",
                border = "rounded",
            },
        },
        mode = "n",
        body = "<A-s>",
        heads = {
            { "J",     "]s" },
            { "K",     "[s" },
            { "a",     "zg" },
            { "l",     cmd("Telescope spell_suggest") },
            { "f",     "1z=" },
            { "q",     nil,                           { exit = true, nowait = true } },
            { "<ESC>", nil,                           { exit = true, nowait = true } },
        },
    }
end

local function telescope()
    local cmd = require('hydra.keymap-util').cmd

    local hint = [[

        	      (``',
        	     / `''/
            o\/    /
            \,    /          _
            (    /         ,',`,
          /x`''7/_________r_ ,=,
         (x   //---, (------',=,
        / `''7'     \ \   ' ,=,
       /    /        \ \   '-'
      (    /          ) \
      `'''           /(o)\
              	    `|~~~|`
              	     |   |
              	    /     \
            ,-----'`       `'-----,
           `~~~~~~~~~~~~~~~~~~~~~~~`

]]

    return {
        name = 'Telescope',
        hint = hint,
        config = {
            color = 'teal',
            invoke_on_body = true,
            hint = {
                position = 'middle',
                border = 'none',
            },
        },
        mode = 'n',
        body = '<A-f>',
        heads = {
            { "b",       cmd 'lua require("plug.telescope").buffers()',    { desc = "Buffers" } },
            { "n",       cmd 'lua require("plug.telescope").nvim_files()', { desc = "Nvim Files" } },
            { "d",       cmd 'lua require("plug.telescope").xdg_config()', { desc = "DotFiles" } },
            { "e",       cmd "Telescope emoji",                            { desc = "Emoji Picker" } },
            { "c",       cmd "Telescope commands",                         { desc = "execute command" } },
            { "f",       cmd "Telescope find_files <cr>" },
            { "t",       cmd "Telescope file_browser" },
            { "m",       cmd "Telescope media_files" },
            { "g",       cmd "Telescope live_grep",                        { desc = "Find with Word" } },
            { "h",       cmd "Telescope help_tags",                        { desc = "vim help" } },
            { "k",       cmd "Telescope keymaps" },
            { "O",       cmd "Telescope vim_options" },
            { "p",       cmd "Telescope projects",                         { desc = "projects" } },
            { "r",       cmd "Telescope oldfiles",                         { desc = "recently opened files" } },
            { "R",       cmd "Telescope registers" },
            { "s",       cmd "Telescope grep_string",                      { desc = "Text under cursor" } },
            { "S",       cmd "Telescope symbols" },
            { "/",       cmd "Telescope current_buffer_fuzzy_find",        { desc = "search in file" } },
            { "?",       cmd "Telescope search_history",                   { desc = "search history" } },
            { ";",       cmd "Telescope command_history",                  { desc = "command-line history" } },
            { "<Enter>", cmd("Telescope"),                                 { exit = true, desc = "list all pickers" } },
            { "q",       nil,                                              { exit = true, nowait = true } },
            { "<ESC>",   nil,                                              { exit = true, nowait = true } },
        }
    }
end

local function option()
    local hint = [[

    ^ ^        Options ^ ^
    ^ ^ ^
    _v_ %{ve} virtual edit ^ ^
    _i_ %{list} invisible characters ^  ^^
    _s_ %{spell} spell ^ ^
    _w_ %{wrap} wrap ^ ^
    _c_ %{cul} cursor line ^ ^
    _n_ %{nu} number ^ ^
    _r_ %{rnu} relative number ^ ^
    ^ ^ ^
         ^^^^_q_, _<Esc>_: Exit ^ ^
         ^
]]

    return {
        name = "Options",
        hint = hint,
        config = {
            color = "amaranth",
            invoke_on_body = true,
            hint = {
                border = "none",
                position = "middle",
            },
        },
        mode = { "n", "x" },
        body = "<A-o>",
        heads = {
            {
                "n",
                function()
                    if vim.o.number == true then
                        vim.o.number = false
                    else
                        vim.o.number = true
                    end
                end,
                { desc = "number" },
            },
            {
                "r",
                function()
                    if vim.o.relativenumber == true then
                        vim.o.relativenumber = false
                    else
                        vim.o.number = true
                        vim.o.relativenumber = true
                    end
                end,
                { desc = "relativenumber" },
            },
            {
                "v",
                function()
                    if vim.o.virtualedit == "all" then
                        vim.o.virtualedit = "block"
                    else
                        vim.o.virtualedit = "all"
                    end
                end,
                { desc = "virtualedit" },
            },
            {
                "i",
                function()
                    if vim.o.list == true then
                        vim.o.list = false
                    else
                        vim.o.list = true
                    end
                end,
                { desc = "show invisible" },
            },
            {
                "s",
                function()
                    if vim.o.spell == true then
                        vim.o.spell = false
                    else
                        vim.o.spell = true
                    end
                end,
                { exit = true, desc = "spell" },
            },
            {
                "w",
                function()
                    if vim.o.wrap == true then
                        vim.o.wrap = false
                    else
                        vim.o.wrap = true
                    end
                end,
                { desc = "wrap" },
            },
            {
                "c",
                function()
                    if vim.o.cursorline == true then
                        vim.o.cursorline = false
                    else
                        vim.o.cursorline = true
                    end
                end,
                { desc = "cursor line" },
            },
            { "<Esc>", nil, { exit = true } },
            { "q",     nil, { exit = true } },
        },
    }
end

return {
    {
        "anuvyklack/hydra.nvim",
        enabled = vim.g.plugin_enabled.hydra,
        event = "VeryLazy",
        config = function(_, _)
            local Hydra = require("hydra")
            Hydra(gitsigns_menu())
            Hydra(dap_menu())
            Hydra(window_menu())
            Hydra(spelling())
            Hydra(telescope())
            Hydra(option())
            Hydra(assistance())
        end,
    },
}
