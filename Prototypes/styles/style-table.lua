-- Description: GUI styles Table


local default_gui = data.raw["gui-style"].default




-------------------------------------------------------------------------------
-- Style of default
--
-- @field [parent=#Frame] default
default_gui[Constants.Names.Styles.Tables.SETableDefault] = {
  type = "table_style",
}

default_gui[Constants.Names.Styles.Tables.SETableNetworkOverviewHeader] = {
    type = "table_style",
    minimal_width = Constants.Variables.NetworkOverview.Table.Width,
    bottom_padding = 10,
    column_alignments = {
      { -- label
        column = 1,
        alignment = "top-right"
      }
    }
    
  }

  default_gui[Constants.Names.Styles.Tables.SETableNetworkOverviewFooter] = {
    type = "table_style",
    minimal_width = Constants.Variables.NetworkOverview.Table.Width,
    bottom_padding = 10,
    column_alignments =  {
      { -- label
        column = 1,
        alignment = "middle-right"
      }
    }
    
  }
