# tshjkl.nvim 🌳

Tree-sitter `hjkl` mode

![tshjkl](https://github.com/gsuuon/tshjkl.nvim/assets/6422188/608c95c1-0f83-4abc-89e5-cc114e877afb)

## Usage
Use the toggle key to switch to ts mode, then `hjkl` to scope in/out or move to the next/previous sibling. The toggle map is `<M-v>` (`Alt-v`) and nodes are selected by default. Toggle, movement keys, extmark highlights and select mode can be configured - check [init.lua](lua/tshjkl/init.lua) to see configuration and defaults. 

### Demo
https://github.com/gsuuon/tshjkl.nvim/assets/6422188/58944f74-efab-4db8-bf51-d659f35c5759

### Example
Unwrapping a function  
- toggle on the inner body
- `d`
- toggle the node to replace
- `p`  

https://github.com/gsuuon/tshjkl.nvim/assets/6422188/008843a0-a6be-43c7-999f-d68ce1278307


## Install

```lua
use 'gsuuon/tshjkl.nvim'
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


---
### TODO
- [ ] Can switch between highlight and select mode 
  - we can select from highlight mode but it would be nice to be able to toggle this
