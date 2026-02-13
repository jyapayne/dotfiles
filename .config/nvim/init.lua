-- Leader keys (must be set before lazy setup)
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.termguicolors = true

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
  { "rust-lang/rust.vim" },
  { "jyapayne/nim.vim" },
  { "tpope/vim-fugitive" },
  { "tpope/vim-unimpaired" },
  { "preservim/nerdtree" },
  { "Xuyuanp/nerdtree-git-plugin" },
  { "hynek/vim-python-pep8-indent" },
  { "pangloss/vim-javascript" },
  { "Glench/Vim-Jinja2-Syntax" },
  { "tpope/vim-haml" },
  { "hdima/python-syntax" },
  { "hail2u/vim-css3-syntax" },
  { "mxw/vim-jsx" },
  { "ryanoasis/vim-devicons" },
  { "johnstef99/vim-nerdtree-syntax-highlight" },
  { "jistr/vim-nerdtree-tabs" },
  { "mustache/vim-mustache-handlebars" },
  { "vim-scripts/errormarker.vim" },
  { "elixir-lang/vim-elixir" },
  { "jreybert/vim-largefile" },
  { "sbdchd/neoformat" },
  { "tikhomirov/vim-glsl" },
  {
    "svermeulen/vim-easyclip",
    init = function()
      vim.g.EasyClipUseGlobalPasteToggle = 0
      vim.g.EasyClipShareYanks = 1
      vim.g.EasyClipShareYanksFile = ".easyclip"
      vim.g.EasyClipShareYanksDir = vim.env.HOME
    end,
  },
  -- { "tpope/vim-obsession" },
  -- { "dhruvasagar/vim-prosession" },
  { "tmux-plugins/vim-tmux-focus-events" },
  {
    "rmagatti/auto-session",
    config = function()
      require("auto-session").setup({
        auto_save_enabled = true,
        auto_restore_enabled = true,
      })
    end,
  },
  { "vim-airline/vim-airline" },
  { "vim-airline/vim-airline-themes" },
  -- { "vim-syntastic/syntastic" },
  -- { "itchyny/lightline.vim" },
  { "morhetz/gruvbox" },
  { "tpope/vim-commentary" },
  { "w0rp/ale" },
  { "ctrlpvim/ctrlp.vim" },
  { "udalov/kotlin-vim" },
  { "simnalamburt/vim-mundo" },
  { "christoomey/vim-tmux-navigator" },
  { "tpope/vim-surround" },
  -- { "alaviss/nim.nvim" },
  { "prabirshrestha/asyncomplete.vim" },
  { "tpope/vim-repeat" },
  { "christoomey/vim-sort-motion" },
  { "christoomey/vim-system-copy" },
  { "michaeljsmith/vim-indent-object" },
  { "kana/vim-textobj-user" },
  { "kana/vim-textobj-line", dependencies = { "kana/vim-textobj-user" } },
  { "Julian/vim-textobj-brace", dependencies = { "kana/vim-textobj-user" } },
  { "bps/vim-textobj-python", dependencies = { "kana/vim-textobj-user" } },
  { "wellle/targets.vim" },
  {
    "junegunn/fzf",
    build = "./install --bin",
  },
  { "junegunn/fzf.vim" },
  { "jremmen/vim-ripgrep" },
  { "rescript-lang/vim-rescript" },
  {
    "neoclide/coc.nvim",
    branch = "master",
    build = "yarn install --frozen-lockfile",
    lazy = false,
    config = function()
      -- coc-settings.json path note:
      -- If you reference vim-rescript server.js directly, update plugged path to lazy path:
      -- ~/.local/share/nvim/lazy/vim-rescript/server/out/server.js

      _G.check_back_space = function()
        local col = vim.fn.col(".") - 1
        return col == 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
      end

      _G.show_docs = function()
        if vim.tbl_contains({ "vim", "help" }, vim.bo.filetype) then
          vim.cmd("h " .. vim.fn.expand("<cword>"))
        elseif vim.fn["coc#rpc#ready"]() == 1 then
          vim.fn.CocActionAsync("doHover")
        else
          vim.cmd("!" .. vim.o.keywordprg .. " " .. vim.fn.expand("<cword>"))
        end
      end

      local expr_opts = { expr = true, silent = true, noremap = true, replace_keycodes = false }
      local expr_nowait_opts = { expr = true, silent = true, nowait = true, noremap = true, replace_keycodes = false }

      vim.keymap.set(
        "i",
        "<Tab>",
        'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "\\<Tab>" : coc#refresh()',
        expr_opts
      )
      vim.keymap.set("i", "<S-Tab>", 'coc#pum#visible() ? coc#pum#prev(1) : "\\<C-h>"', expr_opts)
      vim.keymap.set(
        "i",
        "<CR>",
        'coc#pum#visible() ? coc#pum#confirm() : "\\<C-g>u\\<CR>\\<c-r>=coc#on_enter()\\<CR>"',
        expr_opts
      )

      if vim.fn.has("nvim") == 1 then
        vim.keymap.set("i", "<C-Space>", "coc#refresh()", expr_opts)
      else
        vim.keymap.set("i", "<C-@>", "coc#refresh()", expr_opts)
      end

      vim.keymap.set("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true, remap = true })
      vim.keymap.set("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true, remap = true })

      vim.keymap.set("n", "gd", "<Plug>(coc-definition)", { silent = true, remap = true })
      vim.keymap.set("n", "gy", "<Plug>(coc-type-definition)", { silent = true, remap = true })
      vim.keymap.set("n", "gi", "<Plug>(coc-implementation)", { silent = true, remap = true })
      vim.keymap.set("n", "gr", "<Plug>(coc-references)", { silent = true, remap = true })

      vim.keymap.set("n", "<leader>rn", "<Plug>(coc-rename)", { remap = true })
      vim.keymap.set("x", "<leader>f", "<Plug>(coc-format-selected)", { remap = true })
      vim.keymap.set("n", "<leader>f", "<Plug>(coc-format-selected)", { remap = true })

      vim.keymap.set("x", "<leader>a", "<Plug>(coc-codeaction-selected)", { remap = true })
      vim.keymap.set("n", "<leader>a", "<Plug>(coc-codeaction-selected)", { remap = true })
      vim.keymap.set("n", "<leader>ac", "<Plug>(coc-codeaction)", { remap = true })
      vim.keymap.set("n", "<leader>qf", "<Plug>(coc-fix-current)", { remap = true })

      vim.keymap.set("x", "if", "<Plug>(coc-funcobj-i)", { remap = true })
      vim.keymap.set("o", "if", "<Plug>(coc-funcobj-i)", { remap = true })
      vim.keymap.set("x", "af", "<Plug>(coc-funcobj-a)", { remap = true })
      vim.keymap.set("o", "af", "<Plug>(coc-funcobj-a)", { remap = true })
      vim.keymap.set("x", "ic", "<Plug>(coc-classobj-i)", { remap = true })
      vim.keymap.set("o", "ic", "<Plug>(coc-classobj-i)", { remap = true })
      vim.keymap.set("x", "ac", "<Plug>(coc-classobj-a)", { remap = true })
      vim.keymap.set("o", "ac", "<Plug>(coc-classobj-a)", { remap = true })

      vim.keymap.set("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "\\<C-f>"', expr_nowait_opts)
      vim.keymap.set("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "\\<C-b>"', expr_nowait_opts)
      vim.keymap.set(
        "i",
        "<C-f>",
        'coc#float#has_scroll() ? "\\<c-r>=coc#float#scroll(1)\\<cr>" : "\\<Right>"',
        expr_nowait_opts
      )
      vim.keymap.set(
        "i",
        "<C-b>",
        'coc#float#has_scroll() ? "\\<c-r>=coc#float#scroll(0)\\<cr>" : "\\<Left>"',
        expr_nowait_opts
      )
      vim.keymap.set("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "\\<C-f>"', expr_nowait_opts)
      vim.keymap.set("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "\\<C-b>"', expr_nowait_opts)

      vim.keymap.set("n", "<C-s>", "<Plug>(coc-range-select)", { silent = true, remap = true })
      vim.keymap.set("x", "<C-s>", "<Plug>(coc-range-select)", { silent = true, remap = true })

      vim.keymap.set("n", "<space>a", ":<C-u>CocList diagnostics<CR>", { silent = true, nowait = true })
      vim.keymap.set("n", "<space>e", ":<C-u>CocList extensions<CR>", { silent = true, nowait = true })
      vim.keymap.set("n", "<space>c", ":<C-u>CocList commands<CR>", { silent = true, nowait = true })
      vim.keymap.set("n", "<space>o", ":<C-u>CocList outline<CR>", { silent = true, nowait = true })
      vim.keymap.set("n", "<space>s", ":<C-u>CocList -I symbols<CR>", { silent = true, nowait = true })
      vim.keymap.set("n", "<space>j", ":<C-u>CocNext<CR>", { silent = true, nowait = true })
      vim.keymap.set("n", "<space>k", ":<C-u>CocPrev<CR>", { silent = true, nowait = true })
      vim.keymap.set("n", "<space>p", ":<C-u>CocListResume<CR>", { silent = true, nowait = true })

      vim.schedule(function()
        vim.keymap.set("n", "K", "<Cmd>lua _G.show_docs()<CR>", { silent = true, noremap = true })
      end)

      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          vim.fn.CocActionAsync("highlight")
        end,
      })

      local coc_group = vim.api.nvim_create_augroup("mygroup", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = coc_group,
        pattern = { "typescript", "json" },
        command = "setlocal formatexpr=CocAction('formatSelected')",
      })
      vim.api.nvim_create_autocmd("User", {
        group = coc_group,
        pattern = "CocJumpPlaceholder",
        callback = function()
          vim.fn.CocActionAsync("showSignatureHelp")
        end,
      })

      vim.api.nvim_create_user_command("Format", function()
        vim.fn.CocAction("format")
      end, { nargs = 0 })

      vim.api.nvim_create_user_command("Fold", function(opts)
        if opts.args == "" then
          vim.fn.CocAction("fold")
        else
          vim.fn.CocAction("fold", opts.args)
        end
      end, { nargs = "?" })

      vim.api.nvim_create_user_command("OR", function()
        vim.fn.CocAction("runCommand", "editor.action.organizeImport")
      end, { nargs = 0 })

      vim.o.statusline = "%{coc#status()}%{get(b:,'coc_current_function','')}" .. vim.o.statusline
    end,
  },
  { "kassio/neoterm" },
  { "reasonml-editor/vim-reason-plus" },
  {
    "jyapayne/vim-code-dark",
    lazy = false,
    priority = 1000,
  },
  -- { "jyapayne/vimspector" },
  { "nvim-lua/popup.nvim" },
  { "nvim-lua/plenary.nvim" },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-lua/popup.nvim",
    },
    config = function()
      require("telescope").setup()
      require("telescope").load_extension("dap")
    end,
  },
  { "kyazdani42/nvim-web-devicons" },
  { "ryanoasis/vim-devicons" },
  {
    "TimUntersberger/neogit",
    config = function()
      require("neogit").setup({
        disable_commit_confirmation = true,
        integrations = {
          diffview = true,
        },
      })
    end,
  },
  { "sindrets/diffview.nvim", branch = "main" },
  {
    "lewis6991/gitsigns.nvim",
    branch = "main",
    config = function()
      require("gitsigns").setup({ word_diff = true })
    end,
  },
  { "peterhoeg/vim-qml" },
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")

      local function os_capture(cmd)
        local f = assert(io.popen(cmd .. " 2>&1", "r"))
        local s = assert(f:read("*a"))
        f:close()
        return s
      end

      dap.adapters.lldb = {
        type = "executable",
        command = "/opt/homebrew/opt/llvm/bin/lldb-vscode",
        name = "lldb",
      }

      dap.configurations.nim = {
        {
          name = "Launch",
          type = "lldb",
          request = "launch",
          program = function()
            print("Compiling...")
            local filename = vim.api.nvim_buf_get_name(0)
            os_capture("nim c --debugger:native " .. filename)
            print("Running...")
            return filename:match("(.+)%..+$")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = function()
            return vim.fn.input("Args: ", "")
          end,
          runInTerminal = false,
        },
      }

      require("dap-python").setup("/opt/homebrew/bin/python3")

      vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "ErrorMsg", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "●", texthl = "LineNr", linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint", { text = "L", texthl = "", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "→", texthl = "WarningMsg", linehl = "debugPC", numhl = "" })
    end,
  },
  { "posva/vim-vue" },
  -- { "rcarriga/nvim-dap-ui" },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.config").setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "go" },
        sync_install = false,
        auto_install = true,
        ignore_install = {},
        highlight = {
          enable = true,
          disable = { "python", "nim" },
          additional_vim_regex_highlighting = false,
        },
        playground = {
          enable = true,
          disable = {},
          updatetime = 25,
          persist_queries = false,
          keybindings = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?",
          },
        },
      })
    end,
  },
  -- { "nvim-treesitter/playground" },
  { "nvim-telescope/telescope-dap.nvim" },
  { "theHamsta/nvim-dap-virtual-text" },
  { "mfussenegger/nvim-dap-python" },
  { "KabbAmine/vCoolor.vim" },
  -- { "chrisbra/Colorizer" },
  {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  },
  -- hologram.nvim is abandoned/experimental and crashes on buffer close
  -- { "edluffy/hologram.nvim" },
  { "fatih/vim-go" },
  { "folke/trouble.nvim" },
  -- { "baabelfish/nvim-nim" },
})

