ardour {["type"] = "EditorAction",
  name        = "ensure region lock",
  license     = "GPLv3",
  author      = "Lukas Pirl",
  description = [[ensure selected regions are locked]]
}

function factory () return function ()
  for r in Editor:get_selection().regions:regionlist():iter() do
    r:set_locked(true)
  end
end end
