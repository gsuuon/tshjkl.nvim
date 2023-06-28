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
    if parent == nil then return end

    return parent:named_child(0)
  end,
  [op.last] = function(node)
    local parent = node:parent()
    if parent == nil then return end

    return parent:named_child(parent:named_child_count() - 1)
  end,
  [op.next] = function(node)
    return node:next_named_sibling()
  end,
  [op.prev] = function(node)
    return node:prev_named_sibling()
  end
}

---@type OpTable
local unnamed_sib_ops = {
  [op.first] = function (node)
    local parent = node:parent()
    if parent == nil then return end

    return parent:child(0)
  end,
  [op.last] = function(node)
    local parent = node:parent()
    if parent == nil then return end

    return parent:child(parent:child_count() - 1)
  end,
  [op.next] = function(node)
    return node:next_sibling()
  end,
  [op.prev] = function(node)
    return node:prev_sibling()
  end
}

local named = false
function M.set_named() named = true end
function M.set_all() named = false end

function M.sibling(node, op_)
  if named then
    return named_sib_ops[op_](node)
  else
    return unnamed_sib_ops[op_](node)
  end
end

function M.child(node)
  if named then
    return node:named_child(0)
  else
    return node:child(0)
  end
end

function M.parent(node)
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

return M