-- Options and globals
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

vim.g.ale_shell = "/bin/bash"
vim.g.lsp_log_verbose = 1
vim.g.lsp_log_file = vim.fn.expand("/tmp/vim-lsp.log")
vim.g["airline#extensions#ale#enabled"] = 1
vim.g.syntastic_c_compiler_options = "-std=c99"
vim.g.pydiction_location = "/home/joey/.vim/bundle/pydiction/complete-dict"
vim.g.jsx_ext_required = 0
vim.g.asyncrun_auto = "make"
vim.g.syntastic_enable_elixir_checker = 1
vim.g.syntastic_elixir_checkers = { "elixir" }
vim.g.LargeFile = 20
vim.g.airline_powerline_fonts = 1
vim.g.airline_section_x = ""
vim.g.airline_section_y = ""
vim.g.airline_section_warning = ""
vim.g.airline_section_z = "%l/%L:%c"
vim.g.syntastic_check_on_wq = 0
vim.g.python_highlight_space_errors = 0
vim.g.NERDTreeDirArrowExpandable = "▸"
vim.g.NERDTreeDirArrowCollapsible = "▾"
vim.g.syntastic_javascript_checkers = { "eslint", "flow" }
vim.g.syntastic_java_checkers = {}
vim.g.neoformat_javascript_prettier = {
  exe = "prettier",
  args = { "--single-quote", "--trailing-comma all" },
}
vim.g.toggleJSFormat = 0
vim.g.ycm_autoclose_preview_window_after_completion = 1
vim.g.ycm_min_num_of_chars_for_completion = 99
vim.g["flow#enable"] = 0
vim.g.ctrlp_custom_ignore = {
  dir = [[\v[\/](\.git|node_modules|nimcache|\.sass-cache|bower_components|build|dist)$]],
  file = [[\v\.(exe|so|dll|o)$]],
  link = "",
}
vim.g.ctrlp_prompt_mappings = {
  ['AcceptSelection("e")'] = { "<c-t>" },
  ['AcceptSelection("t")'] = { "<cr>", "<2-LeftMouse>" },
}
vim.g.gitsigns_head = "main"
vim.g.asyncomplete_auto_completeopt = 0
vim.g.neoterm_default_mod = "vertical botright"
vim.g.neoterm_autoinsert = 1
vim.g.neoterm_autoscroll = 1
vim.g.neoterm_term_per_tab = 1
vim.g.dap_virtual_text = true
vim.g.ale_linters = { java = {}, python = {}, typescript = {} }
vim.g.NVIM_TUI_ENABLE_CURSOR_SHAPE = 0
vim.g.NVIM_TUI_ENABLE_TRUE_COLOR = 1

