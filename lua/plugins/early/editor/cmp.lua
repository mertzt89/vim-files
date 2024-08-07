local Plugin = { "hrsh7th/nvim-cmp" }

Plugin.dependencies = {
  -- Sources
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "saadparwaiz1/cmp_luasnip" },
  { "hrsh7th/cmp-nvim-lsp" },

  -- Snippets
  { "L3MON4D3/LuaSnip" },
  { "rafamadriz/friendly-snippets" },

  -- Icons
  { "onsails/lspkind.nvim" },
}

Plugin.event = "InsertEnter"

Plugin.opts = function()
  local cmp = require("cmp")
  local luasnip = require("luasnip")
  local select_opts = { behavior = cmp.SelectBehavior.Select }
  return {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    sources = {
      { name = "path" },
      { name = "nvim_lsp" },
      { name = "buffer", keyword_length = 3 },
      { name = "luasnip", keyword_length = 2 },
    },
    formatting = {
      fields = { "menu", "abbr", "kind" },
      format = function(entry, vim_item)
        vim_item.abbr = vim.trim(vim_item.abbr)
        if vim.tbl_contains({ "path" }, entry.source.name) then
          local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
          if icon then
            vim_item.kind = icon
            vim_item.kind_hl_group = hl_group
            return vim_item
          end
        end
        return require("lspkind").cmp_format({ with_text = true })(entry, vim_item)
      end,
    },
    -- See :help cmp-mapping
    mapping = {
      ["<Up>"] = cmp.mapping.select_prev_item(select_opts),
      ["<Down>"] = cmp.mapping.select_next_item(select_opts),

      ["<C-p>"] = cmp.mapping.select_prev_item(select_opts),
      ["<C-n>"] = cmp.mapping.select_next_item(select_opts),

      ["<C-u>"] = cmp.mapping.scroll_docs(-4),
      ["<C-d>"] = cmp.mapping.scroll_docs(4),

      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<C-y>"] = cmp.mapping.confirm({ select = true }),
      ["<CR>"] = cmp.mapping.confirm({ select = false }),

      ["<C-f>"] = cmp.mapping(function(fallback)
        if luasnip.jumpable(1) then
          luasnip.jump(1)
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<C-b>"] = cmp.mapping(function(fallback)
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<Tab>"] = cmp.mapping(function(fallback)
        local col = vim.fn.col(".") - 1

        if cmp.visible() then
          cmp.select_next_item(select_opts)
        elseif col == 0 or vim.fn.getline("."):sub(col, col):match("%s") then
          fallback()
        else
          cmp.complete()
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item(select_opts)
        else
          fallback()
        end
      end, { "i", "s" }),
    },
  }
end

function Plugin.config(_, opts)
  vim.opt.completeopt = { "menu", "menuone", "noselect" }

  local cmp = require("cmp")

  require("luasnip.loaders.from_vscode").lazy_load()

  -- See :help cmp-config
  cmp.setup(opts)
end

return Plugin
