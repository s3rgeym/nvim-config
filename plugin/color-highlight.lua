-- Native color highlighting for Neovim 0.10+ (no plugins).
-- Supports: #rrggbb, #rrggbbaa, 0xrrggbb, rgb(r, g, b), rgba(r, g, b, a).
-- Alpha is ignored; colors are always displayed as opaque.
-- Highlighting stops for new colors when the cache limit is reached.
--
-- Unlike similar plugins, named colors such as red and skyblue are not
-- highlighted, since their names already make the color obvious.

local ns = vim.api.nvim_create_namespace('color_highlight')
local cache = {}
local MAX_CACHE = 4096

-- Create a highlight group for a color, reusing cached groups when possible.
local function hl_group(hex)
  if cache[hex] then
    return cache[hex]
  end

  if vim.tbl_count(cache) >= MAX_CACHE then
    return nil
  end

  local r = tonumber(hex:sub(1, 2), 16)
  local g = tonumber(hex:sub(3, 4), 16)
  local b = tonumber(hex:sub(5, 6), 16)

  -- Choose black or white text based on the background brightness.
  local fg = (0.299 * r + 0.587 * g + 0.114 * b) > 140 and '#000000'
    or '#ffffff'

  local name = 'ColorHighlight_' .. hex

  vim.api.nvim_set_hl(0, name, {
    bg = '#' .. hex,
    fg = fg,
  })

  cache[hex] = name

  return name
end

-- Highlight a color literal using its one-based start and end columns.
local function mark(buf, row, s, e, hex)
  local group = hl_group(hex:upper())

  if not group then
    return
  end

  vim.api.nvim_buf_set_extmark(buf, ns, row, s - 1, {
    end_col = e - 1,
    hl_group = group,
    ephemeral = true,
  })
end

-- Clamp a numeric color component to the valid RGB range.
local function clamp(n)
  return math.max(0, math.min(255, n))
end

-- Convert RGB components to hexadecimal and highlight the color literal.
local function mark_rgb(buf, row, s, e, r, g, b)
  r, g, b = tonumber(r), tonumber(g), tonumber(b)

  if not (r and g and b) then
    return
  end

  local hex = string.format('%02X%02X%02X', clamp(r), clamp(g), clamp(b))

  mark(buf, row, s, e, hex)
end

local NUM = '%s*(%d+)%s*'
local ALPHA = '%s*%d*%.?%d+%s*'

vim.api.nvim_set_decoration_provider(ns, {
  -- Skip special buffers.
  on_win = function(_, _, buf)
    return vim.bo[buf].buftype == ''
  end,

  on_line = function(_, _, buf, row)
    local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]

    if not line then
      return
    end

    -- #rrggbb
    for s, hex, e in line:gmatch('()#(%x%x%x%x%x%x)%f[%W]()') do
      mark(buf, row, s, e, hex)
    end

    -- #rrggbbaa (alpha ignored)
    for s, hex, e in line:gmatch('()#(%x%x%x%x%x%x)%x%x%f[%W]()') do
      mark(buf, row, s, e, hex)
    end

    -- 0xrrggbb
    for s, hex, e in line:gmatch('()%f[%w]0[xX](%x%x%x%x%x%x)%f[%W]()') do
      mark(buf, row, s, e, hex)
    end

    -- rgb(r, g, b)
    for s, r, g, b, e in
      line:gmatch(
        '()%f[%w][rR][gG][bB]%(' .. NUM .. ',' .. NUM .. ',' .. NUM .. '%)()'
      )
    do
      mark_rgb(buf, row, s, e, r, g, b)
    end

    -- rgba(r, g, b, a) (alpha ignored)
    for s, r, g, b, e in
      line:gmatch(
        '()%f[%w][rR][gG][bB][aA]%('
          .. NUM
          .. ','
          .. NUM
          .. ','
          .. NUM
          .. ','
          .. ALPHA
          .. '%)()'
      )
    do
      mark_rgb(buf, row, s, e, r, g, b)
    end
  end,
})

-- ColorScheme changes clear highlight groups, so invalidate the cache.
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    cache = {}
  end,
})
