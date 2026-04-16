--[[ Colorscheme ]]
-- vim.cmd("colorscheme lunaperche")

--[[ Setting up package manager]]
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

--[[ Configs ]]
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = false
vim.o.number = true
vim.o.relativenumber = true
vim.opt.colorcolumn = "100"
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
-- Fat cursor
vim.opt.guicursor = ""
vim.opt.wrap = false
vim.opt.hlsearch = false
vim.opt.incsearch = true
-- Enable mouse mode, can be useful for resizing splits
vim.o.mouse = "a"
vim.o.showmode = false
vim.o.breakindent = true
vim.o.undofile = true
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeout = false
-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
-- Preview substitutions live
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true

--[[ Keymaps ]]
-- With netrw
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Explore" })
-- With oil.nvim
vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", { desc = "Oil" })
-- Dragging lines in Visual Mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
-- Keep cursor in the middle when half-page jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- Keep cursor in the middle when searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "<leader>y", '"+y', { desc = "Copy into system clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy into system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Copy line into system clipboard" })
vim.keymap.set("n", "<leader>pp", '"+p', { desc = "Paste from system clipboard" })
-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

--[[ Autocommands ]]
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

--[[ Setting up plugins ]]
-- Setup lazy.nvim
require("lazy").setup({
    spec = {
        {
            "folke/which-key.nvim",
            event = "VimEnter",
            opts = {
                delay = 0,
                icons = {
                    mappings = vim.g.have_nerd_font,
                    keys = vim.g.have_nerd_font and {} or {
                        Up = "<Up> ",
                        Down = "<Down> ",
                        Left = "<Left> ",
                        Right = "<Right> ",
                        C = "<C-…> ",
                        M = "<M-…> ",
                        D = "<D-…> ",
                        S = "<S-…> ",
                        CR = "<CR> ",
                        Esc = "<Esc> ",
                        ScrollWheelDown = "<ScrollWheelDown> ",
                        ScrollWheelUp = "<ScrollWheelUp> ",
                        NL = "<NL> ",
                        BS = "<BS> ",
                        Space = "<Space> ",
                        Tab = "<Tab> ",
                        F1 = "<F1>",
                        F2 = "<F2>",
                        F3 = "<F3>",
                        F4 = "<F4>",
                        F5 = "<F5>",
                        F6 = "<F6>",
                        F7 = "<F7>",
                        F8 = "<F8>",
                        F9 = "<F9>",
                        F10 = "<F10>",
                        F11 = "<F11>",
                        F12 = "<F12>",
                    },
                },
                spec = {
                    { "<leader>s", group = "[S]earch", mode = { "n" } },
                }
            },
        },

        {
            "nvim-mini/mini.nvim",
            config = function()
                vim.cmd("colorscheme minicyan")

                local statusline = require("mini.statusline")
                statusline.setup({ use_icons = vim.g.have_nerd_font })
                statusline.section_location = function()
                    return "%2l:%-2v"
                end

                local pick = require("mini.pick")
                pick.setup({ source = { show = pick.default_show } })
                vim.keymap.set("n", "<leader>sf", "<CMD>Pick files<CR>", { desc = "[S]earch [F]iles" })
                vim.keymap.set("n", "<leader>sg", "<CMD>Pick grep_live<CR>", { desc = "[S]earch [G]rep" })
                vim.keymap.set("n", "<leader>sh", "<CMD>Pick help<CR>", { desc = "[S]earch [H]elp" })
                vim.keymap.set("n", "<leader>sr", "<CMD>Pick resume<CR>", { desc = "[S]earch [R]esume" })
            end,
        },

        {
            "stevearc/oil.nvim",
            ---@module 'oil'
            ---@type oil.SetupOpts
            opts = {
                columns = {
                    -- "icon",
                    "permissions",
                    "size",
                    "mtime",
                },

                delete_to_trash = true,

                --[[ This is here to show the default keymaps
                keymaps = {
                    ["g?"] = { "actions.show_help", mode = "n" },
                    ["<CR>"] = "actions.select",
                    ["<C-s>"] = { "actions.select", opts = { vertical = true } },
                    ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
                    ["<C-t>"] = { "actions.select", opts = { tab = true } },
                    ["<C-p>"] = "actions.preview",
                    ["<C-c>"] = { "actions.close", mode = "n" },
                    ["<C-l>"] = "actions.refresh",
                    ["-"] = { "actions.parent", mode = "n" },
                    ["_"] = { "actions.open_cwd", mode = "n" },
                    ["`"] = { "actions.cd", mode = "n" },
                    ["g~"] = { "actions.cd", opts = { scope = "tab" }, mode = "n" },
                    ["gs"] = { "actions.change_sort", mode = "n" },
                    ["gx"] = "actions.open_external",
                    ["g."] = { "actions.toggle_hidden", mode = "n" },
                    ["g\\"] = { "actions.toggle_trash", mode = "n" },
                },
                --]]
            },
            -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
            lazy = false,
        },
    },
    install = { colorscheme = { "lunaperche" } },
    ui = {
        icons = vim.g.have_nerd_font and {} or {
            cmd = "⌘",
            config = "🛠",
            event = "📅",
            ft = "📂",
            init = "⚙",
            keys = "🗝",
            plugin = "🔌",
            runtime = "💻",
            require = "🌙",
            source = "📄",
            start = "🚀",
            task = "📌",
            lazy = "💤 ",
        },
    },
})

