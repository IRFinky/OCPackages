-- Stock Management Script
-- Adapted from https://oc.cil.li/topic/1426-ae2-level-auto-crafting/

local component = require("component")
local gpu = component.gpu

-- Import the stocklist
require("stocklist")

results = {}     -- Array that holds currently pending crafts

while true do
    needOres = false
    loopDelay = maxDelay

    -- Process crafting indexes
    for curIdx = 1, #items do
        curName = items[curIdx][1]
        curDamage = items[curIdx][2]
        curMinValue = items[curIdx][3]
        curMaxRequest = items[curIdx][4]

        -- io.write("Checking for " .. curMinValue .. " of " .. curName .. "\n")
        storedItem = AE2Adapter.getItemsInNetwork({
            name = curName,
            damage = curDamage
            })

        -- Write status of item
        gpu.setForeground(0xCC24C0) -- Purple-ish
        io.write("\n" .. storedItem[1].size)
        gpu.setForeground(0x00FF00) -- Green
        io.write(" " .. storedItem[1].label)
        gpu.setForeground(0xFFFFFF) -- White

        -- We need to craft some of this item
        if storedItem[1].size < curMinValue then
            delta = curMinValue - storedItem[1].size
            craftAmount = delta
            if delta > curMaxRequest then
                craftAmount = curMaxRequest
            end

            -- Write out status message
            io.write(", need ")
            gpu.setForeground(0xFF0000) -- Red
            io.write(delta)
            gpu.setForeground(0xFFFFFF) -- White
            io.write(", requesting ")
            gpu.setForeground(0xCC24C0) -- Purple-ish
            io.write(craftAmount .. "...")
            gpu.setForeground(0xFFFFFF) -- White

            -- Retrieve a craftable recipe for this item
            craftables = AE2Adapter.getCraftables({
                name = curName,
                damage = curDamage
                })
            if craftables.n >= 1 then
                -- Request some of these items
                cItem = craftables[1]
                gpu.setForeground(0x00FF00) -- Green
                io.write(" Craftable Found")
                retval = cItem.request(craftAmount)
                if retval ~= nil then
                    -- Flag that we made something, so turn back on the inputs
                    table.insert(results,retval)
                    needOres = true
                else
                    gpu.setForeground(0xFF0000) -- Red
                    io.write(" but unable to request")
                end
                gpu.setForeground(0xFFFFFF) -- White
            else
                -- Could not find a craftable for this item
                gpu.setForeground(0xFF0000) -- Red
                io.write(" No Craftable Found")
                gpu.setForeground(0xFFFFFF) -- White
            end
        end
    end

    if needOres == true then
      -- We crafted stuff.  Turn off redstone and set a short delay
      if redstoneControl ~= nil then
        io.write("Setting redstone controller to 0.\n")
        redstoneControl.setOutput(redstoneControlSide,0)
      end
      loopDelay = minDelay
    else
      -- We didn't.  Wait longer.
      if redstoneControl ~= nil then
        io.write("Setting redstone controller to 15..\n")
        redstoneControl.setOutput(redstoneControlSide,15)
      end
      loopDelay = maxDelay
    end

    -- Wait for pending crafts to be done
    while #results > 0 do
      -- See if we can complete a craft
      for curIdx = 1, #results do
        curCraft = results[curIdx]
        if curCraft.isCanceled() or curCraft.isDone() then
          io.write("A craft was completed.\n")
          table.remove(results,curIdx)
          break
        else
          -- A short delay if we are waiting for crafts to finish
          io.write("A craft is pending, sleeping for 5 seconds...\n")
          os.sleep(5)
        end
      end
    end

    io.write("Sleeping for " .. loopDelay .. " seconds...\n\n")
    os.sleep(loopDelay)
end
