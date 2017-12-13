-- This file is part of Storage Energistics
-- Author: Nividica
-- Created: 2017-12-12
-- Description: Defines custom input keys

require "SEConstants"

-- 'consuming'
-- available options:
-- none: default if not defined
-- game-only: Blocks game inputs using the same key sequence but lets other custom inputs using the same key sequence fire.

data:extend {
  {
    type = "custom-input",
    name = SEConstants.Names.Controls.StorageNetworkGui,
    key_sequence = "N",
    consuming = "none"
  }
}
