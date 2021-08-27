
local NetworkOverviewWidth = 600
local NetworkOverviewHeight = 450

local Variables = {}
Variables.NetworkOverview = {
    Progressbar = {
        Width = NetworkOverviewWidth,
        Color = {r=0.98, g=0.66, b=0.22, a=0.7},
        MiniHeight = 2,
        MaxiHeight = 2
    },
    Table = {
        Width = NetworkOverviewWidth,
    },
    Scroll = {
        Width = NetworkOverviewWidth,
        Height = NetworkOverviewHeight,
    },
    Flow = {
        ItemCell = {
            Width = 275
        }
    }
}


return Variables