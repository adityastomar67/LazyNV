--- ### LazyNV Core Bootstrap
--
-- This module simply sets up the global `lazynv` module.
-- This is automatically loaded and should not be resourced, everything is accessible through the global `lazynv` variable.
--
-- @module lazynv.bootstrap
-- @copyright 2023
-- @license GNU General Public License v3.0

_G.lazynv = {}

-- lazynv.User = {}

vim.g.plugin_enabled = lazynv.User.plugins