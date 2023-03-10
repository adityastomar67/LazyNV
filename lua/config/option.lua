-- OPT.shortmess:append { W = true, I = true, c = true }
-- opt.breakindent = true
-- opt.cmdheight = 1
-- opt.confirm = true
-- opt.expandtab = true
-- opt.foldcolumn = "1" -- '0' is not bad
-- opt.foldenable = true
-- opt.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
-- opt.foldlevelstart = 99
-- opt.hidden = true
-- opt.ignorecase = true
-- opt.inccommand = "nosplit"
-- opt.joinspaces = false
-- opt.laststatus = 0
-- opt.list = true
-- opt.mouse = "a"
-- opt.number = true
-- opt.pumblend = 10
-- opt.pumheight = 10
-- opt.relativenumber = true
-- opt.scrollback = 100000
-- opt.scrolloff = 8
-- opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
-- opt.shiftround = true
-- opt.shiftwidth = 2
-- opt.showmode = false
-- opt.sidescrolloff = 8
-- opt.signcolumn = "yes"
-- opt.smartcase = true
-- opt.smartindent = true
-- opt.splitbelow = true
-- opt.splitright = true
-- opt.tabstop = 2
-- opt.termguicolors = true
-- opt.timeoutlen = 300
-- opt.title = true
-- opt.undofile = true
-- opt.updatetime = 200
-- opt.wildmode = "longest:full,full"


local OPT          = vim.opt
local O            = vim.o
local G            = vim.g

---- :help options
OPT.backup         = false                     -- creates a backup file
OPT.icm            = "split"                   -- To create a popup menu for selected search items
OPT.clipboard      = "unnamedplus"             -- allows neovim to access the system clipboard
OPT.fileencoding   = "utf-8"                   -- the encoding written to a file
OPT.ignorecase     = true                      -- ignore case in search patterns
OPT.mouse          = "a"                       -- allow the mouse to be used in neovim
OPT.pumheight      = 10                        -- pop up menu height
OPT.showmode       = false                     -- we don't need to see things like -- INSERT -- anymore
OPT.smartcase      = true                      -- smart case
OPT.smartindent    = true                      -- make indenting smarter again
OPT.splitbelow     = false                     -- force all horizontal splits to go below current window
OPT.splitright     = true                      -- force all vertical splits to go to the right of current window
OPT.swapfile       = false                     -- creates a swapfile
OPT.termguicolors  = true                      -- set term gui colors (most terminals support this)
OPT.timeoutlen     = 1000                      -- time to wait for a mapped sequence to complete (in milliseconds)
OPT.undofile       = true                      -- enable persistent undo
OPT.updatetime     = 300                       -- faster completion (4000ms default)
OPT.expandtab      = true                      -- convert tabs to spaces
OPT.shiftwidth     = 4                         -- the number of spaces inserted for each indentation
OPT.tabstop        = 4                         -- insert 2 spaces for a tab
OPT.number         = false                     -- set numbered lines
OPT.relativenumber = false                     -- set relative numbered lines
OPT.numberwidth    = 1                         -- set number column width to 2 {default 4}
OPT.signcolumn     = "yes"                     -- always show the sign column, otherwise it would shift the text each time
OPT.wrap           = true                      -- display lines as one long line
OPT.scrolloff      = 8                         -- is one of my fav
OPT.sidescrolloff  = 8                         -- how many lines to scroll when you scroll past the end of the screen
OPT.scrollback     = 100000                    -- max number of screen lines to keep in scrollback
OPT.writebackup    = false                     -- when file is edited by some program, it's not allowed to be edited
OPT.background     = "dark"                    -- set the background color
OPT.fillchars      = { eob = " " }             -- set the fill character for the end of the line
OPT.laststatus     = 0                         -- set the last status line to 0
OPT.hidden         = true                      -- hide the status line
OPT.cole           = 2                         -- Conceal applied
OPT.cursorline     = true                      -- highlight the current line
OPT.cursorlineopt  = "number"                  -- show the line numbers highlighted
OPT.foldmethod     = "indent"
OPT.foldnestmax    = 10
OPT.foldenable     = false
OPT.winblend       = 0
OPT.foldlevel      = 2
OPT.laststatus     = 3
OPT.termguicolors  = true
OPT.formatoptions  = "l"
OPT.formatoptions  = OPT.formatoptions
    - "a"                     -- Auto formatting is BAD.
    - "t"                     -- Don't auto format my code. I got linters for that.
    + "c"                     -- In general, I like it when comments respect textwidth
    + "q"                     -- Allow formatting comments w/ gq
    + "o"                     -- O and o, don't continue comments
    + "r"                     -- But do continue when pressing enter.
    + "n"                     -- Indent past the formatlistpat, not underneath it.
    + "j"                     -- Auto-remove comments if possible.
    - "2"                     -- I'm not in gradeschool anymore
OPT.shortmess:append "c"      -- show the current cursor position
OPT.whichwrap:append "<>[]hl" -- set the wrap characters
OPT.guicursor  = {
    "n-v:block",
    "i-c-ci-ve:ver25",
    "r-cr:hor20",
    "o:hor50",
    "i:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor",
    "sm:block-blinkwait175-blinkoff150-blinkon175",
}
O.hidden       = true
O.fileencoding = "utf-8"
O.splitbelow   = true
O.splitright   = true
O.showmode     = false
O.backup       = false
O.writebackup  = false
O.updatetime   = 300
O.timeoutlen   = 1000
O.hlsearch     = true
O.ignorecase   = true
O.expandtab    = true

if vim.fn.has "nvim-0.9.0" == 1 then
    OPT.splitkeep = "screen"
    OPT.shortmess:append { C = true }
    O.ch = 0
end

-- Remap space as leader key
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", { noremap = true, silent = true })
G.mapleader = " "
G.maplocalleader = " "

vim.cmd "filetype plugin indent on"

G.lua_subversion            = 0
G.BetterLua_enable_emmylua  = 0


-- IMPROVE NEOVIM STARTUP
G.loaded_python_provier     = 0
G.loaded_python3_provider   = 0
G.python_host_skip_check    = 1
G.python_host_prog          = "/bin/python2"
G.python3_host_skip_check   = 1
G.python3_host_prog         = "/bin/python3"
G.EditorConfig_core_mode    = "external_command"
G.matchparen_timeout        = 20
G.matchparen_insert_timeout = 20
G.do_filetype_lua           = 1
G.did_load_filetypes        = 0
OPT.pyxversion              = 3
OPT.pyxversion              = 3

-- Give me some fenced codeblock goodness
G.markdown_fenced_languages = {
    "html",
    "javascript",
    "javascriptreact",
    "typescript",
    "json",
    "css",
    "scss",
    "lua",
    "vim",
    "bash",
    "ts=typescript",
}

local default_providers = {
    "node",
    "perl",
    "python3",
    "ruby",
}

for _, provider in ipairs(default_providers) do
    vim.g["loaded_" .. provider .. "_provider"] = 0
end

-- Setting the colorscheme
require("utils").set_colorscheme()

-- Data for limelight_conceal
vim.cmd [[let g:limelight_conceal_ctermfg = 'gray']]
vim.cmd [[let g:limelight_conceal_ctermfg = 240]]
vim.cmd [[let g:limelight_conceal_guifg = 'DarkGray']]
vim.cmd [[let g:limelight_conceal_guifg = '#777777']]
vim.cmd [[let g:limelight_default_coefficient = 0.9]]