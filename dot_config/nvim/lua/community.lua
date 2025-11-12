---@type LazySpec
return {
  "AstroNvim/astrocommunity",

  -- =========================
  --  🌐 Language Support
  -- =========================
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.typescript-all-in-one" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.mdx" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.python-ruff" },
  { import = "astrocommunity.pack.angular" },

  -- =========================
  --  🛠️ Workflow Enhancements
  -- =========================
  { import = "astrocommunity.game.leetcode-nvim" },
  { import = "astrocommunity.motion.harpoon" },
  { import = "astrocommunity.editing-support.auto-save-nvim" },
  { import = "astrocommunity.docker.lazydocker" },
  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.scrolling.mini-animate" },
  { import = "astrocommunity.utility.hover-nvim" },

  -- =========================
  --  📝 Note-Taking
  -- =========================
  { import = "astrocommunity.note-taking.obsidian-nvim" },
  { import = "astrocommunity.note-taking.global-note-nvim" },
}
