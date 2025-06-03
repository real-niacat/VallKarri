vallkarri.config_tab = function() -- the configs will be stored in config.lua and you can find the file of the configs in "Roaming/balatro/config" then vallkarri.jkr for this mod
    local scale = 5/6
    return {n=G.UIT.ROOT, 
        config = {align = "cl", minh = G.ROOM.T.h*0.5, padding = 0.0, r = 0.1, colour = G.C.GREY}, 
        nodes = {
            {n = G.UIT.R, config = { padding = 0.05 }, 
                nodes = {
                    {n = G.UIT.C, config = { minw = G.ROOM.T.w*0.125, padding = 0.05 }, 
                        nodes = {
                            create_toggle{
                                label = "Enable Overscoring", -- the label that shows up next to the toggle button
                                info = {"Overscoring is a mechanic which increases your ante", "if you score too high on the boss blind"}, -- the text that will show below the toggle option
                                active_colour = G.C.GREEN, -- the color of the toggle when it is on
                                ref_table = vallkarri.config, -- the table of which the toggle refrerences to check if it is on or off
                                ref_value = "overscoring" -- the value from the ref_table that the toggle will change when pressed
                            }
                        },
                    },
                    {n = G.UIT.C, config = { minw = G.ROOM.T.w*0.125, padding = 0.05 }, 
                        nodes = {
                            create_toggle{
                                label = "Toggle experimental mechanics", -- the label that shows up next to the toggle button
                                info = {"Enables some mechanics that can and will cause bugs", "You are free to report bugs, but they may not be resolved"}, -- the text that will show below the toggle option
                                active_colour = G.C.GREEN, -- the color of the toggle when it is on
                                ref_table = vallkarri.config, -- the table of which the toggle refrerences to check if it is on or off
                                ref_value = "risky_stuff" -- the value from the ref_table that the toggle will change when pressed
                            }
                        }
                    },
                }
            },

        }
    }
end
