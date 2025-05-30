local M = {}

---@enum Op
local op = {
  first = 'f',
  last = 'l',
  next = 'n',
  prev = 'p',
}

M.op = op

---@alias OpTable table<Op, fun(node: TSNode): TSNode | nil>

---@type OpTable
local named_sib_ops = {
  [op.first] = function(node)
    local parent = node:parent()
    if parent == nil then
      return
    end

    return parent:named_child(0)
  end,

  [op.last] = function(node)
    local parent = node:parent()
    if parent == nil then
      return
    end

    return parent:named_child(parent:named_child_count() - 1)
  end,

  [op.next] = function(node)
    return node:next_named_sibling()
  end,

  [op.prev] = function(node)
    return node:prev_named_sibling()
  end,
}

---@type OpTable
local unnamed_sib_ops = {
  [op.first] = function(node)
    local parent = node:parent()
    if parent == nil then
      return
    end

    return parent:child(0)
  end,

  [op.last] = function(node)
    local parent = node:parent()
    if parent == nil then
      return
    end

    return parent:child(parent:child_count() - 1)
  end,

  [op.next] = function(node)
    return node:next_sibling()
  end,

  [op.prev] = function(node)
    return node:prev_sibling()
  end,
}

local named = true

---@param named_ boolean
---@return nil
function M.set_named_mode(named_)
  named = named_
end

function M.is_named_mode()
  return named
end

---@param node TSNode
---@param op_ Op
function M.sibling(node, op_)
  if named then
    return named_sib_ops[op_](node)
  else
    return unnamed_sib_ops[op_](node)
  end
end

local function child_same_tree(node)
  if named then
    return node:named_child(0)
  else
    return node:child(0)
  end
end

---@param node TSNode
function M.child(node)
  local tree_child = child_same_tree(node)

  if tree_child then
    return tree_child
  end

  -- try to get an injected node
  local injected = vim.treesitter.get_node({ ignore_injections = false })

  if injected and injected:tree() ~= node:tree() then
    return injected
  end
end

local function parent_same_tree(node)
  if named then
    local parent_ = node:parent()
    while parent_ and not parent_:named() do
      parent_ = node:parent()
    end
    return parent_
  else
    return node:parent()
  end
end

---@param node TSNode
function M.parent(node)
  local tree_parent = parent_same_tree(node)

  if tree_parent then
    return tree_parent
  end

  -- try to get smallest node in top-level tree instead
  local top_level = vim.treesitter.get_node()
  if top_level and top_level:tree() ~= node:tree() then
    return top_level
  end
end

return M
