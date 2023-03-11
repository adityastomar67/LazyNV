return {
    "vim-test/vim-test",
    enabled = vim.g.plugin_enabled.vim_test,
    event = "VeryLazy",
    keys = {
      { "<leader>tc", "<cmd>TestClass<cr>",   desc = "Class" },
      { "<leader>tf", "<cmd>TestFile<cr>",    desc = "File" },
      { "<leader>tl", "<cmd>TestLast<cr>",    desc = "Last" },
      { "<leader>tn", "<cmd>TestNearest<cr>", desc = "Nearest" },
      { "<leader>ts", "<cmd>TestSuite<cr>",   desc = "Suite" },
      { "<leader>tv", "<cmd>TestVisit<cr>",   desc = "Visit" },
    },
    config = function()
      vim.g["test#strategy"] = "neovim"
      vim.g["test#neovim#term_position"] = "belowright"
      vim.g["test#neovim#preserve_screen"] = 1
      vim.g["test#python#runner"] = "pyunit" -- pytest
    end,
  }