vim.env.NVIM_TUI_ENABLE_CURSOR_SHAPE = "0"
vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = "1"

vim.opt.inccommand = "nosplit"
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
vim.opt.wildmenu = true
vim.opt.wildmode = "full"
vim.opt.smartindent = true
vim.opt.ruler = true
vim.opt.backspace = "2"
vim.opt.autowrite = true
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.history = 10000
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99
vim.opt.laststatus = 2
vim.opt.undofile = true
vim.opt.undodir = vim.env.HOME .. "/.vim/undo"
vim.opt.undolevels = 10000
vim.opt.undoreload = 10000
vim.opt.incsearch = true
vim.opt.mouse = "a"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamedplus"
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0
vim.opt.hidden = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.cmdheight = 1
vim.opt.updatetime = 300
vim.opt.shortmess:append("c")
if vim.fn.has("nvim-0.5.0") == 1 or vim.fn.has("patch-8.1.1564") == 1 then
  vim.opt.signcolumn = "number"
else
  vim.opt.signcolumn = "yes"
end
vim.opt.switchbuf:append({ "usetab", "newtab" })
vim.opt.termguicolors = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "line"
vim.opt.showmode = false
vim.opt.background = "dark"
vim.opt.rtp:append("/usr/local/opt/fzf")

if vim.fn.executable("ag") == 1 then
  vim.opt.grepprg = "ag --nogroup --nocolor --vimgrep"
  vim.g.ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  vim.g.ctrlp_use_caching = 0
