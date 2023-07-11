# tshjkl.nvim 🌳

Toggleable tree-sitter mode

![tshjkl](https://github.com/gsuuon/tshjkl.nvim/assets/6422188/608c95c1-0f83-4abc-89e5-cc114e877afb)

## Usage
Use the toggle key to switch to TSMode, then hjkl to scope in/out or move to the next/previous sibling. Default toggle key is `<M-t>`. Check [init.lua](lua/tshjkl/init.lua) to see configuration and defaults.

### Demo
https://github.com/gsuuon/tshjkl.nvim/assets/6422188/58944f74-efab-4db8-bf51-d659f35c5759

### Example
Unwrapping a function:  
- toggle on the inner body
- `d`
- toggle the node to replace
- `p`  
https://github.com/gsuuon/tshjkl.nvim/assets/6422188/008843a0-a6be-43c7-999f-d68ce1278307

## Install

```lua
use `gsuuon/tshjkl.nvim`
```
