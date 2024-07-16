local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    css = { "prettier" },
    html = { "prettier" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    javascriptreact = { "prettier" },
    vue = { "prettier" },
  },

  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

require("conform").setup(options)

local null_ls = require "null-ls"
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup {
  sources = {
    null_ls.builtins.formatting.eslint_d.with {
      filetypes = {
        "typescript",
        "javascript",
        "typescriptreact",
        "javascriptreact",
        "javascriptvue",
        "typescriptvue",
        -- "vue"
      },
    },
    null_ls.builtins.formatting.lua_format,
    null_ls.builtins.diagnostics.eslint_d.with {
      filetypes = {
        "typescript",
        "javascript",
        "typescriptreact",
        "javascriptreact",
        "javascriptvue",
        "typescriptvue",
        -- "vue"
      },
    },

    null_ls.builtins.formatting.stylua,
    null_ls.builtins.diagnostics.ltrs,
    null_ls.builtins.formatting.rustfmt,
    null_ls.builtins.formatting.prettierd.with {
      filetypes = {
        "css",
        "scss",
        "less",
        "html",
        "json",
        "jsonc",
        "yaml",
        "markdown",
        "markdown.mdx",
        "graphql",
        "handlebars",
        "vue",
      },
    },
  },
  on_attach = function(client, bufnr)
    if client.supports_method "textDocument/formatting" then
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format {
            bufnr = bufnr,
            filter = function(client)
              return client.name == "null-ls"
            end,
          }
          -- vim.lsp.buf.formatting_sync()
        end,
      })
    end
  end,
}
