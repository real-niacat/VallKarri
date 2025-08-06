local fakemodbadge = SMODS.create_mod_badges
function SMODS.create_mod_badges(obj, badges)
    reload_badges()
    fakemodbadge(obj, badges)
    if obj then
        -- print(obj)
        -- print("wow the object exists")
        for i,entry in ipairs(valk_badgecards) do

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


end

function reload_badges()
    valk_badgecards = {}
    for key,card in pairs(G.P_CENTERS) do
        for name,badge in pairs(valk_badgetypes) do
            
            if badge.func(card) and ((badge.excessive and vallkarri.config.excessive_badges) or not badge.excessive) then
                valk_badgecards[#valk_badgecards+1] = {card = key, badge = valk_badgetypes[name]}
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
            for i,j in ipairs(merge_recipes) do
                for k,card in ipairs(j.input) do
                    ingredients[#ingredients+1] = card
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
        end
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
            return center.no_grc
        end,
        excessive = true,
    },
    no_doe = {
        text = "Equilibrium-Proof",
        color = G.C.GOLD,
        text_color = G.C.WHITE,
        func = function(center)
            return center.no_doe
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