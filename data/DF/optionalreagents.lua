local Data = AHCC:NewModule("AHCC_DATA_DF_optionalreagents", AHCC_DATA)
local L, _ = AHCC:GetLibs()


Data.Config = {
    mode = "insert",
    nav = {},
    versionStart = 100000,
    versionEnd = 110002
} 


Data.Categories = {
    {
        ["name"] =  L["Optional Reagents"],
        ["config"] = {
        },
        ["subCategories"] = {
            {
                ["name"] =  L["Draconic Missive"],
                ["config"] = {
                    ["allowDuplicates"] = true,
                    ["columns"] = {"Stat1", "Stat2", "Quality"}
                },
                ["subCategories"] = {
                    {
                        ["name"] = L["CRITICAL_STRIKE"],
                        ["config"] = {
                            ["columns"] = {"Stat2", "Quality"}
                        },
                        ["Items"] = {
                            { ["id"] = { 192553, 192554, 192552 }, ["Stat1"] = 1, ["Stat2"] = 2 }, -- Drakonisches Schreiben des Feuerpeitsche
                            { ["id"] = { 194579, 194580, 194578 }, ["Stat1"] = 1, ["Stat2"] = 3 }, -- Drakonisches Schreiben der Unvergleichlichkeit
                            { ["id"] = { 194573, 194574, 194572 }, ["Stat1"] = 1, ["Stat2"] = 4 }, -- Drakonisches Schreiben der Schnellklinge
                            
                        }
                    },
                    {
                        ["name"] = L["HASTE"],
                        ["config"] = {
                            ["columns"] = {"Stat2", "Quality"}
                        },
                        ["Items"] = {
                            { ["id"] = { 192553, 192554, 192552 }, ["Stat1"] = 2, ["Stat2"] = 1 }, -- Drakonisches Schreiben des Feuerpeitsche
                            { ["id"] = { 194567, 194568, 194566 }, ["Stat1"] = 2, ["Stat2"] = 3 }, -- Drakonisches Schreiben des Hitzeschocks
                            { ["id"] = { 194570, 194571, 194569 }, ["Stat1"] = 2, ["Stat2"] = 4 }, -- Drakonisches Schreiben der Aurora

                        }
                    },
                    {
                        ["name"] = L["MASTERY"],
                        ["config"] = {
                            ["columns"] = {"Stat2", "Quality"}
                        },
                        ["Items"] = {
                            { ["id"] = { 194579, 194580, 194578 }, ["Stat1"] = 3, ["Stat2"] = 1 }, -- Drakonisches Schreiben der Unvergleichlichkeit
                            { ["id"] = { 194567, 194568, 194566 }, ["Stat1"] = 3, ["Stat2"] = 2 }, -- Drakonisches Schreiben des Hitzeschocks
                            { ["id"] = { 194576, 194577, 194575 }, ["Stat1"] = 3, ["Stat2"] = 4 }, -- Drakonisches Schreiben der Harmonischen

                        }
                    },
                    {
                        ["name"] = L["VERSATILITY"],
                        ["config"] = {
                            ["columns"] = {"Stat2", "Quality"}
                        },
                        ["Items"] = {
                            { ["id"] = { 194573, 194574, 194572 }, ["Stat1"] = 4, ["Stat2"] = 1 }, -- Drakonisches Schreiben der Schnellklinge
                            { ["id"] = { 194570, 194571, 194569 }, ["Stat1"] = 4, ["Stat2"] = 2 }, -- Drakonisches Schreiben der Aurora
                            { ["id"] = { 194576, 194577, 194575 }, ["Stat1"] = 4, ["Stat2"] = 3 }, -- Drakonisches Schreiben der Harmonischen

                        }
                    },
                }
            },
            {
                ["name"] =  L["Embellishments"],
                ["config"] = {
                    ["columns"] = {"Quality"}
                },
                ["Items"] = {
                    { ["id"] = { 191532, 191533, 191534 }}, -- Potion Absorption Inhibitor
                    { ["id"] = { 191250, 191872, 191873 }}, --Armor Spikes
                    { ["id"] = { 193469, 193552, 193555 }}, -- Toxified Armor Patch
                    { ["id"] = { 193468, 193551, 193554 }}, -- Fang Adornments
                    { ["id"] = { 193944, 193945, 193946 }}, -- Blue Silken Lining
                    { ["id"] = { 193941, 193942, 193943 }}, -- Bronzed Grip Wrappings
                    { ["id"] = 200652 }, -- Alchemical Flavor Pocket
                    { ["id"] = 205012 }, -- Reserve Parachute
                    { ["id"] = 205411 }, -- Medical Wrap Kit
                    { ["id"] = { 204708, 204709, 204710 }}, -- Shadowflame-Tempered Armor Patch
                    { ["id"] = { 204909, 205115, 205170 }}, -- Statuette of Foreseen Power
                    { ["id"] = { 205171, 205172, 205173 }}, -- Figurine of the Gathering Storm
                    { ["id"] = { 210671, 210672, 210673 }}, -- Verdant Tether
                    { ["id"] = 203652 }, -- Gaunahs Allzweck-Verzierungspulver
                }
            }
        }
    }
}