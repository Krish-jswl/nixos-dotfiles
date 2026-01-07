return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    vim.diagnostic.config({
      virtual_text = {
        prefix = "●",
        spacing = 4,
        source = "always",
      },
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = "rounded",
        source = "always",
      },
    })

    vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, {
      desc = "Show diagnostic message",
    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local opts = { buffer = args.buf, silent = true }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      end,
    })


    vim.lsp.config("clangd", {
      capabilities = capabilities,
      init_options = {
        completeUnimported = false,
      },
    })

    vim.lsp.config("gopls", {
      capabilities = capabilities,
    })

    vim.lsp.config("pyright", {
      capabilities = capabilities,
    })

    vim.lsp.config("nil", {
      capabilities = capabilities,
    })

    vim.lsp.config("bashls", {
      capabilities = capabilities,
    })

    vim.lsp.config("tsserver", {
      capabilities = capabilities,
    })

    vim.lsp.config("html", {
      capabilities = capabilities,
    })

    vim.lsp.config("cssls", {
      capabilities = capabilities,
    })


    vim.lsp.enable({
      "clangd",
      "gopls",
      "pyright",
      "nil",
      "bashls",
      "tsserver",
      "html",
      "cssls",
    })
  end,
}

