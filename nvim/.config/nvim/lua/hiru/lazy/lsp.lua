-- Neovim 0.11+ / nvim-lspconfig v3 API:
--   vim.lsp.config('server', { ... })  — configure a server
--   vim.lsp.enable({ ... })            — enable servers
-- require('lspconfig').server.setup() is removed.

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "stevearc/conform.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
    "b0o/schemastore.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },

  config = function()
    local cmp     = require("cmp")
    local cmp_lsp = require("cmp_nvim_lsp")
    local luasnip = require("luasnip")

    require("luasnip.loaders.from_vscode").lazy_load()
    luasnip.config.setup({
      history      = true,
      updateevents = "TextChanged,TextChangedI",
    })

    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities()
    )

    require("fidget").setup({})

    -- ── Global: apply capabilities to every server ────────────────────────
    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    -- ── Per-server overrides ──────────────────────────────────────────────

    vim.lsp.config("lua_ls", {
      root_markers = { ".luarc.json", ".luarc.jsonc", "stylua.toml", ".git", "pyproject.toml" },
      settings = {
        Lua = {
          format = {
            enable = true,
            defaultConfig = { indent_style = "space", indent_size = "2" },
          },
        },
      },
    })

    vim.lsp.config("basedpyright", {
      on_attach = function(client)
        -- Formatting handled exclusively by ruff via conform
        client.server_capabilities.documentFormattingProvider      = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
      settings = {
        basedpyright = {
          analysis = {
            typeCheckingMode      = "standard",
            autoImportCompletions = true,
            diagnosticSeverityOverrides = { reportAny = "none" },
          },
        },
      },
    })

    vim.lsp.config("ruff", {
      init_options = {
        settings = { lineLength = 88, fixAll = true },
      },
    })

    -- Resolve tofu via the user's shell (nvim's $PATH omits /opt/homebrew/bin)
    local tofu_path = vim.fn.trim(vim.fn.system("which tofu 2>/dev/null"))
    if tofu_path == "" then
      tofu_path = "/opt/homebrew/bin/tofu"  -- Homebrew Apple Silicon fallback
    end

    vim.lsp.config("terraformls", {
      -- terraform-ls requires an absolute path for the CLI binary
      init_options = {
        terraform = { path = tofu_path },
      },
      filetypes    = { "terraform", "terraform-vars", "hcl" },
      root_markers = { ".terraform", ".terraform.lock.hcl", ".git" },
    })

    vim.lsp.config("yamlls", {
      settings = {
        yaml = {
          schemaStore = { enable = false, url = "" },
          schemas = {
            ["https://json.schemastore.org/github-workflow.json"] =
              ".github/workflows/*.{yml,yaml}",
            ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
              { "docker-compose*.{yml,yaml}" },
            -- Plain CloudFormation templates (no AWS::Serverless:: transform)
            ["https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json"] =
              { "cloudformation/*.{yml,yaml}", "infrastructure/*.{yml,yaml}", "*.cf.{yml,yaml}" },
            -- SAM templates: official schema from the SAM CLI's own repo, covers
            -- AWS::Serverless::* resources with a generic fallback for plain CFN ones
            ["https://raw.githubusercontent.com/aws/serverless-application-model/main/samtranslator/validator/sam_schema/schema.json"] =
              { "template.{yml,yaml}", "**/template.{yml,yaml}" },
          },
          -- Short-form intrinsic function tags used throughout CloudFormation/SAM
          -- templates (!Ref, !Sub, !GetAtt, ...). Without these yamlls treats them
          -- as parse errors ("unresolved tag") instead of valid YAML.
          customTags = {
            "!And", "!And sequence",
            "!If", "!If sequence",
            "!Not", "!Not sequence",
            "!Equals", "!Equals sequence",
            "!Or", "!Or sequence",
            "!Condition",
            "!FindInMap", "!FindInMap sequence",
            "!Base64",
            "!Cidr", "!Cidr sequence",
            "!Ref",
            "!Sub", "!Sub sequence",
            "!GetAtt",
            "!GetAZs",
            "!ImportValue",
            "!Select", "!Select sequence",
            "!Split", "!Split sequence",
            "!Join", "!Join sequence",
          },
          validate   = true,
          completion = true,
          hover      = true,
        },
      },
    })

    vim.lsp.config("jsonls", {
      settings = {
        json = {
          schemas  = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    })

    vim.lsp.config("tailwindcss", {
      filetypes = {
        "html", "css", "scss",
        "javascript", "javascriptreact",
        "typescript", "typescriptreact",
        "vue", "svelte", "heex",
      },
    })

    -- ── Mason: install servers, then enable them ──────────────────────────
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls", "tailwindcss",
        "basedpyright", "ruff", "bashls",
        "terraformls", "yamlls", "jsonls",
      },
    })

    require("mason-tool-installer").setup({
      ensure_installed = { "stylua", "prettier", "shfmt" },
    })

    vim.lsp.enable({
      "lua_ls", "tailwindcss",
      "basedpyright", "ruff", "bashls",
      "terraformls", "yamlls", "jsonls",
    })

    -- ── Completion ────────────────────────────────────────────────────────
    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-p>"]     = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"]     = cmp.mapping.select_next_item(cmp_select),
        ["<Enter>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm({ select = true })
                return
            end
            -- Expand bracket pairs with correct indentation, bypassing indentexpr
            local row, col = unpack(vim.api.nvim_win_get_cursor(0))
            local line     = vim.api.nvim_get_current_line()
            local before   = line:sub(col, col)
            local after    = line:sub(col + 1, col + 1)
            local bracket_pairs = { ["("] = ")", ["{"] = "}", ["["] = "]" }
            if bracket_pairs[before] == after then
                local base  = line:match("^%s*")
                local inner = base .. string.rep(" ", vim.bo.shiftwidth)
                vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { "", inner, base })
                vim.api.nvim_win_set_cursor(0, { row + 1, #inner })
                return
            end
            fallback()
        end, { "i", "s" }),
["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then cmp.select_next_item() else fallback() end
        end, { "i" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then cmp.select_prev_item() else fallback() end
        end, { "i" }),
      }),
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
      }, {
        { name = "buffer" },
        { name = "path" },
      }),
    })


    -- ── Diagnostics ───────────────────────────────────────────────────────
    vim.diagnostic.config({
      virtual_text   = { prefix = "●", spacing = 2 },
      signs          = true,
      underline      = true,
      update_in_insert = false,
      severity_sort  = true,
    })

    -- ── Snippet navigation ────────────────────────────────────────────────
    vim.keymap.set({ "i", "s" }, "<C-j>", function()
      if luasnip.expand_or_jumpable() then luasnip.expand_or_jump() end
    end, { silent = true, desc = "LuaSnip expand/jump forward" })

    vim.keymap.set({ "i", "s" }, "<C-k>", function()
      if luasnip.jumpable(-1) then luasnip.jump(-1) end
    end, { silent = true, desc = "LuaSnip jump back" })
  end,
}
