return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    dependencies = {

      --[[
      {
        "supermaven-inc/supermaven-nvim",
        opts = function(_, opts)
          opts.keymaps = {
            clear_suggestion = "<C-]>"
          }
          opts.disable_inline_completion = true

          return opts
        end,
      },
      --]]

      {
        "CopilotC-Nvim/CopilotChat.nvim",
        dependencies = {
          {
            "zbirenbaum/copilot.lua",
            config = function()
              require("copilot").setup({
                suggestion = { enabled = false },
                panel = { enabled = false },
              })
            end
          },
          { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
        },
        build = "make tiktoken", -- Only on MacOS or Linux
        opts = {
          -- See Configuration section for options
        },
        -- See Commands section for default commands if you want to lazy load on them
      },
      --[[
      {
        "zbirenbaum/copilot.lua",
        config = function()
          require("copilot").setup({
            suggestion = { enabled = false },
            panel = { enabled = false },
          })
        end
      },
      --]]
      {
        "zbirenbaum/copilot-cmp",
        dependencies = { "copilot.lua" },
        event = { "InsertEnter", "LspAttach" },
        fix_pairs = true,
        config = function()
          require("copilot_cmp").setup()
          -- attach cmp source whenever copilot attaches
          -- fixes lazy-loading issues with the copilot cmp source
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local buffer = args.buf ---@type number
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client and (not "copilot" or client.name == "copilot") then
                return require("copilot_cmp")._on_insert_enter(client, buffer)
              end
            end,
          })
          local cmp = require "cmp"
          local current_sources = cmp.get_config().sources or {}
          table.insert(current_sources, {
            name = "copilot",
            priority = 1000,
          })
          cmp.setup {
            sources = current_sources,
          }
        end,
      },
    },

    opts = function(_, opts)
      local cmp = require "cmp"

      opts.sources = {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "nvim_lua" },
        { name = "path" },
      }
      -- opts.sources[1].trigger_characters = { "-" }

      opts.window.border = 'rounded'
      opts.mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-Space>"] = cmp.mapping.confirm(),
        ["<C-e>"] = cmp.mapping.close(),

        --[[
        ["<CR>"] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Insert,
          select = true,
        },
        --]]

        ["<CR>"] = cmp.mapping({
          i = function(fallback)
            if cmp.visible() and cmp.get_active_entry() then
              cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
            else
              fallback()
            end
          end,
          s = cmp.mapping.confirm({ select = true }),
          c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
        }),

        --[[
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif require("luasnip").expand_or_jumpable() then
            require("luasnip").expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif require("luasnip").jumpable(-1) then
            require("luasnip").jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        --]]
      }

      return opts
    end,
  }

  --- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
