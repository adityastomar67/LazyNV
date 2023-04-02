return {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    opts = function()
        return {
            ensure_installed = require("config.user").mason_installed, -- not an option from mason.nvim
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
                    toggle_package_expand   = "<CR>",
                    install_package         = "i",
                    update_package          = "u",
                    check_package_version   = "c",
                    update_all_packages     = "U",
                    check_outdated_packages = "C",
                    uninstall_package       = "X",
                    cancel_installation     = "<C-c>",
                    apply_language_filter   = "<C-f>",
                }
            }
        }
    end,
    config = function(_, opts)
        local mason = require("mason")
        mason.setup(opts)
        vim.api.nvim_create_user_command("MasonInstallAll", function()
            vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
        end, {})
    end
}
