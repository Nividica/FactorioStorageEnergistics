-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-12-14
-- Description:

local Thousand = 1000
local Million = Thousand * Thousand
local Billion = Thousand * Million
local Trillion = Thousand * Billion
local Quadrillion = Thousand * Trillion

-- Returns a number with a unit suffix
-- Will show one non-zero decimal. Does not round.
-- 1000 = 1k
-- 1000000 = 1m
-- 1200 = 1.2k
-- 1299 = 1.2k
function NumberToStringWithSuffix(num)
  -- No suffix
  if (num < Thousand) then
    return tostring(num)
  end

  local suffix = ""
  if (num < Million) then
    num = num / Thousand
    suffix = "k"
  elseif (num < Billion) then
    num = num / Million
    suffix = "m"
  elseif (num < Trillion) then
    num = num / Billion
    suffix = "b"
  elseif (num < Quadrillion) then
    num = num / Trillion
    suffix = "t"
  else
    num = num / Quadrillion
    suffix = "q"
  end

  -- Show 1 decimal place up to 10
  if (num > 9) then
    num = math.floor(num)
  else
    num = math.floor(num * 10) / 10
  end

  return tostring(num) .. suffix
end

-- Returns a number with comma separated thousands
-- Modified from http://lua-users.org/wiki/FormattingNumbers , 2017-12-17
function NumberToStringWithThousands(num)
  local formatted = tostring(num)
  while true do
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
    if (k == 0) then
      break
    end
  end
  return formatted
end
