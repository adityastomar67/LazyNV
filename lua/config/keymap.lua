--    +-------------------------------------------------------------------------------------------------+
--    | Commands \ Modes | Normal | Insert | Command | Visual | Select | Operator | Terminal | Lang-Arg |
--    ---------------------------------------------------------------------------------------------------
--    | map  / noremap   |    @   |   -    |    -    |   @    |   @    |    @     |    -     |    -     |
--    | nmap / nnoremap  |    @   |   -    |    -    |   -    |   -    |    -     |    -     |    -     |
--    | map! / noremap!  |    -   |   @    |    @    |   -    |   -    |    -     |    -     |    -     |
--    | imap / inoremap  |    -   |   @    |    -    |   -    |   -    |    -     |    -     |    -     |
--    | cmap / cnoremap  |    -   |   -    |    @    |   -    |   -    |    -     |    -     |    -     |
--    | vmap / vnoremap  |    -   |   -    |    -    |   @    |   @    |    -     |    -     |    -     |
--    | xmap / xnoremap  |    -   |   -    |    -    |   @    |   -    |    -     |    -     |    -     |
--    | smap / snoremap  |    -   |   -    |    -    |   -    |   @    |    -     |    -     |    -     |
--    | omap / onoremap  |    -   |   -    |    -    |   -    |   -    |    @     |    -     |    -     |
--    | tmap / tnoremap  |    -   |   -    |    -    |   -    |   -    |    -     |    @     |    -     |
--    | lmap / lnoremap  |    -   |   @    |    @    |   -    |   -    |    -     |    -     |    @     |
--    +-------------------------------------------------------------------------------------------------+
-- Modes
--   normal_mode       = "n"
--   insert_mode       = "i"
--   visual_mode       = "v"
--   visual_block_mode = "x"
--   term_mode         = "t"
--   command_mode      = "c"

local opts      = { noremap = true, silent = true }
local term_opts = { silent = true }
local key       = vim.api.nvim_set_keymap

-- Reselect the previous visual block
key("n", "gV", "`[v`]", opts)

key("i", "<C-r>", "<ESC><cmd>TermExec cmd=\"clear && prog %\"<CR>", opts)

-- File creation date
key("n", "<F1>", 'oThis file was created on <C-R>=strftime("%b %d %Y %H:%M")<CR><ESC>', opts)
key("i", "<F1>", 'oThis file was created on <C-R>=strftime("%b %d %Y %H:%M")<CR>', opts)

-- Increment/decrement
key('n', '+', '<C-a>', opts)
key('n', '-', '<C-x>', opts)

-- Delete a word backwards
key('n', 'db', 'vb"_d', opts)

-- Remove the Highlighting from the search
key("n", "<CR>", ":noh<CR><CR>", opts)

-- Better Redo Option
key("n", "U", "<C-r>", opts)

-- Better Hoping then numerous keystrokes
-- key("n" , "fw"     , ":HopWord<CR>"      , opts)
-- key("n" , "fl"     , ":HopLine<CR>"      , opts)
-- key("i" , "<C-F>"  , "<ESC>:HopLine<CR>" , opts)

-- For not yanking when deleting chars
key('n', 'x', '"_x', opts)

-- Yank all content
key("n", "Y", "y$", opts)

-- Writing & exiting
key("n", "Q", ":q!<CR>", opts)
key("n", "<C-c>", ":bw<CR>", opts)
key("n", "<C-s>", ":w<CR>", opts)
key("n", "qo", ":on<CR>", opts)
key("i", "<C-s>", "<ESC>:w<CR>", opts)

-- Better window navigation
key("n", "<C-h>", "<C-w>h", opts)
key("n", "<C-j>", "<C-w>j", opts)
key("n", "<C-k>", "<C-w>k", opts)
key("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
key("n", "<C-Up>", ":resize +2<CR>", opts)
key("n", "<C-Down>", ":resize -2<CR>", opts)
key("n", "<C-Left>", ":vertical resize -2<CR>", opts)
key("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
key("n", "<S-l>", ":bnext<CR>", opts)
key("n", "<S-h>", ":bprevious<CR>", opts)

-- Press qq/q fast to enter Normal Mode
key("i", "qq", "<ESC>", opts)
key("v", "q", "<ESC>", opts)
key("x", "q", "<ESC>", opts)

-- Getting Rid Of Bad Habbits
key("n", "<Up>", "<Nop>", opts)
key("i", "<Up>", "<Nop>", opts)
key("x", "<Up>", "<Nop>", opts)
key("v", "<Up>", "<Nop>", opts)
key("n", "<Down>", "<Nop>", opts)
key("i", "<Down>", "<Nop>", opts)
key("x", "<Down>", "<Nop>", opts)
key("v", "<Down>", "<Nop>", opts)
key("n", "<Left>", "<Nop>", opts)
key("i", "<Left>", "<Nop>", opts)
key("x", "<Left>", "<Nop>", opts)
key("v", "<Left>", "<Nop>", opts)
key("n", "<Right>", "<Nop>", opts)
key("i", "<Right>", "<Nop>", opts)
key("x", "<Right>", "<Nop>", opts)
key("v", "<Right>", "<Nop>", opts)

-- Better Navigation in insert mode
key("i", "<C-h>", "<Left>", opts)
key("i", "<C-l>", "<Right>", opts)
key("i", "<C-j>", "<Down>", opts)
key("i", "<C-k>", "<Up>", opts)

-- Stay in indent mode
key("v", "<", "<gv", opts)
key("v", ">", ">gv", opts)

-- Move text up and down
key("v", "<A-j>", ":m .+1<CR>==", opts)
key("v", "<A-k>", ":m .-2<CR>==", opts)
key("v", "p", '"_dP', opts)

-- Move text up and down
key("x", "J", ":move '>+1<CR>gv-gv", opts)
key("x", "K", ":move '<-2<CR>gv-gv", opts)
key("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)
key("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)

-- Better terminal navigation
key("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
key("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
key("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
key("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- File Tree Pawn
vim.key.set('n', '<C-S-b>', function()
    require("neo-tree.command").execute {
        toggle = true,
        dir = require("utils").get_root()
    }
end, opts)
vim.key.set('n', '<C-b>', function()
    require("neo-tree.command").execute {
        toggle = true,
        dir = vim.loop.cwd()
    }
end, opts)

-- For Conceal enable/disable
vim.key.set("n", "<F10>", function()
    if vim.o.conceallevel > 0 then
        vim.o.conceallevel = 0
    else
        vim.o.conceallevel = 2
    end
end, opts)

vim.key.set("n", "<F11>", function()
    if vim.o.concealcursor == "n" then
        vim.o.concealcursor = ""
    else
        vim.o.concealcursor = "n"
    end
end, opts)

-- TESTING
key("n", "n", "nzzzv", opts)
key("n", "N", "Nzzzv", opts)
key("n", "G", "Gzz", opts)
