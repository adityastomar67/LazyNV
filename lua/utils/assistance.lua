local _, JOB     = pcall(require, "plenary.job")
local TERMINAL   = require("toggleterm.terminal").Terminal
local OPEN_TERM  = require("utils").open_term
local TRIM       = require("utils").trim
local OPENAI_URL = "https://api.openai.com/v1/engines/davinci-codex/completions" -- {cushman-codex / davinci-codex}
local MAX_TOKENS = 300
local API_KEY    = require("utils").get_api_key
local API        = vim.api
local Assistance = {}


-- Reddit Browsing inside Neovim
function Assistance.reddit()
    local cmd = "tuir"
    OPEN_TERM(cmd, { direction = "float" })
end

-- For StackOverflow Assistance
function Assistance.so_input()
    local buf = API.nvim_get_current_buf()
    local file_type = API.nvim_buf_get_option(buf, "filetype")
    vim.ui.input({ prompt = "StackOverflow input: ", default = file_type .. " " },
        function(input)
            local cmd = ""
            if input == "" or not input then
                return
            elseif input == "h" then
                cmd = "-h"
            else
                cmd = input
            end
            OPEN_TERM("so " .. cmd, { direction = 'float' })
        end)
end

-- Cheatsheet using cht.sh
local lang = ""
local file_type = ""
local function cht_on_exit(_) vim.cmd [[normal gg]] end
local function cht_on_open(term)
    vim.cmd "stopinsert"
    API.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>",
        { noremap = true, silent = true })
    API.nvim_buf_set_name(term.bufnr, "cheatsheet-" .. term.bufnr)
    API.nvim_buf_set_option(term.bufnr, "filetype", "cheat")
    API.nvim_buf_set_option(term.bufnr, "syntax", lang)
end

function Assistance.cht()
    local buf = API.nvim_get_current_buf()
    lang = ""
    file_type = API.nvim_buf_get_option(buf, "filetype")
    vim.ui.input({ prompt = "cht.sh input: ", default = file_type .. " " },
        function(input)
            local cmd = ""
            if input == "" or not input then
                return
            elseif input == "h" then
                cmd = ""
            else
                local search = ""
                local delimiter = " "
                for w in (input .. delimiter):gmatch("(.-)" .. delimiter) do
                    if lang == "" then
                        lang = w
                    else
                        if search == "" then
                            search = w
                        else
                            search = search .. "+" .. w
                        end
                    end
                end
                cmd = lang
                if search ~= "" then cmd = cmd .. "/" .. search end
            end
            cmd = "curl cht.sh/" .. cmd
            OPEN_TERM(cmd, {
                direction = 'float',
                on_open = cht_on_open,
                on_exit = cht_on_exit
            })
        end)
end

-- Interactive CheatSheet using Navi
local navi = "navi fn welcome"
local interactive_cheatsheet = TERMINAL:new {
    cmd           = navi,
    dir           = "git_dir",
    hidden        = true,
    direction     = "float",
    float_opts    = { border = "double" },
    close_on_exit = true
}
function Assistance.interactive_cheatsheet_toggle() interactive_cheatsheet:toggle() end

-- Completions with help of OpenAI
function Assistance.complete(v)
    v = v or true
    local ft = vim.bo.filetype
    local buf = API.nvim_get_current_buf()

    local api_key = API_KEY
    if api_key == nil then
        vim.notify "OpenAI API_KEY key not found"
        return
    end

    local text = ""
    if v then
        local line1 = API.nvim_buf_get_mark(0, "<")[1]
        local line2 = API.nvim_buf_get_mark(0, ">")[1]
        text = API.nvim_buf_get_lines(buf, line1 - 1, line2, false)
        text = TRIM(table.concat(text, "\n"))
    else
        text = TRIM(API.nvim_get_current_line())
    end
    local cs                     = vim.bo.commentstring
    text                         = string.format(cs .. "\n%s", ft, text)

    local request                = {}
    request["max_tokens"]        = MAX_TOKENS
    request["top_p"]             = 1
    request["temperature"]       = 0
    request["frequency_penalty"] = 0
    request["presence_penalty"]  = 0
    request["prompt"]            = text
    local body                   = vim.fn.json_encode(request)

    local completion             = ""
    local job                    = JOB:new {
        command = "curl",
        args = {
            OPENAI_URL, "-H", "Content-Type: application/json", "-H",
            string.format("Authorization: Bearer %s", api_key), "-d", body
        }
    }
    local is_completed  = pcall(job.sync, job, 10000)
    if is_completed then
        local result = job:result()
        local ok, parsed = pcall(vim.json.decode, table.concat(result, ""))
        if not ok then
            vim.notify "Failed to parse OpenAI result"
            return
        end

        if parsed["choices"] ~= nil then
            completion = parsed["choices"][1]["text"]
            local lines = {}
            local delimiter = "\n"

            for match in (completion .. delimiter):gmatch("(.-)" .. delimiter) do
                table.insert(lines, match)
            end
            API.nvim_buf_set_lines(buf, -1, -1, false, lines)
        end
    end
end

-- Tokei
local project_info = TERMINAL:new {
    cmd           = "tokei",
    dir           = "git_dir",
    hidden        = true,
    direction     = "float",
    float_opts    = { border = "double" },
    close_on_exit = false
}
function Assistance.project_info_toggle() project_info:toggle() end

-- Shell-GPT
function Assistance.shell_gpt()
    local buf = API.nvim_get_current_buf()
    file_type = API.nvim_buf_get_option(buf, "filetype")
    vim.ui.input({ prompt = "What you want to do in " .. file_type .. " language? " }, function(input)
        local cmd = ""
        if input == "" or not input then
            return
        elseif input == "h" or input == "help" then
            cmd = "--help"
            OPEN_TERM("sgpt --help", { direction = 'float' })
            return
        else
            cmd = input
        end
        OPEN_TERM("cat | sgpt --code \"" .. cmd .. " " .. "using " .. file_type .. "\"", { direction = 'float' })
    end)
end

-- howdoi
function Assistance.howdoi()
    local buf = API.nvim_get_current_buf()
    file_type = API.nvim_buf_get_option(buf, "filetype")
    vim.ui.input({ prompt = "howdoi input: " }, function(input)
        local cmd = ""
        if input == "" or not input then
            return
        elseif input == "h" then
            cmd = "-h"
        else
            cmd = input
        end
        OPEN_TERM("howdoi " .. cmd .. " " .. file_type, { direction = 'float' })
    end)
end

-- howto
function Assistance.howto()
    local buf = API.nvim_get_current_buf()
    vim.ui.input({ prompt = "howto input: " }, function(input)
        local cmd = ""
        if input == "" or not input then
            return
        else
            cmd = input
        end
        OPEN_TERM("howto " .. cmd, { direction = 'float' })
    end)
end


return Assistance