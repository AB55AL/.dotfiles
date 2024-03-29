local map = _G.Mappings.map
-- Telescope
map({'n'}, '<leader>ff', ':Telescope find_files<CR>', { noremap = true },
'Telescope: find files')
map({'n'}, '<leader>fg', ':Telescope live_grep<CR>' , { noremap = true },
  'Telescope: grep cwd')
map({'n'}, '<leader>fb', ':Telescope buffers<CR>'   , { noremap = true },
  'Telescope: Show buffers')
map({'n'}, '<leader>fh', ':Telescope help_tags<CR>' , { noremap = true },
  'Telescope: Show help tage')

-- easy motion

-- Global mapping
map({'n'}, '<leader>;', '<Plug>(easymotion-next)', {},
  'EasyMotion: Next char')
map({'n'}, '<leader>,', '<Plug>(easymotion-prev)', {},
  'EasyMotion: Prev char')

-- Multi line
map({'n'}, 's', '<Plug>(easymotion-bd-f)' , {},
  'EasyMotion: Find char')
map({'n'}, '<leader>t', '<Plug>(easymotion-bd-t)' , {},
  'EasyMotion: Till char')
map({'n'}, '<leader>b', '<Plug>(easymotion-bd-t2)', {},
  'EasyMotion: Till 2-chars')
-- map({'n'}, 's',         '<Plug>(easymotion-s2)'   , {},
--   'EasyMotion: Till 2-chars')

-- Multi line Overwindows
map({'n'}, '<leader>wl', '<Plug>(easymotion-overwin-line)', {},
  'EasyMotion: Find char over-window')

-- surround.vim
map({'n'}, 'S', '<Plug>Ysurround', {},
  'Surround')
-- fugitive
map({'n'}, '<F1>', ':tab Git<CR>', { noremap = true, silent = true  },
  'Fugitive: Open in tab')
-- vim-maximizer
map({'n'}, '<C-w><CR>', ':MaximizerToggle<CR>', { noremap = true },
  'Maximizer: Toggle')
-- vim-easy-align
map({'v'}, 'ga', ':EasyAlign<CR>', {},
  'EasyAlign')
-- Nvim-tree
map({'n'}, '<leader>fo', ':NvimTreeToggle<CR>', { noremap = true },
  'NvimTree: Toggle')
-- SymbolsOutline
map({'n'}, '<leader>ol', ':SymbolsOutline<CR>', { noremap = true },
  'SymbolsOutline: Toggle')
-- Gitsings
map({'n'}, '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>', { noremap = true },
  'Gitsigns: Preview hunk')
map({'n'}, '<leader>n', '<cmd>Gitsigns next_hunk<CR>', { noremap = true },
  'Gitsigns: Go to next hunk')
map({'n'}, '<leader>p', '<cmd>Gitsigns next_hunk<CR>', { noremap = true },
  'Gitsigns: Go to previous hunk')
-- LuaSnip
map({'i','s'}, '<C-l>', function() require('luasnip').jumpable(1) end, {},
  'LuaSnip: Jump forward')
map({'i','s'}, '<C-h>', function() require('luasnip').jumpable(-1) end, {},
'LuaSnip: Jump backword')
map({'i', 's'}, "<C-k>", function ()
  if require('luasnip').expand_or_jumpable() then
    require('luasnip').expand_or_jump()
  end
end, {silent = true}, 'LuaSnip: jump or expand')

--  Harpoon
map({'n'}, '<leader>gg', require("harpoon.ui").toggle_quick_menu, {} ,
  'Harpoon: Open window')
map({'n'}, '<leader>ga', require("harpoon.mark").add_file, {},
  'Harpoon: Add file')
map({'n'}, '<leader>gn', function() require("harpoon.ui").nav_file(1) end, {},
  'Harpoon: Navigate to mark 1')
map({'n'}, '<leader>ge', function() require("harpoon.ui").nav_file(2) end, {},
  'Harpoon: Navigate to mark 2')
map({'n'}, '<leader>gi', function() require("harpoon.ui").nav_file(3) end, {},
  'Harpoon: Navigate to mark 3')

-- mini-map
map({'n'}, '<leader>mm',
  function()
    vim.cmd[[
  MinimapToggle
  MinimapRefresh
  ]]
  end,
  { noremap = true, silent = true },
  'Toggle minimap')