end

if vim.g.autocommands_loaded == nil then
  vim.g.autocommands_loaded = 1
end

vim.cmd("set t_Co=256")
vim.cmd("filetype plugin indent on")
vim.cmd("filetype on")
vim.cmd("syntax on")
vim.cmd("syntax enable")

-- Keymaps
vim.keymap.set("n", "gm", "m", { noremap = true })
vim.keymap.set("n", "<Tab>", "<C-w>w", { noremap = true })

vim.keymap.set({ "n", "v" }, "<C-n>", ":NERDTreeTabsToggle<CR>", { remap = true })

vim.keymap.set({ "n", "v" }, "<F9>", "<Cmd>lua ToggleJSFormat(1)<CR>", { remap = true })
vim.keymap.set("n", "=j", ":%!python3 -m json.tool<CR>", { remap = true })
vim.keymap.set("n", "<F5>", ":let _s=@/<Bar>:%s/\\s\\+$//e<Bar>:let @/=_s<Bar>:nohl<CR>", { silent = true, noremap = true })
vim.keymap.set({ "n", "v" }, "<F3>", ":mksession! ~/.vim_session <CR>", { remap = true })
vim.keymap.set({ "n", "v" }, "<F4>", ":source ~/.vim_session <CR>", { remap = true })
vim.keymap.set("n", "<F6>", ":MundoToggle<CR>", { noremap = true })

vim.keymap.set("n", "<leader>d", '"_d', { noremap = true })
vim.keymap.set("v", "<leader>d", '"_d', { noremap = true })

vim.keymap.set("n", "<C-Up>", "[e", { remap = true })
vim.keymap.set("n", "<C-Down>", "]e", { remap = true })
vim.keymap.set("v", "<C-Up>", "[egv", { remap = true })
vim.keymap.set("v", "<C-Down>", "]egv", { remap = true })
vim.keymap.set("v", "<C-k>", "[egv", { remap = true })
vim.keymap.set("v", "<C-j>", "]egv", { remap = true })
vim.keymap.set("v", "#", ":s#^#\\##<CR>", { noremap = true })
vim.keymap.set("v", "-#", ":s#^\\###<CR>", { noremap = true })

vim.keymap.set("n", "<leader>ff", ":Rg<CR>", { noremap = true })

vim.keymap.set("v", "<leader>p", '"_dP', { noremap = true })

vim.keymap.set({ "n", "v", "o" }, "˙", "gT", { noremap = true })
vim.keymap.set({ "n", "v", "o" }, "¬", "gt", { noremap = true })
vim.keymap.set({ "n", "v", "o" }, "<M-h>", "gT", { noremap = true })
vim.keymap.set({ "n", "v", "o" }, "<M-l>", "gt", { noremap = true })

vim.keymap.set("i", "˙", "<Esc>gTi", { noremap = true })
vim.keymap.set("i", "¬", "<Esc>gti", { noremap = true })
vim.keymap.set("i", "<M-h>", "<Esc>gTi", { noremap = true })
vim.keymap.set("i", "<M-l>", "<Esc>gti", { noremap = true })

vim.keymap.set("n", "riW", "ciW<C-r>0<Esc>", { noremap = true })
vim.keymap.set("n", "riw", "ciw<C-r>0<Esc>", { noremap = true })

vim.keymap.set("n", "K", ':grep! "\\b<C-R><C-W>\\b"<CR>:cw<CR>', { silent = true, noremap = true })

