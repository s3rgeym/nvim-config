-- Используется в двух местах, но должен быть установлен единожды
return {
  "williamboman/mason.nvim",
  config = function()
    require("mason").setup()
  end,
}
