vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("i", "qq", "<ESC>", { desc = "Exit insert mode" })

keymap.set("n",  "<C-s>",  ":w<CR>", { desc = "Save current buffer" })

-- window
keymap.set("n", "<leader>wv", "<C-w>v",  { desc = "Split window vertically" })
keymap.set("n", "<leader>wh", "<C-w>s",  { desc = "Split window horizontally" })
keymap.set("n", "<leader>we", "<C-w>=",  { desc = "Make splits equal size" })
keymap.set("n", "<leader>wq", "<cmd>close<CR>", { desc = "Close current window" } )

-- tabs
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>",  { desc = "Open new tab" })
keymap.set("n", "<leader>tq", "<cmd>tabclose<CR>",  { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>",  { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>",  { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>",  { desc = "Open current buffer in new tab" })
