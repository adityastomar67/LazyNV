---@diagnostic disable: deprecated
local TERMINAL     = require("toggleterm.terminal").Terminal
local API_KEY_PATH = require("config.user").openai_api_path
local CMP          = require("config.user").completion
local DIAGNOSTIC   = require("config.user").diagnostic
local Utils        = {}

function Utils.trim(str)
    return (string.gsub(str, "^%s*(.-)%s*$", "%1"))
end

-- Get the root dir
function Utils.get_root()
    ---@type string?
    local path = vim.api.nvim_buf_get_name(0)
    path = path ~= "" and vim.loop.fs_realpath(path) or nil
    ---@type string[]
    local roots = {}
    if path then
        for _, client in pairs(vim.lsp.get_active_clients({
            bufnr = 0
        })) do
            local workspace = client.config.workspace_folders
            local paths = workspace and vim.tbl_map(function(ws)
                    return vim.uri_to_fname(ws.uri)
                end, workspace) or client.config.root_dir and { client.config.root_dir } or {}
            for _, p in ipairs(paths) do
                local r = vim.loop.fs_realpath(p)
                if path:find(r, 1, true) then
                    roots[#roots + 1] = r
                end
            end
        end
    end
    table.sort(roots, function(a, b)
        return #a > #b
    end)
    ---@type string?
    local root = roots[1]
    if not root then
        path = path and vim.fs.dirname(path) or vim.loop.cwd()
        ---@type string?
        root = vim.fs.find({ ".git", "lua" }, {
                path = path,
                upward = true
            })[1]
        root = root and vim.fs.dirname(root) or vim.loop.cwd()
    end
    ---@cast root string
    return root
end

-- URL match string
Utils.url_matcher =
"\\v\\c%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)%([&:#*@~%_\\-=?!+;/0-9a-z]+%(%([.;/?]|[.][.]+)[&:#*@~%_\\-=?!+/0-9a-z]+|:\\d+|,%(%(%(h?ttps?|ftp|file|ssh|git)://|[a-z]+[@][a-z]+[.][a-z]+:)@![0-9a-z]+))*|\\([&:#*@~%_\\-=?!+;/.0-9a-z]*\\)|\\[[&:#*@~%_\\-=?!+;/.0-9a-z]*\\]|\\{%([&:#*@~%_\\-=?!+;/.0-9a-z]*|\\{[&:#*@~%_\\-=?!+;/.0-9a-z]*})\\})+"

-- Delete the syntax matching rules for URLs/URIs if set
function Utils.delete_url_match()
    for _, match in ipairs(vim.fn.getmatches()) do
        if match.group == "HighlightURL" then vim.fn.matchdelete(match.id) end
    end
end

-- Add syntax matching rules for highlighting URLs/URIs
function Utils.set_url_match()
    Utils.delete_url_match()
    if vim.g.highlighturl_enabled then vim.fn.matchadd("HighlightURL", Utils.url_matcher, 15) end
end

-- For fetching the Openai API key from local storage
function Utils.get_api_key()
    local file = io.open(API_KEY_PATH, "rb")
    if not file then return nil end
    local content = file:read "*a"
    content = string.gsub(content, "^%s*(.-)%s*$", "%1")
    file:close()
    return content
end

-- For creating new Terminal Instance
function Utils.open_term(cmd, opts)
    opts           = opts or {}
    opts.size      = opts.size or vim.o.columns * 0.5
    opts.direction = opts.direction or "vertical"
    opts.on_open   = opts.on_open or default_on_open
    opts.on_exit   = opts.on_exit or nil

    local new_term = TERMINAL:new {
        cmd             = cmd,
        dir             = "git_dir",
        auto_scroll     = false,
        close_on_exit   = false,
        start_in_insert = false,
        on_open         = opts.on_open,
        on_exit         = opts.on_exit
    }
    new_term:open(opts.size, opts.direction)
end

-- For sourcing the current file
function Utils.source_file()
    local buf      = vim.api.nvim_get_current_buf()
    local filename = vim.api.nvim_buf_get_name(buf)
    local basename = vim.fn.fnamemodify(filename, ":t")
    vim.api.nvim_command("source " .. filename)
    vim.api.nvim_command("lua require(\"notify\")(\"Sourced " .. basename .. "\", \"info\", {title = \"Neovim\"})")
end

-- Reload the whole config
function Utils.reload_config()
    local hls_status = vim.v.hlsearch
    for name, _ in pairs(package.loaded) do
        if name:match("^cnull") then package.loaded[name] = nil end
    end
    dofile(vim.env.MYVIMRC)
    if hls_status == 0 then vim.opt.hlsearch = false end
end

function Utils.preserve(arguments)
    local arguments = string.format("keepjumps keeppatterns execute %q", arguments)
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_command(arguments)
    local lastline = vim.fn.line("$")
    if line > lastline then line = lastline end
    vim.api.nvim_win_set_cursor(0, { line, col })
end

function Utils.squeeze_blank_lines()
    if vim.bo.binary == false and vim.opt.filetype:get() ~= "diff" then
        local old_query = vim.fn.getreg("/")          -- save search register
        Utils.preserve("sil! 1,.s/^\\n\\{2,}/\\r/gn") -- set current search count number
        local result = vim.fn.searchcount({ maxcount = 1000, timeout = 500 }).current
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        Utils.preserve("sil! keepp keepj %s/^\\n\\{2,}/\\r/ge")
        Utils.preserve("sil! keepp keepj %s/^\\s\\+$/\\r/ge")
        Utils.preserve("sil! keepp keepj %s/\\v($\\n\\s*)+%$/\\r/e")
        if result > 0 then
            vim.api.nvim_win_set_cursor(0, { (line - result), col })
        end
        vim.fn.setreg("/", old_query) -- restore search register
    end
end

-- Better Quit Function
function Utils.quit()
    local bufnr = vim.api.nvim_get_current_buf()
    local buf_windows = vim.call("win_findbuf", bufnr)
    local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
    if modified and #buf_windows == 1 then
        vim.ui.input({
            prompt = "You have unsaved changes. Quit anyway? (y/n) "
        }, function(input)
            if input == "y" then
                vim.cmd "qa!"
            end
        end)
    else
        vim.cmd "qa!"
    end
end

-- Toggle Diagnostics
Utils.toggle_diagnostics = function()
    DIAGNOSTIC = not DIAGNOSTIC
    if DIAGNOSTIC then
        vim.diagnostic.show()
    else
        vim.diagnostic.hide()
    end
end

-- Toggle Completions
Utils.toggle_cmp = function()
    if CMP == true then
        vim.cmd "lua require('cmp').setup.buffer { enabled = false }"
        CMP = not CMP
    else
        vim.cmd "lua require('cmp').setup.buffer { enabled = true }"
        CMP = not CMP
    end
end

return Utils