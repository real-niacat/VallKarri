vallkarri.config_tab = function() -- the configs will be stored in config.lua and you can find the file of the configs in "Roaming/balatro/config" then vallkarri.jkr for this mod
    local scale = 5 / 6
    return {
        n = G.UIT.ROOT,
        config = { align = "cm", minh = G.ROOM.T.h * 0.25, padding = 0.0, r = 0.1, colour = G.C.GREY },
        nodes = {
            {
                n = G.UIT.C,
                config = { padding = 0.05 },
                nodes = {
                    {
                        n = G.UIT.R,
                        config = { minw = G.ROOM.T.w * 0.125, padding = 0.05, align = "cm", },
                        nodes = {
                            create_toggle {
                                label = "Enable Overscoring",                                                                              -- the label that shows up next to the toggle button
                                info = { "Overscoring is a mechanic which increases your ante", "if you score too high on the boss blind" }, -- the text that will show below the toggle option
                                active_colour = G.C.GREEN,                                                                                 -- the color of the toggle when it is on
                                ref_table = vallkarri.config,                                                                              -- the table of which the toggle refrerences to check if it is on or off
                                ref_value = "overscoring"                                                                                  -- the value from the ref_table that the toggle will change when pressed
                            }
                        },
                    },
                    {
                        n = G.UIT.R,
                        config = { minw = G.ROOM.T.w * 0.125, padding = 0.05, align = "cm", },
                        nodes = {
                            create_toggle {
                                label = "Toggle levelling",                                                                                               -- the label that shows up next to the toggle button
                                info = { "Enables the levelling system", "Gives benefits, but increases blind size based on level", "(Requires restart)" }, -- the text that will show below the toggle option
                                active_colour = G.C.GREEN,                                                                                                -- the color of the toggle when it is on
                                ref_table = vallkarri.config,                                                                                             -- the table of which the toggle refrerences to check if it is on or off
                                ref_value = "metaprogression"                                                                                             -- the value from the ref_table that the toggle will change when pressed
                            }
                        }
                    },
                    {
                        n = G.UIT.R,
                        config = { minw = G.ROOM.T.w * 0.125, padding = 0.05, align = "cm", },
                        nodes = {
                            create_toggle {
                                label = "Excessive badges",                                                          -- the label that shows up next to the toggle button
                                info = { "Add badges to certain cards which may be bothersome, but give extra info" }, -- the text that will show below the toggle option
                                active_colour = G.C.GREEN,                                                           -- the color of the toggle when it is on
                                ref_table = vallkarri.config,                                                        -- the table of which the toggle refrerences to check if it is on or off
                                ref_value = "excessive_badges"                                                       -- the value from the ref_table that the toggle will change when pressed
                            }
                        },
                    },
                    {
                        n = G.UIT.R,
                        config = { minw = G.ROOM.T.w * 0.125, padding = 0.05, align = "cm", },
                        nodes = {
                            create_toggle {
                                label = "Tauics in collection",                                                          -- the label that shows up next to the toggle button
                                info = { "Allow Tauic jokers to appear in the collection" }, -- the text that will show below the toggle option
                                active_colour = G.C.GREEN,                                                           -- the color of the toggle when it is on
                                ref_table = vallkarri.config,                                                        -- the table of which the toggle refrerences to check if it is on or off
                                ref_value = "tau_collection"                                                       -- the value from the ref_table that the toggle will change when pressed
                            }
                        },
                    },
                }
            },

        }
    }
end

function vallkarri.new_cardarea(name, config)
    if not config then config = {} end
    local height = config.h or 1.25
    local width = config.w or 1
    local card_limit = config.card_limit or 52
    local margin_left = config.ml or 0.
    local margin_top = config.mt or 0
    local type = config.type or "title"
    local highlight_limit = config.highlight_limit or 0
    local use_room = config.use_room or true
    local ca = CardArea(
        (use_room and G.ROOM.T.x or 0) + margin_left * (use_room and G.ROOM.T.w or 1), (use_room and G.ROOM.T.h or 0) + margin_top , width, height, { card_limit = card_limit, type = type, highlight_limit = highlight_limit }
    )
    ca.states.collide.can = true
    ca.states.release_on.can = true
    vallkarri.card_areas = vallkarri.card_areas or {}
    vallkarri.card_areas[name] = ca
    return ca
end

function vallkarri.blackjack_get_ui_definition(params)
    print("we are generating...")
    return {
        n = G.UIT.ROOT,
        config = {
            w = 8,
            minh = 6,
            r = 0.1,
            colour = G.C.UI.TRANSPARENT_DARK
        },
        nodes = {
            {
                n = G.UIT.C,
                config = {
                    object = vallkarri.new_cardarea()
                }
            }
        }
    }
end
