local component = require("component")

-- Set these to the relevant components or nil if missing
for address, name in component.list("me_interface", true) do
  AE2Adapter = component.proxy(address)
end
redstoneControl = nil --component.proxy(component.redstone.address)
redstoneControlSide = nil --sides.up

-- Each element of the array is "item", "damage", "number wanted", "max craft size"
-- Damage value should be zero for base items

items = {
    { "minecraft:sand",      0, 16384, 1024},
    { "minecraft:redstone_block",        0, 1024, 256 },
    { "minecraft:iron_ingot",       0, 16384, 1024 },
    { "minecraft:gold_ingot",       0, 16384, 1024 },
    { "minecraft:glass",      0, 16384, 1024 },
    { "minecraft:quartz",      0, 16384, 1024 },
    { "minecraft:diamond",      0, 16384, 1024 },
    { "minecraft:emerald",      0, 16384, 1024 },
    { "thermalfoundation:material",       128, 16384, 1024 }, -- Copper Ingot
    { "thermalfoundation:material",       129, 16384, 1024 }, -- Tin Ingot
    { "thermalfoundation:material",       130, 16384, 1024 }, -- Silver Ingot
    { "thermalfoundation:material",       131, 16384, 1024 }, -- Lead Ingot
    { "thermalfoundation:material",       161, 16384, 1024 }, -- Electrum Ingot
    { "thermalfoundation:material",       162, 16384, 1024 }, -- Invar Ingot
    { "thermalfoundation:material",       163, 16384, 1024 }, -- Bronze Ingot
    { "thermalfoundation:material",       165, 16384, 1024 }, -- Signalum Ingot
    { "thermalfoundation:material",       167, 16384, 1024 }, -- Enderium Ingot
    { "tconstruct:ingots",                   0, 16384, 1024 }, -- Cobalt Ingot
    { "tconstruct:ingots",                   1, 16384, 1024 }, -- Ardite Ingot
    { "appliedenergistics2:material",       24, 4096, 256 }, -- Engineering Processor
    { "appliedenergistics2:material",       23, 4096, 256 }, -- Calculation Processor
    { "appliedenergistics2:material",       22, 4096, 256 }, -- Logic Processor
    { "appliedenergistics2:material",       11, 4096, 256 }, -- Pure Nether Quartz Crystal
    { "appliedenergistics2:material",       7, 4096, 256 }, -- Fluix Crystal
    { "appliedenergistics2:material",       12, 4096, 256 }, -- Pure Fluix Crystal
    { "appliedenergistics2:material",       8, 4096, 256 }, -- Fluix Dust
    { "appliedenergistics2:material",      44, 1024, 256 }, --Annihilation Core
    { "appliedenergistics2:material",      43, 1024, 256 }, --Formation Core
    { "appliedenergistics2:interface",      0, 256, 64 }, --ME Interface
    { "appliedenergistics2:part",       440, 256, 64 }, --ME Interface part
    { "appliedenergistics2:item.ItemMultiMaterial",       52, 32, 32 }, -- Blank Pattern
    { "appliedenergistics2:item.ItemMultiPart",       16, 128, 32 }, -- Glass Cable - Fluix
    { "actuallyadditions:item_dust",       5, 4096, 256 }, -- Crushed Quartz
    { "mysticalagriculture:crafting",       1, 1024,256}, --Prudentium Essence
    { "mysticalagriculture:crafting",       2, 1024,256}, --Intermedium Essence
    { "mysticalagriculture:crafting",       3, 1024,256}, --Superium Essence
    { "mysticalagriculture:crafting",       4, 1024,256} --Supremium Essence
}

minDelay = 30    -- Seconds between runs if something was crafted
maxDelay = 300   -- Seconds between runs if nothing was crafted
