return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim"
    },
    keys = {
      { "<leader>nt", "<cmd>Neotree toggle<cr>", desc = "Toggle NeoTree" }
    },
  },
}
