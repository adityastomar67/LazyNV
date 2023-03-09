return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    enabled = plugin_enabled.lualine,
    config = function()
      local components = require "plugins.extras.ui.statusline.components"

      require("lualine").setup {
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = {},
          section_separators = {},
          disabled_filetypes = {
            statusline = { "alpha", "lazy" },
            winbar = {
              "help",
              "alpha",
              "lazy",
            },
          },
          always_divide_middle = true,
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { components.git_repo, "branch" },
          lualine_c = {
            components.diff,
            components.diagnostics,
            components.noice_command,
            components.noice_mode,
            components.separator,
            components.lsp_client,
          },
          lualine_x = { "filename", components.spaces, "encoding", "fileformat", "filetype", "progress" },
          lualine_y = {},
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "nvim-tree", "toggleterm", "quickfix" },
      }
    end,
  },
  {
    "tamton-aquib/staline.nvim",
    enabled = plugin_enabled.staline,
    event = "VeryLazy",
    opts = {
      defaults = {
        expand_null_ls    = false, -- This expands out all the null-ls sources to be shown
        left_separator    = "  ",
        right_separator   = "",
        full_path         = false,
        line_column       = "[%l/%L] :%c",
        inactive_color    = "#212126",
        inactive_bgcolor  = "none",
        true_colors       = true, -- true lsp colors.
        font_active       = "none", -- "bold", "italic", "bold,italic", etc
        mod_symbol        = "*",
        lsp_client_symbol = "",
        branch_symbol     = " ",
        cool_symbol       = "   ", -- Change this to override default OS icon.
        null_ls_symbol    = ""    -- A symbol to indicate that a source is coming from null-ls
        -- fg                = "#0f0f0f",     -- Foreground text color.
        -- bg                = "#0f0f0f",     -- Default background is transparent.
      },
      mode_colors = {
        n = "#6d92b7",
        i = "#74be88",
        c = "#da696d",
        V = "#e1b56a",
        v = "#e1b56a"
      },
      mode_icons = {
        n = "  NORMAL ",
        i = "  INSERT ",
        c = "  COMMAND ",
        V = "  SELECT",
        v = "  BLOCK "
      },
      sections = {
        left = {
          -- '-mode', 'left_sep_double',
          { 'StalineFilename', 'file_name' },
          { "StalineBranch",   "branch" }, ' ', 'lsp'
        },
        mid = { ' ' },
        right = {
          ' '
          -- {'StalineLogo', 'cool_symbol'}, {'StalineFolderSep', 'right_sep'},
          -- {'StalineFolderIcon', '  '}, {'StalineFolderText', 'cwd'}, ' ',
          -- {"StalineProgressSep", 'right_sep'},
          -- {"StalineProgressSepIcon", '  '},
          -- {'StalineProgress', 'line_column'}
        }
      },
      special_table = {
        NvimTree   = { 'NvimTree', ' ' },
        packer     = { 'Packer', ' ' },
        lazy       = { 'Lazy', '󰒲  ' },
        mason      = { 'Mason', ' ' },
        toggleterm = { 'Terminal', "  " }
      },
      lsp_symbols = {
        Error = "  ",
        Info  = "  ",
        Warn  = "  ",
        Hint  = "  "
      }
    },
    config = function(_, opts)
      require("staline").setup(opts)
    end,
  }
}
