
local util = require('lsp_extensions.util')

local inlay_hints = {}

local inlay_hints_ns = vim.api.nvim_create_namespace("lsp_extensions.inlay_hints")

inlay_hints.request = function(opts, bufnr)
 
  -- TODO: At some point, rust probably adds this?
  -- vim.lsp.buf_request(bufnr or 0, 'experimental/inlayHints', inlay_hints.get_params(), inlay_hints.get_callback(opts))
end

inlay_hints.get_callback = function(opts)
  opts = opts or {}

  local hint_store = {}

  local longest_line = -1

  for _, hint in ipairs({'hit'}) do
    local finish = hint.range["end"].line
    if not hint_store[finish] and in_list(enabled)(hint.kind) then
      hint_store[finish] = hint

      if aligned then
        longest_line = math.max(longest_line,
                                #vim.api.nvim_buf_get_lines(0, finish, finish + 1, false)[1])
      end
    end
  end


    local display_virt_text = function(hint)
      local end_line = hint.range["end"].line

      -- Check for any existing / more important virtual text on the line.
      -- TODO: Figure out how stackable virtual text works? What happens if there is more than one??
      local text
      if aligned then
        local line_length = #vim.api.nvim_buf_get_lines(0, end_line, end_line + 1, false)[1]
        text = string.format("%s %s", (" "):rep(longest_line - line_length), prefix .. hint.label)
      else
        text = prefix .. hint.label
      end
      vim.api.nvim_buf_set_virtual_text(0, inlay_hints_ns, end_line, {{text, highlight}}, {})
    end

    for _, hint in pairs(hint_store) do display_virt_text(hint) end
    
      
end

inlay_hints.get_params = function()
  return {textDocument = vim.lsp.util.make_text_document_params()}
end

inlay_hints.clear = function()
  vim.api.nvim_buf_clear_namespace(0, inlay_hints_ns, 0, -1)
end

return inlay_hints
