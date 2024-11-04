local module = {}

module.RunWithArgs = function(executable, args)
    local t = hs.task.new(executable, 
    nil,
    function() return false end,
    args)
    t:start()
end

return module