-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-12-14
-- Description:

local Thousand = 1000
local Million = Thousand * Thousand
local Billion = Thousand * Million
local Trillion = Thousand * Billion
local Quadrillion = Thousand * Trillion

function NumberToHumanString(num)
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
