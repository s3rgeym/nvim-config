local M = {}

function M.luminance(rgb)
  local r = bit.band(bit.rshift(rgb, 16), 0xff) / 255
  local g = bit.band(bit.rshift(rgb, 8), 0xff) / 255
  local b = bit.band(rgb, 0xff) / 255

  return 0.2126 * r + 0.7152 * g + 0.0722 * b
end

function M.get_contrast(fg, bg)
  local lighter = M.luminance(fg)
  local darker = M.luminance(bg)

  if lighter < darker then
    lighter, darker = darker, lighter
  end

  return (lighter + 0.05) / (darker + 0.05)
end

function M.pick_contrasting(bg, a, b)
  if M.get_contrast(a, bg) >= M.get_contrast(b, bg) then
    return a
  end

  return b
end

return M
