return {
  "abecodes/tabout.nvim",
  enabled = vim.g.plugin_enabled.tabout,
  event = "VeryLazy",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "hrsh7th/nvim-cmp",
  },
  config = true,
}
