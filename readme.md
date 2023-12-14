# tshjkl.nvim 🌳

Tree-sitter `hjkl` mode

![image](https://github.com/gsuuon/tshjkl.nvim/assets/6422188/e1942195-dd08-44e8-9db3-2209a4ea4943)

## Usage
Toggle into `tshjkl` mode, then use `hjkl` to change scope or select a sibling node. Toggle is mapped to `<M-v>` (`Alt-v`) and nodes are visually selected by default. Toggle, movement keys, extmark highlights and select mode can be configured - check [init.lua](lua/tshjkl/init.lua) to see configuration and defaults. 

### Demo
https://github.com/gsuuon/tshjkl.nvim/assets/6422188/58944f74-efab-4db8-bf51-d659f35c5759

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
    }
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

## Keymaps
Check [binds](https://github.com/gsuuon/tshjkl.nvim/blob/9c608e4a70c69a4ab0e01f22a2f507106491c4af/lua/tshjkl/init.lua#L326) for more

`v` — visual select the current node (if `config.select_current_node` is false)  
`b` — visual select backwards  

`h` — parent  
`j` — next sibling  
`k` — previous sibling  
`l` — child  

`H` — top-most parent  
`J` — last sibling  
`K` — first sibling  
`L` — inner-most child  


## Motivation
This plugin makes it easier to work with tree-sitter nodes - I've found it often surprising which node is under the cursor so I want to make navigating nodes as easy as basic navigation in Neovim. Visual select by default lets you do normal operations without too much extra thought - this just helps you easily select the node you're interested in.
