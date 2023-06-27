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

  return {
    from_child_to_parent = from_child_to_parent,
    from_parent_to_child = from_parent_to_child,
    from_sib_to_sib = from_sib_to_sib,
    current = function() return current.node end
  }
end

return M