vim.keymap.set("n", "<leader><space>", ":Telescope find_files<CR>", { noremap = true })
vim.keymap.set("n", "<leader>fd", ":lua telescope_find_files_in_path()<CR>", { noremap = true })
vim.keymap.set("n", "<leader>fD", ":lua telescope_live_grep_in_path()<CR>", { noremap = true })
vim.keymap.set("n", "<leader>ft", ':lua telescope_find_files_in_path("./tests")<CR>', { noremap = true })
vim.keymap.set("n", "<leader>fT", ':lua telescope_live_grep_in_path("./tests")<CR>', { noremap = true })
vim.keymap.set("n", "<leader>fo", ":Telescope file_browser<CR>", { noremap = true })
vim.keymap.set("n", "<leader>fn", ":Telescope git_files<CR>", { noremap = true })
vim.keymap.set("n", "<leader>fg", ":Telescope git_branches<CR>", { noremap = true })
vim.keymap.set("n", "<leader>fb", ":Telescope buffers<CR>", { noremap = true })
vim.keymap.set("n", "<leader>fs", ":Telescope lsp_document_symbols<CR>", { noremap = true })
vim.keymap.set("n", "<leader>ff", ":Telescope live_grep<CR>", { noremap = true })
vim.keymap.set("n", "<leader>FF", ":Telescope grep_string<CR>", { noremap = true })

vim.keymap.set("n", "<Esc>", function()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative ~= "" then
      vim.api.nvim_win_close(win, false)
    end
  end
end, { silent = true, noremap = true })

vim.keymap.set("n", "<leader>db", ":lua require'dap'.toggle_breakpoint()<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "ø", ":lua require'dap'.step_out()<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "˚", ":lua require'dap'.step_into()<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "∆", ":lua require'dap'.step_over()<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>ds", ":lua require'dap'.close()<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>dn", ":lua require'dap'.continue()<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>dk", ":lua require'dap'.up()<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>dj", ":lua require'dap'.down()<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>d_", ":lua require'dap'.disconnect();require'dap'.stop();require'dap'.run_last()<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.toggle()<CR><C-w>l", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>rc", ":lua require'dap'.run_to_cursor()<CR><C-w>l", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>rb", ":lua require'dap'.reverse_continue()<CR><C-w>l", { silent = true, noremap = true })
vim.keymap.set("v", "<leader>di", ":lua require'dap.ui.variables'.visual_hover()<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>d?", ":lua require'dap.ui.variables'.scopes()<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>de", ":lua require'dap'.set_exception_breakpoints({\"all\"})<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>da", ":lua require'debugHelper'.attach()<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>dA", ":lua require'debugHelper'.attachToRemote()<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>di", ":lua require'dap.ui.widgets'.hover()<CR>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>qq", ":q<CR>", { silent = true, noremap = true })
vim.keymap.set(
  "n",
  "<leader>d?",
  ":lua local widgets=require'dap.ui.widgets';widgets.centered_float(widgets.scopes)<CR>",
  { silent = true, noremap = true }
)
vim.keymap.set("n", "<leader>df", ":Telescope dap frames<CR>", { noremap = true })
vim.keymap.set("n", "<leader>dc", ":Telescope dap commands<CR>", { noremap = true })
vim.keymap.set("n", "<leader>dh", ":Telescope dap list_breakpoints<CR>", { noremap = true })

vim.keymap.set("n", "<leader>gg", ":Neogit<CR>", { noremap = true })
vim.keymap.set("n", "<leader>gd", ":DiffviewOpen<CR>", { noremap = true })
vim.keymap.set("n", "<leader>gD", ":DiffviewOpen main<CR>", { noremap = true })
vim.keymap.set("n", "<leader>gl", ":Neogit log<CR>", { noremap = true })
vim.keymap.set("n", "<leader>gp", ":Neogit push<CR>", { noremap = true })

vim.keymap.set("n", "<C-t>", ":Ttoggle<CR>", { noremap = true })
vim.keymap.set("i", "<C-t>", "<Esc>:Ttoggle<CR>", { noremap = true })
vim.keymap.set("t", "<C-t>", "<C-\\><C-n>:Ttoggle<CR>", { noremap = true })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

vim.keymap.set("n", "<F1>", ":CocCommand java.debug.vimspector.start<CR>", { remap = true })

vim.keymap.set("n", "<leader>y", '"+y', { remap = true })
vim.keymap.set("v", "<leader>y", '"+y', { remap = true })
vim.keymap.set("n", "<leader>p", '"+p', { remap = true })
vim.keymap.set("v", "<leader>p", '"+p', { remap = true })

-- Autocommands
local binary_group = vim.api.nvim_create_augroup("Binary", { clear = true })
vim.api.nvim_create_autocmd("BufReadPre", {
  group = binary_group,
  pattern = "*.bin",
  command = "let &bin=1",
})
vim.api.nvim_create_autocmd("BufReadPost", {
  group = binary_group,
  pattern = "*.bin",
  command = "if &bin | %!xxd | endif",
})
vim.api.nvim_create_autocmd("BufReadPost", {
  group = binary_group,
  pattern = "*.bin",
  command = "set ft=xxd",
})
vim.api.nvim_create_autocmd("BufWritePre", {
  group = binary_group,
  pattern = "*.bin",
  command = "if &bin | %!xxd -r | endif",
})
vim.api.nvim_create_autocmd("BufWritePost", {
  group = binary_group,
  pattern = "*.bin",
  command = "if &bin | %!xxd | endif",
})
vim.api.nvim_create_autocmd("BufWritePost", {
  group = binary_group,
  pattern = "*.bin",
  command = "set nomod",
})

local ft_group = vim.api.nvim_create_augroup("FileTypeSettings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = ft_group,
  pattern = "javascript",
  command = "setlocal ts=2 sw=2 expandtab",
})
vim.api.nvim_create_autocmd("FileType", {
  group = ft_group,
  pattern = { "nim", "ts", "vue", "less", "css", "typescript" },
  command = "setlocal ts=2 sts=2 sw=2 expandtab",
})
vim.api.nvim_create_autocmd("FileType", {
  group = ft_group,
  pattern = "python",
  command = "setlocal nosmartindent",
})

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*",
  command = 'if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif',
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.py", "*.js", "*.jsx", "*.nim", "*.ml", "*.mli" },
  command = [[match OverLength /\%89v.\+/]],
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.py", "*.js", "*.jsx", "*.nim", "*.ml", "*.mli" },
  command = [[2match ExtraWhiteSpace /\s\+$\|\t/]],
})
vim.api.nvim_create_autocmd("StdinReadPost", {
  pattern = "*",
  command = "set buftype=nofile",
})

