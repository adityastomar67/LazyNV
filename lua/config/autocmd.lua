local API = vim.api
local CMD = vim.cmd

-- Function for creating AuGroups
function AuGrps(definitions)
    for group_name, definition in pairs(definitions) do
        API.nvim_command("augroup " .. group_name)
        API.nvim_command("autocmd!")
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
            API.nvim_command(command)
        end
        API.nvim_command("augroup END")
    end
end

-- Custom Commands
CMD [[command! SaveAsRoot w !doas tee % >/dev/null]]
CMD [[command! Realtime set autoread | au CursorHold * checktime | call feedkeys("lh")]]
CMD [[command! ReloadConfig lua require("utils").ReloadConfig()]]
CMD [[command! Reindent lua require('utils').preserve("sil keepj normal! gg=G")]]
CMD [[command! Cls lua require("core.utils").preserve('%s/\\s\\+$//ge')]]
CMD [[command! BufOnly lua require('core.utils').preserve("silent! %bd|e#|bd#")]]
CMD [[command! CloneBuffer new | 0put =getbufline('#',1,'$')]]
CMD [[command! Scratch new | setlocal bt=nofile bh=wipe nobl noswapfile nu]]
CMD [[command! Blockwise lua require('utils').blockwise_clipboard()]]
CMD [[
	function! Syn()
		for id in synstack(line("."), col("."))
		  echo synIDattr(id, "name")
		endfor
	  endfunction
	  command! -nargs=0 Syn call Syn()
]]
-- CMD [[command! -bar -nargs=1 Grep silent grep <q-args> | redraw! | cw]]

-- Abbreviations
CMD [[cnoreab cls Cls]]
CMD [[cnoreab Bo BufOnly]]
CMD [[cnoreab W w]]
CMD [[cnoreab W! w!]]
CMD [[cnoreab Bw Blockwise]]
CMD [[inoreab Fname <c-r>=expand("%:p")<cr>]]
CMD [[inoreab Iname <c-r>=expand("%:p")<cr>]]
CMD [[inoreab fname <c-r>=expand("%:t")<cr>]]
CMD [[inoreab iname <c-r>=expand("%:t")<cr>]]
CMD [[inoreabbrev idate <C-R>=strftime("%b %d %Y %H:%M")<CR>]]

-- Turn Syntax off for non-code files
local syntax_group = API.nvim_create_augroup("syntaxapply", { clear = true })
API.nvim_create_autocmd("BufEnter", {
    group = syntax_group,
    pattern = "*",
    callback = function()
        if API.nvim_buf_line_count(0) > 10000 then
            CMD [[ syntax off ]]
        end
    end
})

-- INFO: Produces Unexpected erorrs
-- TODO: Need to work on future
-- URL highlighting
local highlight_url = API.nvim_create_augroup("highlighturl", { clear = true })
API.nvim_create_autocmd({ "VimEnter", "FileType", "BufEnter", "WinEnter" }, {
    callback = function()
        require("utils").set_url_match()
    end,
    desc = "URL Highlighting",
    group = highlight_url,
    pattern = "*",
})

-- Highlight the yanked text
local highlight_group = API.nvim_create_augroup("YankHighlight", { clear = true })
API.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

-- Check if we need to reload the file when it changed
API.nvim_create_autocmd("FocusGained", { command = "checktime" })

