local module = {}

module.runWithArgs = function(executable, args)
    local t = hs.task.new(executable, 
    nil,
    function() return false end,
    args)
    t:start()
end

module.trim = function(s)
  return string.gsub(s, "^%s*(.-)%s*$", "%1")
end

module.runPy = function(cmd)
  local cmd = "python3 -c \"" .. cmd .. "\""
  local output, ok, _, rc = hs.execute(cmd)
  return output or ""
end

module.pyUrlEncode = function(s)
  cmd = "import urllib.parse as p; print(p.quote_plus('" .. s .. "'))"
  return module.runPy(cmd)
end

module.getFromWeb = function(url, ipMode)
  local cmd = "/usr/bin/curl -" .. (ipMode or "4") .. " -s " .. url
  local output, ok, _, rc = hs.execute(cmd)

  if not ok or rc ~= 0 then
    hs.notify.new({
      title = "Request failed",
      informativeText = "curl exited with code " .. tostring(rc)
    }):send()
    return ""
  end

  return output
end

module.sendToClipboard = function(s, verbose)
  hs.pasteboard.setContents(s)
  if verbose then
    hs.notify.new({
      title = "Text copied",
      informativeText = s
    }):send()
    hs.alert.show(s)
  end
end

module.showIp2 = function(ipMode)
  local output = module.getFromWeb("https://ip.f5n.de/")
  -- Trim whitespace/newlines
  local ip = module.trim(output or "")
  if ip ~= "" then
    module.sendToClipboard(ip, true)
  end
end

module.f5nauto = function()
 local _, prompt = hs.dialog.textPrompt("autotool", "ip.f5n.de/?auto=")
 local output = module.getFromWeb("https://ip.f5n.de/?auto=" .. lib.trim(lib.pyUrlEncode(prompt)))
 -- local log = hs.logger.new('mymodule','debug')
 -- log.i(d)
 local rv = output or ""
 if rv ~= "" then
   module.sendToClipboard(lib.trim(rv), true)
 end
end

return module
