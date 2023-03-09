return {
    {
        "echasnovski/mini.map",
        enabled = plugin_enabled.mini.map,
        opts = {},
        keys = {
            --stylua: ignore
            { "<leader>vm", function() require("mini.map").toggle {} end, desc = "Toggle Minimap", },
        },
        config = function(_, opts)
            require("mini.map").setup(opts)
        end,
    },
    {
        "echasnovski/mini.move",
        enabled = plugin_enabled.mini.move,
        opts = {},
        keys = { "<<M-h>", "<M-l>", "<M-j>", "<M-k>" },
        config = function(_, opts)
            require("mini.move").setup(opts)
        end,
    },
    {
        "echasnovski/mini.ai",
        enabled = plugin_enabled.mini.ai,
        keys = {
            { "a", mode = { "x", "o" } },
            { "i", mode = { "x", "o" } },
        },
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter-textobjects",
                init = function()
                    -- no need to load the plugin, since we only need its queries
                    require("lazy.core.loader").disable_rtp_plugin "nvim-treesitter-textobjects"
                end,
            },
        },
        opts = function()
            local ai = require "mini.ai"
            return {
                n_lines = 500,
                custom_textobjects = {
                    o = ai.gen_spec.treesitter({
                        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
                    }, {}),
                    f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
                    c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
                },
            }
        end,
        config = function(_, opts)
            local ai = require "mini.ai"
            ai.setup(opts)
        end,
    },
    {
        "echasnovski/mini.bufremove",
        enabled = plugin_enabled.mini.bufremove,
        -- stylua: ignore
        keys = {
            { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
            { "<leader>bD", function() require("mini.bufremove").delete(0, true) end,  desc = "Delete Buffer (Force)" },
        },
    },
    {
        "echasnovski/mini.animate",
        enabled = plugin_enabled.mini.animate,
        event = "VeryLazy",
        enabled = false,
        config = function(_, _)
            require("mini.animate").setup()
        end,
    },
    {
      "echasnovski/mini.comment",
    enabled = plugin_enabled.mini.comment,
      event = "VeryLazy",
      opts = {
        hooks = {
          pre = function()
            require("ts_context_commentstring.internal").update_commentstring {}
          end,
        },
      },
      config = function(_, opts)
        require("mini.comment").setup(opts)
      end,
    }
}
