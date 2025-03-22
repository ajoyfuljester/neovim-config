vim.g.user_emmet_leader_key = '<c-s>'
vim.g.user_emmet_expandabbr_key = '<c-s>'
vim.g.user_emmet_install_global = 0
vim.cmd('autocmd FileType html,css EmmetInstall')
vim.cmd.colorscheme("vibrantcircus")

require("ajoyfuljester.remap")
require("ajoyfuljester.lazy")
require("ajoyfuljester.set")