-- Go to last loc when opening a buffer
API.nvim_create_autocmd("BufReadPost", {
    callback = function()
        local mark = API.nvim_buf_get_mark(0, '"')
        local lcount = API.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(API.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Auto toggle hlsearch
local ns = API.nvim_create_namespace "toggle_hlsearch"
local function toggle_hlsearch(char)
    if vim.fn.mode() == "n" then
        local keys = { "<CR>", "n", "N", "*", "#", "?", "/" }
        local new_hlsearch = vim.tbl_contains(keys, vim.fn.keytrans(char))

        if vim.opt.hlsearch:get() ~= new_hlsearch then
            vim.opt.hlsearch = new_hlsearch
        end
    end
end
vim.on_key(toggle_hlsearch, ns)

-- Windows to close with q
API.nvim_create_autocmd("FileType", {
    pattern = {
        "Jaq",
        "lir",
        "DressingSelect",
        "cheat",
        "copilot.*",
        "OverseerForm",
        "OverseerList",
        "checkhealth",
        "floggraph",
        "fugitive",
        "git",
        "help",
        "lspinfo",
        "man",
        "neotest-output",
        "neotest-summary",
        "qf",
        "query",
        "spectre_panel",
        "startuptime",
        "toggleterm",
        "tsplayground",
        "vim",
    },
    callback = function(event)
        vim.bo[event.buf].buflisted = false
        vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
    end,
})

API.nvim_set_hl(0, "TerminalCursorShape", { underline = true })
API.nvim_create_autocmd("TermEnter", {
    callback = function()
        CMD [[setlocal winhighlight=TermCursor:TerminalCursorShape]]
    end,
})

API.nvim_create_autocmd("VimLeave", {
    callback = function()
        CMD [[set guicursor=a:ver100]]
    end,
})

-- Enable spellcheck on gitcommit and markdown
API.nvim_create_autocmd({ 'FileType' }, {
    pattern = { 'gitcommit', 'markdown' },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.spell = true
    end,
})

-- Don't auto comment new line
API.nvim_create_autocmd("BufEnter", { command = [[set formatoptions-=cro]] })

-- AutoCmds
CMD [[autocmd InsertEnter * norm zz]] -- Vertically center document when entering insert mode
CMD [[autocmd BufNewFile,BufRead *.ejs set filetype=html]]

local autocmds = {
    dsa = { { "BufWritePre", "practice.cpp", [[!g++ -std=c++20 % && ./a.out && rm -f a.out]] } },
    clear_cmdline = { { "CmdlineLeave", "*", "echo ''" } },
    conceal_quotations = {
        { "BufEnter", "*", 'syntax match singlequotes "\'" conceal' },
        { "BufEnter", "*", "syntax match singlequotes '\"' conceal" }
    },
    autoquickfix = {
        { "QuickFixCmdPost", "[^l]*", "cwindow" },
        { "QuickFixCmdPost", "l*",    "lwindow" }
    },
    fix_commentstring = {
        { "Bufenter", "*config,*rc,*conf",             "set commentstring=#%s" },
        { "Bufenter", "*config,*conf,sxhkdrc,bspwmrc", "set syntax=config" }
    },
    reload_bindings = {
        { "BufWritePost", "*sxhkdrc", "silent! !pkill -USR1 -x sxhkd" },
        { 'BufWritePost', '*bspwmrc', [[silent! !bspc wm -r]] }
    },
    make_scripts_executable = { { "BufWritePost", "*.sh,*.py,*.zsh", [[silent !chmod +x %]] } },
    live_reload_webDev = { { "BufWritePost", "index.html,*.css", [[silent! !~/.scripts/refresh]] } },
    custom_updates = {
        { "BufWritePost", ".Xresources", "!xrdb -merge ~/.Xresources" },
        { "BufWritePost", ".Xdefaults",  "!xrdb -merge ~/.Xdefaults" },
        { "BufWritePost", "fonts.conf",  "!fc-cache" }
    },
    resize_windows_proportionally = { { "VimResized", "*", ":wincmd =" }, { "Filetype", "help", ":wincmd =" } },
    terminal_job = {
        { "TermOpen", "*", [[tnoremap <buffer> <Esc> <c-\><c-n>]] },
        { "TermOpen", "*", [[tnoremap <buffer> <leader>x <c-\><c-n>:bd!<cr>]] },
        { "TermOpen", "*", [[tnoremap <expr> <A-r> '<c-\><c-n>"'.nr2char(getchar()).'pi' ]] },
        { "TermOpen", "*", "startinsert" },
        { "TermOpen", "*", [[nnoremap <buffer> <C-c> i<C-c>]] },
        { "TermOpen", "*", "setlocal listchars= nonumber norelativenumber" },
        { "TermOpen", "*", [[lua vim.opt_local.buflisted = false]] }
    },
    -- save_shada = { { "VimLeave", "*", "wshada!" }, { "CursorHold", "*", [[rshada|wshada]] } },
    wins = { { "BufEnter", "NvimTree", [[setlocal cursorline]] } },
    clean_trailing_spaces = { { "BufWritePre", "*", [[silent! lua require("utils").preserve('%s/\\s\\+$//ge')]] } },
    attatch_colorizer = { { "BufEnter", "*.css,*.scss,*.js,*.html,*.tsx,*.jsx", "ColorizerAttachToBuffer<CR>" } },
    mkdir_before_saving = {
        { "BufWritePre", "FileWritePre", "*", "[[ silent! call mkdir(expand(\"<afile>:p:h\"), \"p\")]]" } },
    trim_extra_spaces_and_newlines = { { "BufWritePre", "*", [[lua require("utils").preserve("%s/\\s\\+$//ge")]] } },
    hicurrent_word = {
        { "CursorMoved", "*",
            [[exe exists("HlUnderCursor")?HlUnderCursor?printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\')):'match none':""]] },
    },
    wrap_spell_markdown = {
        { "FileType", "markdown", ":setlocal wrap" },
        { "FileType", "markdown", ":setlocal spell" },
    },
    auto_working_directory = { { "BufEnter", "*", "silent! lcd %:p:h" } },
    -- AutoRecoverSwapFile = {
    --     { "SwapExists", "*", [[let v:swapchoice = 'r' | let b:swapname = v:swapname]] },
    --     { "BufWinEnter", "*", [[if exists("b:swapname") | call delete(b:swapname) | endif]] },
    -- }
}
AuGrps(autocmds)
