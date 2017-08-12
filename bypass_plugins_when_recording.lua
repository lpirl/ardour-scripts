ardour {
  ["type"]    = "EditorHook",
  name        = "disable plugins when recording",
  license     = "GPLv3",
  author      = "Lukas Pirl",
  description = [[Disables all plugins when record-enabling the session,
                  enables all (!) plugins when record-disabling.]]
}

function signals ()
  s = LuaSignal.Set()
  s:add (
    {
      [LuaSignal.RecordStateChanged] = true,
    }
  )
  return s
end

function factory (params)
  return function (signal, ref, ...)
    local recording = Session:record_status() ~=
                      ARDOUR.Session.RecordState.Disabled
    for route in Session:get_routes ():iter () do
      local proc_i = 0;
      while true do
        local proc = route:nth_plugin (proc_i)
        if proc:isnil () then
          break
        end
        if recording then
          proc:to_insert():deactivate()
        else
          proc:to_insert():activate()
        end
        proc_i = proc_i + 1
      end
    end
  end
end
