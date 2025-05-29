# tshjkl.nvim 🌳

Tree-sitter `hjkl` mode

![image](https://github.com/gsuuon/tshjkl.nvim/assets/6422188/e1942195-dd08-44e8-9db3-2209a4ea4943)

## Usage
Toggle into `tshjkl` mode, then use `hjkl` to change scope or select a sibling node. Toggle is mapped to `<M-v>` (`Alt-v`) and nodes are visually selected by default. Toggle, movement keys, extmark highlights and select mode can be configured - check [init.lua](lua/tshjkl/init.lua) to see configuration and defaults.

### Demo
https://github.com/gsuuon/tshjkl.nvim/assets/6422188/58944f74-efab-4db8-bf51-d659f35c5759

You can use `v` again with tshjkl toggled on to enter something like a nodewise-visual mode which works like charwise-visual.

https://github.com/gsuuon/tshjkl.nvim/assets/6422188/dcfd7cd0-9a40-4105-85d3-aa2b82808022


### Example
Unwrapping a function  
- toggle with cursor over the inner body
- change scope if you need to
- `d`
- toggle the node to replace
- `p`  

https://github.com/gsuuon/tshjkl.nvim/assets/6422188/008843a0-a6be-43c7-999f-d68ce1278307


## Install

lazy.nvim:
```lua
{
  'gsuuon/tshjkl.nvim',
  config = true
}
```

packer.nvim:
```lua
use {
  'gsuuon/tshjkl.nvim',
  config = function()
    require('tshjkl').setup()
  end
}
```

### Configure
You can override the [default config](lua/tshjkl/init.lua) with lazy `opts`:
```lua
{
  'gsuuon/tshjkl.nvim',
  opts = {
    -- false to highlight only. Note that enabling this will hide the highlighting of child nodes
    select_current_node = true,
    keymaps = {
      toggle = '<leader>ct',
    },
    marks = {
      parent = {
        virt_text = { {'h', 'ModeMsg'} },
        virt_text_pos = 'overlay'
      },
      child = {
        virt_text = { {'l', 'ModeMsg'} },
        virt_text_pos = 'overlay'
      },
      prev = {
        virt_text = { {'k', 'ModeMsg'} },
        virt_text_pos = 'overlay'
      },
      next = {
        virt_text = { {'j', 'ModeMsg'} },
        virt_text_pos = 'overlay'
      }
    },
    binds = function(bind, tshjkl)
      bind('<Esc>', function()
        tshjkl.exit(true)
      end)

      bind('q', function()
        tshjkl.exit(true)
      end)

      bind('t', function()
        print(tshjkl.current_node():type())
      end)
    end,
  }
}
```

Or packer in `require('tshjkl').setup({})`:

```lua
use {
  'gsuuon/tshjkl.nvim',
  config = function()
    require('tshjkl').setup({
      keymaps = {
        toggle = '<leader>N',
      }
    })
  end
}
```

The default options will visual select the current node - since the visual highlight will render over other highlights, you won't see the child extmarks. If you prefer to see those, set `select_current_node = false` and use the `v` keybind in ts-mode to manually select the current node instead.

## Keymaps
These keymaps are added when `tshjkl` is toggled on. Check [binds](./lua/tshjkl/init.lua#L437) for more.

`v` — enter node-wise visual mode if `select_current_node` is true, else visual select the current node  
`b` — visual select backwards  

`h` — parent  
`j` — next sibling  
`k` — previous sibling  
`l` — child  

`H` — top-most parent  
`J` — last sibling  
`K` — first sibling  
`L` — inner-most child  

### Binds
You can bind additional keys for 'tshjkl' mode with the `binds` option. This takes a function which takes `bind` and `tshjkl` - bind lets you bind additional keys, and tshjkl exposes `tshjkl.current_node()`, `tshjkl.set_node()`, `tshjkl.parent(node)` and `tshjkl.exit()`. Pass `true` to `tshjkl.exit` to drop to normal mode (if `select_current_node` is true).

You can also add binds per buffer by setting `vim.b.tshjkl_binds`, for example in `ftplugin/lua.lua`:
```lua
vim.b.tshjkl_binds = function(bind, tshjkl)
  bind('m', function() -- content of markdown code block
    local node = tshjkl.current_node()

    while node do
      local type = node:type()

      if type == 'code_fence_content' then
        tshjkl.set_node(node)
        return
      end

      node = tshjkl.parent(node)
    end
  end)
end
```

## Motivation
This plugin makes it easier to work with tree-sitter nodes - I've found it often surprising which node is under the cursor so I want to make navigating nodes as easy as basic navigation in Neovim. Visual select by default lets you do normal operations without too much extra thought - this just helps you easily select the node you're interested in.
