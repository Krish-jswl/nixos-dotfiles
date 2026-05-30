--------------------------------------------------
-- mason & automatic installations
--------------------------------------------------

require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = {
        "lua_ls",
        "marksman",
        "gopls",
        "pyright",
        "clangd",
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "jsonls",
    },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

--------------------------------------------------
-- keymaps
--------------------------------------------------

vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
    desc = "Go to definition",
})

vim.keymap.set("n", "K", vim.lsp.buf.hover, {
    desc = "Hover documentation",
})

vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {
    desc = "Go to implementation",
})

vim.keymap.set("n", "gr", vim.lsp.buf.references, {
    desc = "References",
})

vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, {
    desc = "Rename symbol",
})

vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {
    desc = "Code actions",
})

vim.keymap.set("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
end, {
    desc = "Format buffer",
})

vim.keymap.set("n", "df", vim.diagnostic.open_float, {
    desc = "Line diagnostics",
})

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {
    desc = "Previous diagnostic",
})

vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {
    desc = "Next diagnostic",
})

--------------------------------------------------
-- diagnostics
--------------------------------------------------

vim.diagnostic.config({
    virtual_text = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,

    float = {
        border = "rounded",
    },
})

--------------------------------------------------
-- lua_ls
--------------------------------------------------

vim.lsp.config("lua_ls", {
    capabilities = capabilities,

    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },

            workspace = {
                checkThirdParty = false,
            },

            telemetry = {
                enable = false,
            },
        },
    },
})

vim.lsp.enable("lua_ls")

--------------------------------------------------
-- marksman
--------------------------------------------------

vim.lsp.config("marksman", {
    capabilities = capabilities,
})

vim.lsp.enable("marksman")

--------------------------------------------------
-- gopls
--------------------------------------------------

vim.lsp.config("gopls", {
    capabilities = capabilities,
})

vim.lsp.enable("gopls")

--------------------------------------------------
-- pyright
--------------------------------------------------

vim.lsp.config("pyright", {
    capabilities = capabilities,
})

vim.lsp.enable("pyright")

--------------------------------------------------
-- clangd (C / C++)
--------------------------------------------------

vim.lsp.config("clangd", {
    capabilities = capabilities,
    cmd = {
        "clangd",
        "--offset-encoding=utf-16",
    },
})

vim.lsp.enable("clangd")

--------------------------------------------------
-- ts_ls (Web Dev: JavaScript & TypeScript)
--------------------------------------------------

vim.lsp.config("ts_ls", {
    capabilities = capabilities,
})

vim.lsp.enable("ts_ls")

--------------------------------------------------
-- html (Web Dev: HTML)
--------------------------------------------------

vim.lsp.config("html", {
    capabilities = capabilities,
})

vim.lsp.enable("html")

--------------------------------------------------
-- cssls (Web Dev: CSS)
--------------------------------------------------

vim.lsp.config("cssls", {
    capabilities = capabilities,
})

vim.lsp.enable("cssls")

--------------------------------------------------
-- tailwindcss (Web Dev: Tailwind CSS)
--------------------------------------------------

vim.lsp.config("tailwindcss", {
    capabilities = capabilities,
})

vim.lsp.enable("tailwindcss")

--------------------------------------------------
-- jsonls (Web Dev: JSON)
--------------------------------------------------

vim.lsp.config("jsonls", {
    capabilities = capabilities,
})

vim.lsp.enable("jsonls")
