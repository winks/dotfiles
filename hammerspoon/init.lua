local lib = require('lib')

------------------------
-- configure bindings
------------------------

local mod1 = {"cmd"}
local mod2 = {"cmd", "shift"}

local windowFocusKeysMod1 = {
  {"F1", "Terminal"},
  {"F2", "IntelliJ IDEA"},
  {"F3", "Firefox"},
  {"F4", "Slack"},
  {"F5", "Microsoft Outlook"},
  {"F6", "Safari"},
  --{"F7", ""},
  {"F8", "Cog"},
  {"F9",  "Google Chrome"},
  {"F10", "WezTerm"},   
  --{"F11", ""},
}

local miscBinds = {
  HotkeyBinds = {
    ShowNotes = {mod1, "F12"}
  },
  SpecialBinds = {
    MoveWindows = {mod2, "m"},
  }
}

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
    hs.alert.show("Hello World!")
end)

------------------
-- use bindings
------------------

-- these are the callable functions for HotkeyBinds

miscBinds["Callable"] = {
  ShowNotes = function()
    lib.RunWithArgs("/Applications/Textadept.app/Contents/MacOS/textadept", {"../Documents/notes.md"})
  end
}

-- the HotkeyBinds are called with a normal hs.hotkey.bind()

for fnName, shortcut in pairs(miscBinds["HotkeyBinds"]) do
  hs.hotkey.bind(shortcut[1], shortcut[2], miscBinds["Callable"][fnName])
end

-- windowFocusKeysMod1

for i, shortcut in ipairs(windowFocusKeysMod1) do
  hs.hotkey.bind(mod1, shortcut[1], function()
    hs.application.launchOrFocus(shortcut[2])
  end)
end

-- finally the SpecialBinds

hs.loadSpoon('MoveWindows')
  :start()
  :bindHotKeys({toggle = miscBinds["SpecialBinds"]["MoveWindows"]})
