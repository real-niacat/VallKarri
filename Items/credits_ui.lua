function vallkarri.credits_ui_def()
    local text_scale = 0.30
    local scale = 0.5

    local colours = {
        code = HEX("FCA0FF"),
        art = HEX("A0CCFF"),
        shader = HEX("A1FF9E")
    }

    local ui = {
        n = G.UIT.ROOT,
        config = { align = "cm", minh = G.ROOM.T.h * scale, minw = G.ROOM.T.w * scale, padding = 0.0, r = 0.1, colour = G.C.GREY },
        nodes = {
            {
                n = G.UIT.R,
                config = {},
                nodes = {
                    {
                        n = G.UIT.C,
                        config = { align = "cl", minw = 3, padding = 0.1 },
                        nodes = {
                            { n = G.UIT.R, config = {}, nodes = {{ n = G.UIT.T, config = { text = "Programming", colour = colours.code, scale = text_scale * 2, shadow = true, align = "tm" } }}},
                            { n = G.UIT.R, config = {}, nodes = {{ n = G.UIT.T, config = { text = "Lily Felli", colour = colours.code, scale = text_scale, shadow = true, align = "tm" } }}},
                            { n = G.UIT.R, config = {}, nodes = {{ n = G.UIT.T, config = { text = "baccon3", colour = colours.code, scale = text_scale, shadow = true, align = "tm" } }}},
                        }
                    },
                    {
                        n = G.UIT.C,
                        config = { align = "cm", minw = 3, padding = 0.1 },
                        nodes = {
                            { n = G.UIT.R, config = {}, nodes = {{ n = G.UIT.T, config = { text = "Artists", colour = colours.art, scale = text_scale * 2, shadow = true, align = "tm" } }}},
                            { n = G.UIT.R, config = {}, nodes = {{ n = G.UIT.T, config = { text = "Lily Felli", colour = colours.art, scale = text_scale, shadow = true, align = "tm" } }}},
                            { n = G.UIT.R, config = {}, nodes = {{ n = G.UIT.T, config = { text = "Scraptake", colour = colours.art, scale = text_scale, shadow = true, align = "tm" } }}},
                            { n = G.UIT.R, config = {}, nodes = {{ n = G.UIT.T, config = { text = "mailingway", colour = colours.art, scale = text_scale, shadow = true, align = "tm" } }}},
                            { n = G.UIT.R, config = {}, nodes = {{ n = G.UIT.T, config = { text = "Pangaea", colour = colours.art, scale = text_scale, shadow = true, align = "tm" } }}},
                            { n = G.UIT.R, config = {}, nodes = {{ n = G.UIT.T, config = { text = "Lil Mr. Slipstream", colour = colours.art, scale = text_scale, shadow = true, align = "tm" } }}},
                            { n = G.UIT.R, config = {}, nodes = {{ n = G.UIT.T, config = { text = "lord.ruby", colour = colours.art, scale = text_scale, shadow = true, align = "tm" } }}},
                            { n = G.UIT.R, config = {}, nodes = {{ n = G.UIT.T, config = { text = "Grahkon", colour = colours.art, scale = text_scale, shadow = true, align = "tm" } }}},
                            { n = G.UIT.R, config = {}, nodes = {{ n = G.UIT.T, config = { text = "Nerxiana", colour = colours.art, scale = text_scale, shadow = true, align = "tm" } }}},
                            { n = G.UIT.R, config = {}, nodes = {{ n = G.UIT.T, config = { text = "notmario", colour = colours.art, scale = text_scale, shadow = true, align = "tm" } }}},
                            { n = G.UIT.R, config = {}, nodes = {{ n = G.UIT.T, config = { text = "triangle_snack", colour = colours.art, scale = text_scale, shadow = true, align = "tm" } }}},
                            { n = G.UIT.R, config = {}, nodes = {{ n = G.UIT.T, config = { text = "Poker the Poker", colour = colours.art, scale = text_scale, shadow = true, align = "tm" } }}},
                            { n = G.UIT.R, config = {}, nodes = {{ n = G.UIT.T, config = { text = "Aikoyori", colour = colours.art, scale = text_scale, shadow = true, align = "tm" } }}},
                            { n = G.UIT.R, config = {}, nodes = {{ n = G.UIT.T, config = { text = "Aduckted", colour = colours.art, scale = text_scale, shadow = true, align = "tm" } }}},
                            { n = G.UIT.R, config = {}, nodes = {{ n = G.UIT.T, config = { text = "gudusername", colour = colours.art, scale = text_scale, shadow = true, align = "tm" } }}},
                        }
                    },
                    {
                        n = G.UIT.C,
                        config = { align = "cr", minw = 3, padding = 0.1 },
                        nodes = {
                            { n = G.UIT.R, config = {}, nodes = {{ n = G.UIT.T, config = { text = "Shaders", colour = colours.shader, scale = text_scale * 2, shadow = true, align = "tm" } }}},
                            { n = G.UIT.R, config = {}, nodes = {{ n = G.UIT.T, config = { text = "Lily Felli", colour = colours.shader, scale = text_scale, shadow = true, align = "tm" } }}},
                            { n = G.UIT.R, config = {}, nodes = {{ n = G.UIT.T, config = { text = "The Beautiful And Wonderful GLSL Programming Language", colour = colours.shader, scale = text_scale * 0.5, shadow = true, align = "tm" } }}},
                        }
                    },
                }
            }

        }
    }

    return ui
end

-- return vallkarri.credits_ui_def()