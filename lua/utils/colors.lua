local M = {}

-- Относительная яркость цвета 0xRRGGBB по WCAG.
function M.luminance(color)
  local function linearize(channel)
    channel = channel / 255

    if channel <= 0.04045 then
      return channel / 12.92
    end

    return ((channel + 0.055) / 1.055) ^ 2.4
  end

  local red = linearize(bit.rshift(color, 16) % 256)
  local green = linearize(bit.rshift(color, 8) % 256)
  local blue = linearize(color % 256)

  return 0.2126 * red + 0.7152 * green + 0.0722 * blue
end

-- Контрастность двух цветов по WCAG.
function M.contrast(color_a, color_b)
  local luminance_a = M.luminance(color_a)
  local luminance_b = M.luminance(color_b)

  local lighter = math.max(luminance_a, luminance_b)
  local darker = math.min(luminance_a, luminance_b)

  return (lighter + 0.05) / (darker + 0.05)
end

-- Из двух цветов выбирает тот, что контрастнее на заданном фоне.
function M.get_more_contrast(background, color_a, color_b)
  if M.contrast(color_a, background) >= M.contrast(color_b, background) then
    return color_a
  end

  return color_b
end

return M
