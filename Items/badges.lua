local fakemodbadge = SMODS.create_mod_badges
function SMODS.create_mod_badges(obj, badges)
    reload_badges()
    fakemodbadge(obj, badges)
    if obj then
        -- print(obj)
        -- print("wow the object exists")
        for i, entry in ipairs(valk_badgecards) do
            if entry.card == obj.key then
                -- print("has a badge we care about")
                -- slightly modified code from pwx
                badges[#badges + 1] = {
                    n = G.UIT.R,
                    config = { align = "cm" },
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = {
                                align = "cm",
                                colour = entry.badge.color,
                                r = 0.1,
                                minw = 2,
                                minh = 0.36,
                                emboss = 0.05,
                                padding = 0.027,
                            },
                            nodes = {
                                { n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
                                {
                                    n = G.UIT.O,
                                    config = {
                                        object = DynaText({
                                            string = entry.badge.text,
                                            colours = { entry.badge.text_color or G.C.WHITE },
                                            silent = true,
                                            float = true,
                                            shadow = true,
                                            offset_y = -0.03,
                                            spacing = 1,
                                            scale = 0.33 * 0.9,
                                        }),
                                    },
                                },
                                { n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
                            },
                        },
                    },
                }
            end
        end
    end

    if not SMODS.config.no_mod_badges and obj and obj.valk_artist then
        local function calc_scale_fac(text)
            local size = 0.9
            local font = G.LANG.font
            local max_text_width = 2 - 2 * 0.05 - 4 * 0.03 * size - 2 * 0.03
            local calced_text_width = 0
            -- Math reproduced from DynaText:update_text
            for _, c in utf8.chars(text) do
                local tx = font.FONT:getWidth(c) * (0.33 * size) * G.TILESCALE * font.FONTSCALE
                    + 2.7 * 1 * G.TILESCALE * font.FONTSCALE
                calced_text_width = calced_text_width + tx / (G.TILESIZE * G.TILESCALE)
            end
            local scale_fac = calced_text_width > max_text_width and max_text_width / calced_text_width or 1
            return scale_fac
        end
        local scale_fac = {}
        local min_scale_fac = 1
        local strings = { vallkarri.display_name, "Art: " .. obj.valk_artist }
        for i = 1, #strings do
            scale_fac[i] = calc_scale_fac(strings[i])
            min_scale_fac = math.min(min_scale_fac, scale_fac[i])
        end
        local ct = {}
        for i = 1, #strings do
            ct[i] = {
                string = strings[i],
            }
        end
        local artist_badge = {
            n = G.UIT.R,
            config = { align = "cm" },
            nodes = {
                {
                    n = G.UIT.R,
                    config = {
                        align = "cm",
                        colour = vallkarri.badge_colour,
                        r = 0.1,
                        minw = 2 / min_scale_fac,
                        minh = 0.36,
                        emboss = 0.05,
                        padding = 0.03 * 0.9,
                    },
                    nodes = {
                        { n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
                        {
                            n = G.UIT.O,
                            config = {
                                object = DynaText({
                                    string = ct or "ERROR",
                                    colours = { G.C.WHITE },
                                    silent = true,
                                    float = true,
                                    shadow = true,
                                    offset_y = -0.03,
                                    spacing = 1,
                                    scale = 0.33 * 0.9,
                                }),
                            },
                        },
                        { n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
                    },
                },
            },
        }
        for i = 1, #badges do
            if badges[i].nodes[1].nodes[2].config.object.string == vallkarri.display_name then     --this was meant to be a hex code but it just doesnt work for like no reason so its hardcoded
                badges[i].nodes[1].nodes[2].config.object:remove()
                badges[i] = artist_badge
                break
            end
        end
    end
end

function reload_badges()
    valk_badgecards = {}
    for key, card in pairs(G.P_CENTERS) do
        for name, badge in pairs(valk_badgetypes) do
            if badge.func(card) and ((badge.excessive and vallkarri.config.excessive_badges) or not badge.excessive) then
                valk_badgecards[#valk_badgecards + 1] = { card = key, badge = valk_badgetypes[name] }
            end
        end
    end
end

valk_badgetypes = {
    ingredient = {
        text = "Ingredient",
        color = G.C.WHITE,
        text_color = G.C.BLACK,
        func = function(center)
            local ingredients = {}
            for i, j in ipairs(merge_recipes) do
                for k, card in ipairs(j.input) do
                    ingredients[#ingredients + 1] = card
                end
            end

            return table:vcontains(ingredients, center.key)
        end

    },
    lore = {
        text = "Has Lore",
        color = G.C.BLUE,
        text_color = G.C.WHITE,
        func = function(center)
            return (center.lore)
        end,
        excessive = true,
    },
    immutable = {
        text = "Immutable",
        color = G.C.ORANGE,
        text_color = G.C.WHITE,
        func = function(center)
            return (center.immutable)
        end
    },
    no_grc = {
        text = "Exclusive",
        color = G.C.RED,
        text_color = G.C.WHITE,
        func = function(center)
            return center.no_grc and (SMODS.Mods["Cryptid"] or {}).can_load
        end,
        excessive = true,
    },
    no_doe = {
        text = "Equilibrium-Proof",
        color = G.C.GOLD,
        text_color = G.C.WHITE,
        func = function(center)
            return center.no_doe and (SMODS.Mods["Cryptid"] or {}).can_load
        end
    },
    kitty = {
        text = "Kitty",
        color = HEX("94BAFF"),
        text_color = G.C.UI.TEXT_LIGHT,
        func = function(center)
            return Cryptid.safe_get(center, "pools", "Kitties")
        end,
        excessive = true,
    }
}

valk_badgecards = {
    -- format:
    -- {card=
}
