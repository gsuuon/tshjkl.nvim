local M = {}

---@class Node
---@field node TSNode
---@field parent? Node
---@field child? Node

function M.start()
  local node = vim.treesitter.get_node()
  if node == nil then return end

  ---@type Node
  local current = { node = node }

  local function from_child_to_parent()
    local parent = current.node:parent()
    if parent == nil then return end

    if current.parent == nil or current.parent.node ~= node then
      current.parent = {
        node = parent,
        child = current
      }
    end

    current = current.parent
    return current.node
  end

  local function from_parent_to_child()
    if current.child == nil then
      local child = current.node:child(0)

      if child == nil then return end

      current.child = {
        node = child,
        parent = current
      }
    end

    current = current.child
    return current.node
  end

  local function from_sib_to_sib(next)
    local sibling
    if next then
      sibling = current.node:next_sibling()
    else
      sibling = current.node:prev_sibling()
    end
    if sibling == nil then return end

    current = {
      node = sibling
    }

    return current.node
  end

  local function move_outermost()
    local parent = current.node:parent()

    while parent ~= nil do
      from_child_to_parent()
      parent = current.node:parent()
    end

    -- Real outermost node is the whole file so go in one child
    return from_parent_to_child()
  end

  local function move_innermost()
    while current.child ~= nil do
      current = current.child
    end

    return current.node
  end

  return {
    from_child_to_parent = from_child_to_parent,
    from_parent_to_child = from_parent_to_child,
    from_sib_to_sib = from_sib_to_sib,
    current = function() return current.node end,
    move_innermost = move_innermost,
    move_outermost = move_outermost
  }
end

return M
