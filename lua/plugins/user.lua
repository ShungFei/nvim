-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:

---@type LazySpec
return {
  -- overrides
  {
    "kawre/leetcode.nvim",
    opts = {
      theme = {
        ["normal"] = { fg = "#ADB0BB" },
      },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    opts = {
      auto_scroll = false,
    },
  },
  {
    "OXY2DEV/markview.nvim",
    ft = function()
      local plugin = require("lazy.core.config").spec.plugins["markview.nvim"]
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      return opts.preview.filetypes or { "markdown", "quarto", "rmd" }
    end,
    opts = {
      preview = {
        ignore_buftypes = {},
        filetypes = {
          "md",
          "markdown",
          "norg",
          "rmd",
          "org",
          "vimwiki",
          "typst",
          "latex",
          "quarto",
          "Avante",
          "codecompanion",
        },
      },
    },
  },

  -- customize dashboard options
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      local get_icon = require("astroui").get_icon
      opts.dashboard = {
        width = 69,
        pane_gap = 16,
        preset = {
          keys = {
            { key = "n", action = "<Leader>n", icon = get_icon("FileNew", 0, true), desc = "New File  " },
            { key = "f", action = "<Leader>ff", icon = get_icon("Search", 0, true), desc = "Find File  " },
            { key = "w", action = "<Leader>fw", icon = get_icon("WordFile", 0, true), desc = "Find Word  " },
            { key = "'", action = "<Leader>f'", icon = get_icon("Bookmarks", 0, true), desc = "Bookmarks  " },
            { key = "s", action = "<Leader>Sl", icon = get_icon("Refresh", 0, true), desc = "Last Session  " },
          },
          header = table.concat({
            [[                                                                     ]],
            [[                                                                   ]],
            [[      ████ ██████           █████      ██                    ]],
            [[     ███████████             █████                            ]],
            [[     █████████ ███████████████████ ███   ███████████  ]],
            [[    █████████  ███    █████████████ █████ ██████████████  ]],
            [[   █████████ ██████████ █████████ █████ █████ ████ █████  ]],
            [[ ███████████ ███    ███ █████████ █████ █████ ████ █████ ]],
            [[██████  █████████████████████ ████ █████ █████ ████ ██████]],
            [[                                                                     ]],
          }, "\n"),
        },

        -- https://github.com/folke/snacks.nvim/discussions/111#discussioncomment-11382576
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          {
            pane = 1,
            icon = " ",
            title = "Recent Files",
            section = "recent_files",
            indent = 2,
            padding = 1,
            limit = 3,
            key = "o",
            action = function() require("snacks").dashboard.pick "oldfiles" end,
          },
          {
            pane = 1,
            icon = " ",
            title = "Projects",
            section = "projects",
            indent = 2,
            padding = 2,
            limit = 3,
            key = "p",
            action = function() require("snacks").dashboard.pick "projects" end,
          },
          function()
            local in_git = require("snacks").git.get_root() ~= nil
            return {
              pane = 2,
              icon = " ",
              desc = "Browse Repo",
              enabled = in_git,
              padding = 1,
              key = "b",
              action = function() require("snacks").gitbrowse() end,
            }
          end,
          function()
            local in_git = require("snacks").git.get_root() ~= nil
            local cmds = {
              -- GitHub stuff is slooooow: see https://github.com/folke/snacks.nvim/issues/1769
              -- {
              --   title = "Notifications",
              --   cmd = "gh notify -s -a -n5",
              --   action = function() vim.ui.open "https://github.com/notifications" end,
              --   key = "n",
              --   icon = " ",
              --   height = 5,
              --   enabled = true,
              -- },
              -- {
              --   title = "Open Issues",
              --   cmd = "gh issue list -L 3",
              --   key = "i",
              --   action = function() vim.fn.jobstart("gh issue list --web", { detach = true }) end,
              --   icon = " ",
              --   height = 7,
              -- },
              -- {
              --   icon = " ",
              --   title = "Open PRs",
              --   cmd = "gh pr list -L 3",
              --   key = "P",
              --   action = function() vim.fn.jobstart("gh pr list --web", { detach = true }) end,
              --   height = 7,
              -- },
              {
                icon = " ",
                title = "Git Status",
                cmd = "git --no-pager diff --stat -B -M -C",
                height = 10,
              },
            }
            return vim.tbl_map(
              function(cmd)
                return vim.tbl_extend("force", {
                  pane = 2,
                  section = "terminal",
                  enabled = in_git,
                  padding = 1,
                  ttl = 5 * 60,
                  indent = 3,
                }, cmd)
              end,
              cmds
            )
          end,
          { section = "startup" },
        },
      }
    end,
  },

  -- You can disable default plugins as follows:
  { "max397574/better-escape.nvim", enabled = false },

  -- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
  {
    "L3MON4D3/LuaSnip",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.luasnip"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom luasnip configuration such as filetype extend or custom snippets
      local luasnip = require "luasnip"
      luasnip.filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts) -- include the default astronvim config that calls the setup call
      -- add more custom autopairs configuration such as custom rules
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules(
        {
          Rule("$", "$", { "tex", "latex" })
            -- don't add a pair if the next character is %
            :with_pair(cond.not_after_regex "%%")
            -- don't add a pair if  the previous character is xxx
            :with_pair(
              cond.not_before_regex("xxx", 3)
            )
            -- don't move right when repeat character
            :with_move(cond.none())
            -- don't delete if the next character is xx
            :with_del(cond.not_after_regex "xx")
            -- disable adding a newline when you press <cr>
            :with_cr(cond.none()),
        },
        -- disable for .vim files, but it work for another filetypes
        Rule("a", "a", "-vim")
      )
    end,
  },
}
