return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
-- or                              , branch = '0.1.x',
      dependencies = { 'nvim-lua/plenary.nvim' },
          keys = {
      { "<leader>t", "<cmd>Telescope find_files<cr>", desc = "Fuzzy find files" },
      { "<leader>f", "<cmd>Telescope live_grep<cr>", desc = "Fuzzy find file contents" },
      { "<leader>h", "<cmd>Telescope oldfiles<cr>", desc = "Recently opened files" },
      { "<leader>j", "<cmd>Telescope jumplist<cr>", desc = "Show jumplist" },
      { "<leader>rs", "<cmd>Telescope registers<cr>", desc = "Show register" },
      { "<leader>rg", "<cmd>Telescope grep_string<cr>", desc = "Find string under cursor in working dir" },
      { "<leader>b", "<cmd>Telescope buffers<cr>", desc = "List open buffers" },
      { "<leader>m", "<cmd>Telescope marks<cr>", desc = "List marks" },
      { "<leader>k", "<cmd>Telescope keymaps<cr>", desc = "Show keymaps" },
      { "<leader>lt", "<cmd>Telescope treesitter<cr>", desc = "Show treesitter symbols" },
      { "<leader>gs", "<cmd>Telescope git_status <cr>", desc = "Show git status" },
    },
    }
