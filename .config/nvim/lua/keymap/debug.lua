local M = {}
local map = _G.Mappings.map
_G.debgger_mapping_active = false

function M.toggle_debug_mappings()
  if _G.debgger_mapping_active then
    _G.debgger_mapping_active = false
  else
    _G.debgger_mapping_active = true
  end
end

function M.start_debugger()
end


map({'n'}, '<F11>', function() require("keymap.debug").toggle_debug_mappings() end, { noremap = true },
  'Debugger: Toggle debug mappings')
map({'n'}, '<leader>db', function() require("keymap.debug").start_debugger() end, { noremap = true },
  'Debugger: Start')

if _G.debgger_mapping_active then
  -- map('n', '<localleader>R',  ':call vimspector#Restart()<CR>', { noremap = true }, 'Debugger: Restart debugger')
  -- map('n', '<localleader>r',  ':call vimspector#Reset()<CR>', { noremap = true }, 'Debugger: Reset debugger')
  -- map('n', '<localleader>sO', ':call vimspector#StepOut()<CR>', { noremap = true }, 'Debugger: Step out')
  -- map('n', '<localleader>so', ':call vimspector#StepOver()<CR>', { noremap = true }, 'Debugger: Step over')
  -- map('n', '<localleader>si', ':call vimspector#StepInto()<CR>', { noremap = true }, 'Debugger: Step into')
  -- map('n', '<localleader>C',  ':call vimspector#Continue()<CR>', { noremap = true }, 'Debugger: Continue execution')
  -- map('n', '<localleader>c',  ':call vimspector#RunToCursor()<CR>', { noremap = true }, 'Debugger: Run to cursor')
  -- map('n', '<localleader>B',  ':call vimspector#ToggleAdvancedBreakpoint()<CR>', { noremap = true }, 'Debugger: Toggle Advanced Breakpoint')
  -- map('n', '<localleader>b',  ':call vimspector#ToggleBreakpoint()<CR>', { noremap = true }, 'Debugger: Toggle Breakpoint')
else
  vim.cmd[[
    silent! unmap <localleader>r
    silent! unmap <localleader>R
    silent! unmap <localleader>so
    silent! unmap <localleader>sO
    silent! unmap <localleader>si
    silent! unmap <localleader>C
    silent! unmap <localleader>c
    silent! unmap <localleader>B
    silent! unmap <localleader>b
    ]]
end

return M
