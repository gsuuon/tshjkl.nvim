local trail = require('tshjkl.trail')

local M = {}

M.ns = vim.api.nvim_create_namespace('tshjkl')

M.hl = {}

local function select_position(pos)
  local keys = pos.start.row + 1 .. 'G0'

  if pos.start.col > 0 then
    keys = keys .. pos.start.col .. 'l'
  end

  keys = keys .. 'v' .. pos.stop.row + 1 .. 'G0'

  if pos.stop.col > 0 then
    keys = keys .. pos.stop.col .. 'l'
  end

  vim.fn.feedkeys(keys, 'n')
end

local function clear_positions()
  for name in pairs(M.hl) do
    vim.api.nvim_buf_del_extmark(0, M.ns, M.hl[name])
  end
end

local function show_position(pos, hl, name)
  if M.hl[name] ~= nil then
    vim.api.nvim_buf_del_extmark(0, M.ns, M.hl[name])
  end

  M.hl[name] = vim.api.nvim_buf_set_extmark(
    0,
    M.ns,
    pos.start.row,
    pos.start.col,
    {
      end_row = pos.stop.row,
      end_col = pos.stop.col,
      hl_group = hl
    }
  )
end

local function node_position(node)
  local start_row, start_col, stop_row, stop_col = node:range()

  return {
    start = {
      row = start_row,
      col = start_col,
    },
    stop = {
      row = stop_row,
      col = stop_col
    }
  }
end

local function show_node(node, hl, name)
  if node == nil then return end

  show_position(
    node_position(node),
    hl or 'SpecialComment',
    name or 'current'
  )
end

local function set_current_node(node)
  if node == nil then return end

  vim.wo.winbar = 'TSMode ∙ ' .. node:type()

  clear_positions()
  local pos = node_position(node)
  vim.api.nvim_win_set_cursor(0, { pos.start.row + 1, pos.start.col })

  show_node(node:parent(), 'Comment', 'parent')
  show_node(node:next_sibling(), 'WarningFloat', 'next')
  show_node(node:prev_sibling(), 'InfoFloat', 'prev')
  show_node(node, 'Substitute', 'current')
  show_node(node:child(0), 'Error', 'child')
end

M.keys = {}

local function unkeybind()
  for _, lhs in ipairs(M.keys) do
    vim.keymap.del('n', lhs, {buffer = true})
  end
end

local function keybind(t)
  M.keys = {}

  local function bind(key, fn)
    local lhs = key
    table.insert(M.keys, lhs)

    vim.keymap.set('n', lhs, fn, {
      buffer = true
    })
  end

  local function next_node()
    set_current_node(t.from_sib_to_sib(true))
  end

  local function prev_node()
    set_current_node(t.from_sib_to_sib(false))
  end

  local function parent_node()
    set_current_node(t.from_child_to_parent())
  end

  local function child_node()
    set_current_node(t.from_parent_to_child())
  end

  local function visual_select()
    select_position(node_position(t.current()))
  end

  local function append()
    local pos = node_position(t.current())
    vim.api.nvim_win_set_cursor(0, { pos.stop.row + 1, pos.stop.col } )

    local len = #vim.api.nvim_get_current_line()

    -- Insert at the end if we're at the end of the col
    if len == pos.stop.col then
      vim.fn.feedkeys('a', 'n')
    else
      vim.cmd.startinsert()
    end
  end

  local function prepend()
    local pos = node_position(t.current())
    vim.api.nvim_win_set_cursor(0, { pos.start.row + 1, pos.start.col } )
    vim.cmd.startinsert()
  end

  bind('j', next_node)
  bind('k', prev_node)
  bind('h', parent_node)
  bind('l', child_node)
  bind('v', visual_select)
  bind('a', append)
  bind('A', prepend)
end

local function enter()
  local t = trail.start()
  set_current_node(t.current())
  keybind(t)
end

local function exit()
  clear_positions()
  unkeybind()
  vim.wo.winbar = nil
end

M.did_init = false

function M.init(opts, init_by_plugin)
  if M.did_init and init_by_plugin then return end

  opts = opts or {}

  local on = false
  local function toggle()
    if on then
      exit()
    else
      enter()
    end

    on = not on
  end

  vim.keymap.set('n', opts.toggle_key or '<M-t>', toggle)

  M.did_init = true
end

M.init()

return M

