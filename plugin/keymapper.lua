local M = {};

local present, whichkey = pcall(require, "which-key")

M.register = function (bindings, options)
  if not present then
    return
  end
  whichkey.register(bindings, options);
end

return M;
