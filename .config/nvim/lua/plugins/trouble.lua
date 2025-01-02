-- trouble.nvim configuration
return {
  "folke/trouble.nvim",
  cmd = { "Trouble" },
  config = function()
    require("trouble").setup({
      modes = {
        lsp = {
          win = { position = "right" },
        },
      },
    })

    -- Define key mappings
    local map = vim.keymap.set

    map("n", "<leader>xx", "<cmd>TroubleToggle<cr>", { desc = "Diagnostics (Trouble)" })
    map("n", "<leader>xX", "<cmd>TroubleToggle document_diagnostics<cr>", { desc = "Buffer Diagnostics (Trouble)" })
    map("n", "<leader>cs", "<cmd>TroubleToggle lsp_document_symbols<cr>", { desc = "Symbols (Trouble)" })
    map(
      "n",
      "<leader>cS",
      "<cmd>TroubleToggle lsp_references<cr>",
      { desc = "LSP references/definitions/... (Trouble)" }
    )
    map("n", "<leader>xL", "<cmd>TroubleToggle loclist<cr>", { desc = "Location List (Trouble)" })
    map("n", "<leader>xQ", "<cmd>TroubleToggle quickfix<cr>", { desc = "Quickfix List (Trouble)" })

    map("n", "[q", function()
      if require("trouble").is_open() then
        require("trouble").previous({ skip_groups = true, jump = true })
      else
        local ok, err = pcall(vim.cmd.cprev)
        if not ok then
          vim.notify(err, vim.log.levels.ERROR)
        end
      end
    end, { desc = "Previous Trouble/Quickfix Item" })

    map("n", "]q", function()
      if require("trouble").is_open() then
        require("trouble").next({ skip_groups = true, jump = true })
      else
        local ok, err = pcall(vim.cmd.cnext)
        if not ok then
          vim.notify(err, vim.log.levels.ERROR)
        end
      end
    end, { desc = "Next Trouble/Quickfix Item" })
  end,
}