vim.api.nvim_create_autocmd("CompleteDone", {
  pattern = "*",
  command = "if pumvisible() == 0 | pclose | endif",
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local last_pos = vim.fn.line([['"]])
    if last_pos > 0 then
      if last_pos <= vim.fn.line("$") then
        vim.cmd([[normal! g`"]])
      else
        vim.cmd("normal! $")
      end
    end
  end,
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.sass",
  command = "set filetype=sass",
})
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*.shpaml",
  command = "setfiletype shpaml",
})

local transparent_group = vim.api.nvim_create_augroup("TransparentUI", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = transparent_group,
  pattern = "*",
  callback = function()
    if _G.SetTransparent then
      _G.SetTransparent()
    end
  end,
})

local extra_ws_group = vim.api.nvim_create_augroup("ExtraWhitespaceHi", { clear = true })
vim.api.nvim_create_autocmd("ColorScheme", {
  group = extra_ws_group,
  pattern = "*",
  command = "highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen",
})

local rescript_group = vim.api.nvim_create_augroup("RescriptMappings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = rescript_group,
  pattern = "rescript",
  callback = function(args)
    vim.keymap.set("n", "<localleader>r", ":RescriptFormat<CR>", { silent = true, noremap = true, buffer = args.buf })
    vim.keymap.set("n", "<localleader>t", ":RescriptTypeHint<CR>", { silent = true, noremap = true, buffer = args.buf })
    vim.keymap.set("n", "<localleader>b", ":RescriptBuild<CR>", { silent = true, noremap = true, buffer = args.buf })
    vim.keymap.set("n", "gd", ":RescriptJumpToDefinition<CR>", { silent = true, noremap = true, buffer = args.buf })
  end,
})

local ocaml_group = vim.api.nvim_create_augroup("OcamlMappings", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = ocaml_group,
  pattern = "ocaml",
  callback = function(args)
    vim.keymap.set("n", "<C-t>", ":MerlinTypeOf<CR>", { remap = true, buffer = args.buf })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.b.coc_root_patterns = {
      ".git",
      ".env",
      "venv",
      ".venv",
      "setup.cfg",
      "setup.py",
      "pyrightconfig.json",
      "env",
    }
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "vue",
  callback = function()
    vim.b.coc_root_patterns = {
      ".git",
      ".env",
      "package.json",
      "tsconfig.json",
      "jsconfig.json",
      "vite.config.ts",
      "vite.config.js",
      "vue.config.js",
      "nuxt.config.ts",
    }
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "dap-repl",
  callback = function()
    require("dap.ext.autocompl").attach()
  end,
})

-- User commands
vim.api.nvim_create_user_command("C", function()
  vim.fn.setreg("/", "")
end, {})

vim.api.nvim_create_user_command("CC", "%s#_\\(\\l\\)#\\u\\1#g", {})
vim.api.nvim_create_user_command("U", "%s#\\C\\(\\<\\u[a-z0-9]\\+\\|[a-z0-9]\\+\\)\\(\\u\\)#\\l\\1_\\l\\2#g", {})

vim.api.nvim_create_user_command("Make", function(opts)
  local cmd = "AsyncRun"
  if opts.bang then
    cmd = cmd .. "!"
  end
  cmd = cmd .. " -program=make @"
  if opts.args ~= "" then
    cmd = cmd .. " " .. opts.args
  end
  vim.cmd(cmd)
end, { bang = true, nargs = "*", complete = "file" })

-- Custom functions
_G.ToggleJSFormat = function(...)
  local argc = select("#", ...)
  if argc == 1 then
    vim.g.toggleJSFormat = 1 - vim.g.toggleJSFormat
  end

  if vim.g.toggleJSFormat == 0 then
    vim.cmd("autocmd!")
    vim.cmd("autocmd BufWritePre *.js Neoformat")
    vim.cmd("autocmd BufWritePre *.jsx Neoformat")
  else
    vim.cmd("autocmd!")
    vim.cmd("autocmd BufWritePre *.js \"\"")
    vim.cmd("autocmd BufWritePre *.jsx \"\"")
  end
end

_G.JumpToDef = function()
  if vim.fn.exists("*GotoDefinition_" .. vim.bo.filetype) == 1 then
    vim.cmd("call GotoDefinition_" .. vim.bo.filetype .. "()")
  else
    vim.cmd("normal! <C-]>")
  end
end

_G.WrapForTmux = function(s)
  if vim.env.TMUX == nil then
    return s
  end
  local tmux_start = "\27Ptmux;"
  local tmux_end = "\27\\"
  return tmux_start .. s:gsub("\27", "\27\27") .. tmux_end
end

_G.XTermPasteBegin = function()
  vim.opt.pastetoggle = "<Esc>[201~"
  vim.opt.paste = true
  return ""
end

_G.SynGroup = function()
  local s = vim.fn.synID(vim.fn.line("."), vim.fn.col("."), 1)
  print(vim.fn.synIDattr(s, "name") .. " -> " .. vim.fn.synIDattr(vim.fn.synIDtrans(s), "name"))
end

_G.SetTransparent = function()
  local groups = {
    "Normal",
    "NormalNC",
    "SignColumn",
    "EndOfBuffer",
    "FoldColumn",
    "LineNr",
    "MsgArea",
    "CursorLine",
    "CursorLineNr",
    "StatusLine",
    "StatusLineNC",
    "WinSeparator",
    "VertSplit",
    "NormalFloat",
    "FloatBorder",
  }
  for _, g in ipairs(groups) do
    vim.cmd("hi " .. g .. " ctermbg=NONE guibg=NONE")
  end
end

_G.telescope_find_files_in_path = function(path)
  local _path = path or vim.fn.input("Dir: ", "", "dir")
  require("telescope.builtin").find_files({ search_dirs = { _path } })
end

_G.telescope_live_grep_in_path = function(path)
  local _path = path or vim.fn.input("Dir: ", "", "dir")
  require("telescope.builtin").live_grep({ search_dirs = { _path } })
end

pcall(function()
  vim.cmd([[let &t_SI .= v:lua.WrapForTmux("\<Esc>[?2004h")]])
  vim.cmd([[let &t_EI .= v:lua.WrapForTmux("\<Esc>[?2004l")]])
end)
vim.keymap.set("i", "<Esc>[200~", "v:lua.XTermPasteBegin()", { expr = true, noremap = true })

vim.b.current_syntax = "nim"
pcall(function()
  vim.cmd("let &t_SI = \"\\e[5 q\"")
  vim.cmd("let &t_EI = \"\\e[2 q\"")
end)

-- Highlights
if vim.fn.exists("syntax_on") == 1 then
  vim.cmd("syntax reset")
end

local bg = "#000000"
local fg = "#ffffff"
local fg2 = "#ebebeb"
local fg3 = "#d6d6d6"
local fg4 = "#c2c2c2"
local bg2 = "#141414"
local bg3 = "#292929"
local bg4 = "#3d3d3d"
local keyword = "#a65a00"
local builtin = "#10a500"
local const = "#CC0000"
local comment = "#2d64a4"
local func = "#00a0e2"
local str = "#C40000"
local typec = "#3B9B00"
local ident = "#06989A"
local preproc = "#75507B"
local var = "#ffffff"
local warning = "#e81050"
local warning2 = "#e86310"
local parenbg = "#3a71c9"
local todo = "yellow"

vim.cmd("hi Normal guifg=" .. fg .. " guibg=" .. bg)
vim.cmd("hi Cursor guifg=" .. bg .. " guibg=" .. fg)
vim.cmd("hi CursorLine guibg=" .. bg2)
vim.cmd("hi CursorColumn guibg=" .. bg2)
vim.cmd("hi ColorColumn guibg=" .. bg2)
vim.cmd("hi LineNr guifg=" .. fg2 .. " guibg=" .. bg2)
vim.cmd("hi VertSplit guifg=" .. fg3 .. " guibg=" .. bg3)
vim.cmd("hi MatchParen guifg=" .. fg .. " guibg=" .. parenbg .. " gui=none")
vim.cmd("hi Pmenu guifg=" .. fg .. " guibg=" .. bg2)
vim.cmd("hi PmenuSel guibg=" .. bg3)
vim.cmd("hi IncSearch guifg=" .. bg .. " guibg=" .. keyword)
vim.cmd("hi Directory guifg=" .. const)
vim.cmd("hi Folded guifg=" .. fg4 .. " guibg=" .. bg)

vim.cmd("hi Boolean guifg=" .. const)
vim.cmd("hi Character guifg=" .. const)
vim.cmd("hi Comment guifg=" .. comment)
vim.cmd("hi Conditional guifg=" .. keyword)
vim.cmd("hi Constant guifg=" .. const)
vim.cmd("hi Define guifg=" .. keyword)
vim.cmd("hi DiffAdd guifg=#000000 guibg=#ddffdd gui=bold")
vim.cmd("hi DiffDelete guifg=#ff0000")
vim.cmd("hi DiffChange guibg=" .. bg2)
vim.cmd("hi DiffText guifg=#000000 guibg=#ddddff gui=bold")
vim.cmd("hi ErrorMsg guifg=" .. warning .. " guibg=" .. bg2 .. " gui=bold")
vim.cmd("hi WarningMsg guifg=" .. fg .. " guibg=" .. warning2)
vim.cmd("hi Float guifg=" .. const)
vim.cmd("hi Function guifg=" .. func)
vim.cmd("hi Identifier guifg=" .. ident .. " gui=italic")
vim.cmd("hi Keyword guifg=" .. keyword .. " gui=bold")
vim.cmd("hi Label guifg=" .. var)
vim.cmd("hi NonText guifg=" .. bg4 .. " guibg=" .. bg2)
vim.cmd("hi Number guifg=" .. const)
vim.cmd("hi Operater guifg=" .. keyword)
vim.cmd("hi PreProc guifg=" .. preproc)
vim.cmd("hi Special guifg=" .. preproc)
vim.cmd("hi SpecialKey guifg=" .. fg2 .. " guibg=" .. bg2)
vim.cmd("hi Statement guifg=" .. keyword)
vim.cmd("hi StorageClass guifg=" .. typec .. " gui=italic")
vim.cmd("hi String guifg=" .. str)
vim.cmd("hi Tag guifg=" .. keyword)
vim.cmd("hi Title guifg=" .. fg .. " gui=bold")
vim.cmd("hi Todo guibg=" .. todo .. " guifg=black gui=bold")
vim.cmd("hi Type guifg=" .. typec .. " gui=none")
vim.cmd("hi Underlined gui=underline")

vim.cmd("hi rubyAttribute guifg=" .. builtin)
vim.cmd("hi rubyLocalVariableOrMethod guifg=" .. var)
vim.cmd("hi rubyGlobalVariable guifg=" .. var .. " gui=italic")
vim.cmd("hi rubyInstanceVariable guifg=" .. var)
vim.cmd("hi rubyKeyword guifg=" .. keyword)
vim.cmd("hi rubyKeywordAsMethod guifg=" .. keyword .. " gui=bold")
vim.cmd("hi rubyClassDeclaration guifg=" .. keyword .. " gui=bold")
vim.cmd("hi rubyClass guifg=" .. keyword .. " gui=bold")
vim.cmd("hi rubyNumber guifg=" .. const)

vim.cmd("hi pythonBuiltinFunc guifg=" .. builtin)
vim.cmd("hi goBuiltins guifg=" .. builtin)
vim.cmd("hi jsBuiltins guifg=" .. builtin)
vim.cmd("hi jsFunction guifg=" .. keyword .. " gui=bold")
vim.cmd("hi jsGlobalObjects guifg=" .. typec)
vim.cmd("hi jsAssignmentExps guifg=" .. var)
vim.cmd("hi htmlLink guifg=" .. var .. " gui=underline")
vim.cmd("hi htmlStatement guifg=" .. keyword)
vim.cmd("hi htmlSpecialTagName guifg=" .. keyword)
vim.cmd("hi mkdCode guifg=" .. builtin)

vim.cmd("highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen")
vim.cmd("highlight ALEError ctermbg=red guibg=#700000")
vim.cmd("highlight ALEErrorSign ctermfg=none ctermbg=black guifg=red guibg=#212121")
vim.cmd("highlight ALEWarning ctermbg=yellow guibg=#504a08")
vim.cmd("highlight ALEWarningSign ctermfg=yellow ctermbg=none guibg=#212121 guifg=#ecd517")
vim.cmd("highlight SignColumn ctermbg=darkgrey guibg=#212121")
vim.cmd("highlight CocFadeOut ctermfg=lightgrey guifg=#8B8C92")
vim.cmd("highlight CocHintSign guifg=#647644 ctermfg=lightblue ctermbg=darkgrey guibg=#212121")
vim.cmd("highlight CocErrorSign guifg=red ctermfg=red ctermbg=darkgrey guibg=#212121")
vim.cmd("highlight CocInlayHint guifg=#3D7671 ctermfg=lightblue ctermbg=darkgrey guibg=none")
vim.cmd("highlight CocHighlightText ctermbg=lightblue guibg=#002c4b")

vim.cmd("hi Normal ctermbg=none guibg=none")
vim.cmd("hi EndOfBuffer ctermbg=none guibg=none")
vim.cmd("hi NonText ctermbg=none guibg=none")
vim.cmd("hi LineNr ctermbg=none guibg=none")
vim.cmd("hi CursorLine guibg=NONE ctermbg=NONE gui=NONE cterm=NONE")

vim.cmd("hi GitSignsAdd ctermfg=green ctermbg=none guibg=#212121 guifg=#32cd32 gui=bold cterm=bold")
vim.cmd("hi GitSignsDelete ctermfg=red ctermbg=none guibg=#212121 guifg=#ff6347 gui=bold cterm=bold")
vim.cmd("hi GitSignsChange ctermfg=blue ctermbg=none guibg=#212121 guifg=#1e90ff gui=bold cterm=bold")
vim.cmd("hi GitSignsAddInline ctermfg=none ctermbg=none guibg=#306C37 guifg=none gui=bold cterm=bold")
vim.cmd("hi GitSignsDeleteInline ctermfg=red ctermbg=none guibg=#740009 guifg=none gui=bold cterm=bold")
vim.cmd("hi GitSignsChangeInline ctermfg=blue ctermbg=none guibg=#0043AE guifg=none gui=bold cterm=bold")
vim.cmd("hi GitSignsAddLnInline ctermfg=green ctermbg=none guibg=#306C37 guifg=none gui=bold cterm=bold")
vim.cmd("hi GitSignsDeleteLnInline ctermfg=red ctermbg=none guibg=#740009 guifg=none gui=bold cterm=bold")
vim.cmd("hi GitSignsChangeLnInline ctermfg=blue ctermbg=none guibg=#0043AE guifg=none gui=bold cterm=bold")
vim.cmd("hi GitSignsAddVirtLnInline ctermfg=green ctermbg=none guibg=#306C37 guifg=none gui=bold cterm=bold")
vim.cmd("hi GitSignsDeleteVirtLnInline ctermfg=red ctermbg=none guibg=#740009 guifg=none gui=bold cterm=bold")
vim.cmd("hi GitSignsChangeVirtLnInline ctermfg=blue ctermbg=none guibg=#0043AE guifg=none gui=bold cterm=bold")

-- Colorscheme application
pcall(vim.cmd, "colorscheme codedark")
_G.SetTransparent()
vim.cmd("hi CursorLine guibg=NONE ctermbg=NONE gui=bold,undercurl cterm=bold guisp=#777777")
