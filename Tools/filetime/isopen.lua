function check()
    local clock = os.clock

    function sleep(n)  -- seconds
        local t0 = clock()

        while clock() - t0 <= n do
        end
    end

    require "filetime.lua"
--print("before")
    newTime = getFileTime("output.j", 3)
--print("after")
    if (lastTime ~= nil) then
        if (lastTime ~= newTime) then
            print("changed")
        end
    end
print(newTime)
    lastTime = newTime

    sleep(0.5)

    check()
end

check()