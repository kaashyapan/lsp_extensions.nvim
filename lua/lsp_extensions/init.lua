
--[[

Note to self:

Each extension should probably look like:

- request(opts)
  -> opts gets passed to get_callback, runs the request in your buffer.

- get_callback(opts)
  -> opts configures how you would want this extension to run.

- get_params(opts)
  -> get the params you need to make the request

--]]

local vim = vim
local extensions = {}
local inlay_hints = require('lsp_extensions.inlay_hints')
local fs_inlay_hints = require('lsp_extensions.fs_inlay_hints')

extensions.inlay_hints = function(opts)
  fs_inlay_hints.get_callback(opts)
end

return extensions
