return {
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
  },
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-telescope/telescope-ui-select.nvim",
      "ahmedkhalf/project.nvim",
    },
    config = function()
      function telescope_image_preview()
        local supported_images = { "svg", "png", "jpg", "jpeg", "gif", "webp", "avif" }
        local from_entry = require("telescope.from_entry")
        local Path = require("plenary.path")
        local conf = require("telescope.config").values
        local Previewers = require("telescope.previewers")

        local previewers = require("telescope.previewers")
        local image_api = require("image")

        local is_image_preview = false
        local image = nil
        local last_file_path = ""

        local is_supported_image = function(filepath)
          local split_path = vim.split(filepath:lower(), ".", { plain = true })
          local extension = split_path[#split_path]
          return vim.tbl_contains(supported_images, extension)
        end

        local delete_image = function()
          if not image then
            return
          end

          image:clear()

          is_image_preview = false
        end

        local create_image = function(filepath, winid, bufnr)
          image = image_api.hijack_buffer(filepath, winid, bufnr)

          if not image then
            return
          end

          vim.schedule(function()
            image:render()
          end)

          is_image_preview = true
        end

        local function defaulter(f, default_opts)
          default_opts = default_opts or {}
          return {
            new = function(opts)
              if conf.preview == false and not opts.preview then
                return false
              end
              opts.preview = type(opts.preview) ~= "table" and {} or opts.preview
              if type(conf.preview) == "table" then
                for k, v in pairs(conf.preview) do
                  opts.preview[k] = vim.F.if_nil(opts.preview[k], v)
                end
              end
              return f(opts)
            end,
            __call = function()
              local ok, err = pcall(f(default_opts))
              if not ok then
                error(debug.traceback(err))
              end
            end,
          }
        end

        -- NOTE: Add teardown to cat previewer to clear image when close Telescope
        local file_previewer = defaulter(function(opts)
          opts = opts or {}
          local cwd = opts.cwd or vim.fn.getcwd()
          return Previewers.new_buffer_previewer({
            title = "File Preview",
            dyn_title = function(_, entry)
              return Path:new(from_entry.path(entry, true)):normalize(cwd)
            end,

            get_buffer_by_name = function(_, entry)
              return from_entry.path(entry, true)
            end,

            define_preview = function(self, entry, _)
              local p = from_entry.path(entry, true)
              if p == nil or p == "" then
                return
              end

              conf.buffer_previewer_maker(p, self.state.bufnr, {
                bufname = self.state.bufname,
                winid = self.state.winid,
                preview = opts.preview,
              })
            end,

            teardown = function(_)
              if is_image_preview then
                delete_image()
              end
            end,
          })
        end, {})

        local buffer_previewer_maker = function(filepath, bufnr, opts)
          -- NOTE: Clear image when preview other file
          if is_image_preview and last_file_path ~= filepath then
            delete_image()
          end

          last_file_path = filepath

          if is_supported_image(filepath) then
            filepath = string.gsub(filepath, " ", "%%20"):gsub("\\", "")
            create_image(filepath, opts.winid, bufnr)
          else
            previewers.buffer_previewer_maker(filepath, bufnr, opts)
          end
        end

        return { buffer_previewer_maker = buffer_previewer_maker, file_previewer = file_previewer.new }
      end

      local image_preview = telescope_image_preview()

      -- Define the function globally to ensure it is accessible for keymaps
      _G.find_nvim_files = function()
        local builtin = require("telescope.builtin")
        builtin.find_files({
          prompt_title = " Neovim Config",
          cwd = "~/.config/nvim", -- Set the directory to search in
          hidden = true,          -- Show hidden files, useful in config directories
        })
      end

      local colors = require("catppuccin.palettes").get_palette()

      -- Telescope highlight groups
      local TelescopeColors = {
        -- Matching and Selection
        TelescopeMatching = { fg = colors.peach },
        TelescopeSelection = { fg = colors.text, bg = colors.surface1, bold = true },
        -- Prompt highlights
        TelescopePromptPrefix = { bg = colors.surface1 },
        TelescopePromptNormal = { bg = colors.surface1 },
        TelescopePromptBorder = { bg = colors.surface1, fg = colors.surface1 },
        TelescopePromptTitle = { bg = colors.red, fg = colors.mantle },
        -- Results highlights
        TelescopeResultsNormal = { bg = colors.mantle },
        TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
        TelescopeResultsTitle = { fg = colors.overlay2 },
        -- Preview highlights
        TelescopePreviewNormal = { bg = colors.mantle },
        TelescopePreviewBorder = { bg = colors.mantle, fg = colors.mantle },
        TelescopePreviewTitle = { bg = colors.green, fg = colors.crust },
      }

      -- Apply highlights
      for highlight_group, color_settings in pairs(TelescopeColors) do
        vim.api.nvim_set_hl(0, highlight_group, color_settings)
      end

      -- Telescope setup
      require("telescope").setup({
        defaults = {
          file_previewer = image_preview.file_previewer,
          buffer_previewer_maker = image_preview.buffer_previewer_maker,
          prompt_prefix = "   ",
          selection_caret = "➤ ",
          path_display = { "smart" },
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              preview_width = 0.55,
              width = 0.9,
              height = 0.9,
              prompt_position = "top",
            },
            vertical = {
              height = 0.4,
              preview_height = 0.3,
              width = 0.9,
              preview_cutoff = 10,
              prompt_position = "top",
            },
            center = {
              anchor = "N",
              width = 0.9,
              preview_cutoff = 10,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            -- theme = "dropdown",
          },
          colorscheme = {
            enable_preview = true,
          },
        },
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown({}),
          },
        },
      })

      -- Keymap setup
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<C-p>", builtin.find_files, {})
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
      vim.keymap.set("n", "<leader><leader>", builtin.oldfiles, {})
      vim.api.nvim_set_keymap(
        "n",
        "<leader>fc",
        "<cmd>lua find_nvim_files()<CR>",
        { noremap = true, silent = true }
      )

      -- Load extensions
      require("telescope").load_extension("ui-select")
      require("telescope").load_extension("fzf")
      require("telescope").load_extension("noice")
      require("telescope").load_extension("projects")
    end,
  },
}
