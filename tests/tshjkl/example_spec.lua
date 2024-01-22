local plugin = require('tshjkl')
local assert = require('luassert')

describe('setup with no custom options', function()
  it('example spec', function()
    -- TODO remove this example spec and add actual tests later
    plugin.setup({})
    assert.equals(plugin.did_setup, true)
  end)
end)
