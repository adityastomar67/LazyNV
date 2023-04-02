return {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    -- dependencies = {
    --     "williamboman/mason-lspconfig.nvim"
    -- },
    config = function()
        local mason = require("mason")
        mason.setup({
            ensure_installed = { "lua-language-server" },   -- not an option from mason.nvim
            max_concurrent_installers = 5,
            ui = {
                check_outdated_packages_on_open = true,
                border = "none",
                icons = {
                    package_installed   = "✓",
                    package_pending     = "➜",
                    package_uninstalled = "✗"
                },
                keymaps = {
                    -- Keymap to expand a package
                    toggle_package_expand   = "<CR>",
                    -- Keymap to install the package under the current cursor position
                    install_package         = "i",
                    -- Keymap to reinstall/update the package under the current cursor position
                    update_package          = "u",
                    -- Keymap to check for new version for the package under the current cursor position
                    check_package_version   = "c",
                    -- Keymap to update all installed packages
                    update_all_packages     = "U",
                    -- Keymap to check which installed packages are outdated
                    check_outdated_packages = "C",
                    -- Keymap to uninstall a package
                    uninstall_package       = "X",
                    -- Keymap to cancel a package installation
                    cancel_installation     = "<C-c>",
                    -- Keymap to apply language filter
                    apply_language_filter   = "<C-f>",
                }
            }
        })
        vim.api.nvim_create_user_command("MasonInstallAll", function()
            vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
        end, {})
    end
}
