-- colorscheme
vim.cmd.colorscheme("catppuccin")

-------------------------------------- options ------------------------------------------
-- statusline
vim.o.laststatus = 3
vim.o.showmode = false

vim.o.clipboard = ""
vim.o.cursorline = true
vim.o.cursorlineopt = "number"

-- indenting
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.tabstop = 2
vim.o.softtabstop = 2

vim.opt.fillchars = { eob = " " }
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.mouse = "a"

-- numbers
vim.o.number = true
vim.o.numberwidth = 4
vim.o.ruler = false

-- showcase
vim.opt.shortmess:append("sI")

vim.o.signcolumn = "yes"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.timeoutlen = 400
vim.o.undofile = true

vim.o.guicursor = "n-v-sm:block,i-c-ci-ve:ver25,r-cr-o:hor20"
vim.o.showcmd = false

-- interval for writing swap file to disk, also used by gitsigns
vim.o.updatetime = 250

-- go to previous/next line with h,l,left arrow and right arrow
-- when cursor reaches end/beginning of line
vim.opt.whichwrap:append("<>[]hl")

-- disable some default providers
vim.g["loaded_node_provider"] = 0
vim.g["loaded_python3_provider"] = 0
vim.g["loaded_perl_provider"] = 0
vim.g["loaded_ruby_provider"] = 0

-- add binaries installed by mason.nvim to path
local is_windows = vim.fn.has("win32") ~= 0
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin" .. (is_windows and ";" or ":") .. vim.env.PATH

-- temp file and back file
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false
vim.o.wrap = false
