local ls = require("luasnip") --{{{
local s = ls.s --> snippet
local i = ls.i --> insert node
local t = ls.t --> text node

local d = ls.dynamic_node
local c = ls.choice_node
local f = ls.function_node
local sn = ls.snippet_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local l = require("luasnip.extras").lambda


local group = vim.api.nvim_create_augroup("Lua Snippets", { clear = true })
local file_pattern = "*.lua"



local autosnippets = {} --}}}
local snippets = {
  ls.parser.parse_snippet("lm", "local M = {}\n\nfunction M.setup()\n  $1 \nend\n\nreturn M"),
  ls.parser.parse_snippet("for", "for ${1:i} = ${2:1}, ${3:n} do\n\t$0\nend"),
  ls.parser.parse_snippet("fun", "local function ${1:name}($2)\n\t$0\nend"),
  ls.parser.parse_snippet("while", "while ${1:cond} do\n\t$0\nend"),
  ls.parser.parse_snippet("mfun", "function M.${1:name}($2)\n\t$0\nend"),
  ls.parser.parse_snippet("pairs", "for ${1:key}, ${2:value} in pairs($3) do\n\t$0\nend"),
  ls.parser.parse_snippet("ipairs", "for ${1:i}, ${2:value} in ipairs($3) do\n\t$0\nend"),
  ls.parser.parse_snippet("if", "if ${1:cond} then\n\t$0\nend"),
  ls.parser.parse_snippet("ifn", "if not ${1:cond} then\n\t$0\nend"),
  }

  

local function cs(trigger, nodes, opts) --{{{
  local snippet = s(trigger, nodes)
	local target_table = snippets

	local pattern = file_pattern
	local keymaps = {}
  
	if opts ~= nil then
		-- check for custom pattern
		if opts.pattern then
			pattern = opts.pattern
		end
    
		-- if opts is a string
		if type(opts) == "string" then
			if opts == "auto" then
				target_table = autosnippets
			else
				table.insert(keymaps, { "i", opts })
			end
		end
    
		-- if opts is a table
		if opts ~= nil and type(opts) == "table" then
			for _, keymap in ipairs(opts) do
				if type(keymap) == "string" then
					table.insert(keymaps, { "i", keymap })
				else
					table.insert(keymaps, keymap)
				end
			end
		end

		-- set autocmd for each keymap
		if opts ~= "auto" then
			for _, keymap in ipairs(keymaps) do
				vim.api.nvim_create_autocmd("BufEnter", {
          pattern = pattern,
					group = group,
					callback = function()
						vim.keymap.set(keymap[1], keymap[2], function()
							ls.snip_expand(snippet)
						end, { noremap = true, silent = true, buffer = true })
					end,
				})
			end
		end
	end
  
	table.insert(target_table, snippet) -- insert snippet into appropriate table
end --}}}

-- Start Refactoring --
cs(
  "localreq",
  fmt('local {} = require("{}")', {
    l(l._1:match("[^.]*$"):gsub("[^%a]+", "_"), 1),
    i(1, "module"),
  })
)
cs(
  "preq",
  fmt('local {1}_ok, {1} = pcall(require, "{}")\nif not {1}_ok then return end', {
    l(l._1:match("[^.]*$"):gsub("[^%a]+", "_"), 1),
    i(1, "module"),
  })
)

cs("CMD", { -- [CMD] multiline vim.cmd{{{
  t({ "vim.cmd[[", "  " }),
	i(1, ""),
	t({ "", "]]" }),
}) --}}}
cs("cmd", fmt("vim.cmd[[{}]]", { i(1, "") })) -- single line vim.cmd
cs({ -- github import for packer{{{
	trig = "https://github%.com/([%w-%._]+)/([%w-%._]+)!",
	regTrig = true,
	hidden = true,
}, {
	t([[use "]]),
	f(function(_, snip)
		return snip.captures[1]
	end),
	t("/"),
	f(function(_, snip)
		return snip.captures[2]
	end),
	t({ [["]], "" }),
	i(1, ""),
}, "auto") --}}}

cs( -- {regexSnippet} LuaSnippet{{{
	"regexSnippet",
	fmt(
		[=[
cs( -- {}
{{ trig = "{}", regTrig = true, hidden = true }}, fmt([[ 
{}
]], {{
  {}
}}))
      ]=],
		{
			i(1, "Description"),
			i(2, ""),
			i(3, ""),
			i(4, ""),
		}
	),
	{ pattern = "*/snippets/*.lua", "<C-d>" }
) --}}}
cs( -- [luaSnippet] LuaSnippet{{{
	"luaSnippet",
	fmt(
		[=[
cs("{}", fmt( -- {}
[[
{}
]], {{
  {}
  }}){})
    ]=],
		{
			i(1, ""),
			i(2, "Description"),
			i(3, ""),
			i(4, ""),
			c(5, {
				t(""),
				fmt([[, "{}"]], { i(1, "keymap") }),
				fmt([[, {{ pattern = "{}", {} }}]], { i(1, "*/snippets/*.lua"), i(2, "keymap") }),
			}),
		}
	),
	{ pattern = "*/snippets/*.lua", "jcs" }
) --}}}

cs( -- choice_node_snippet luaSnip choice node{{{
	"choice_node_snippet",
	fmt(
		[[ 
c({}, {{ {} }}),
]],
		{
			i(1, ""),
			i(2, ""),
		}
	),
	{ pattern = "*/snippets/*.lua", "jcn" }
) --}}}

cs( -- [function] Lua function snippet{{{
	"function",
	fmt(
		[[ 
function {}({})
  {}
end
]],
		{
			i(1, ""),
			i(2, ""),
			i(3, ""),
		}
	),
	"jff"
) --}}}
cs( -- [local_function] Lua function snippet{{{
	"local_function",
	fmt(
		[[ 
local function {}({})
  {}
end
]],
		{
			i(1, ""),
			i(2, ""),
			i(3, ""),
		}
	),
	"jlf"
) --}}}
cs( -- [local] Lua local variable snippet{{{
	"local",
	fmt(
		[[ 
local {} = {}
  ]],
		{ i(1, ""), i(2, "") }
	),
	"jj"
) --}}}

-- Tutorial Snippets go here --

-- End Refactoring --

return snippets, autosnippets
