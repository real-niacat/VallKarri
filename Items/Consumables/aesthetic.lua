local lc = loc_colour
local aes_colour = HEX("4500FF")
function loc_colour(_c, _default)
    if not G.ARGS.LOC_COLOURS then
        lc()
    end
    G.ARGS.LOC_COLOURS.valk_aesthetic = aes_colour
    return lc(_c, _default)
end

G.C.VALK_CATACLYSM = aes_colour

SMODS.Atlas {
    key = "aes",
    path = "aesthetic.png",
    px = 71,
    py = 95,
}

SMODS.ConsumableType {
    key = "Aesthetic",
    collection_rows = { 6, 6 },
    primary_colour = HEX("6A33FF"),
    secondary_colour = aes_colour,
    shop_rate = 0.4,

    loc_txt = {
        collection = "Aesthetic Cards",
        label = "aesthetic",
        name = "Aesthetic Cards",
        undiscovered = {
            name = "go turn on unlock all",
            text = {
                "this mod is intended to be used",
                "with unlock all enabled"
            }
        }
    },
}

local function key_to_name(str)
    str = str:gsub("__", ".")
    str = str:gsub("_", " ")
    str = str:gsub("(%a)([%w%.]*)", function(first, rest) return first:upper() .. rest end)
    return str
end

-- frutiger - e_foil
-- synth - e_holo
-- chrome - e_polychrome
-- vapor - e_negative
-- glitch - e_cry_glitched
-- antique - e_cry_mosaic
-- weird - e_cry_oversat
-- net.art - e_cry_glass
-- vector - e_cry_gold
-- liminal - e_cry_blur
-- analog - e_cry_noisy
-- raygun - e_cry_astral
-- metalheart - e_cry_m
local aesthetic_cards = {
    frutiger_aero = "e_foil",
    synthwave = "e_holo",
    chromecore = "e_polychrome",
    vaporwave = "e_negative",
    glitch = "e_cry_glitched",
    antique = "e_cry_mosaic",
    weirdcore = "e_cry_oversat",
    ["net__art"] = "e_cry_glass",
    vectorheart = "e_cry_gold",
    liminality = "e_cry_blur",
    analog_horror = "e_cry_noisy",
    raygun_gothic = "e_cry_astral",
    metalheart = "e_cry_m"
}

local aesthetic_positions = {
    frutiger_aero = { x = 0, y = 0 },
    synthwave = { x = 1, y = 0 },
    chromecore = { x = 2, y = 0 },
    vaporwave = { x = 3, y = 0 },
    glitch = { x = 0, y = 1 },
    antique = { x = 1, y = 1 },
    weirdcore = { x = 2, y = 1 },
    ["net__art"] = { x = 3, y = 1 },
    vectorheart = { x = 0, y = 2 },
    liminality = { x = 1, y = 2 },
    analog_horror = { x = 2, y = 2 },
    raygun_gothic = { x = 3, y = 2 },
    metalheart = { x = 4, y = 2 },
}

for name, edit in pairs(aesthetic_cards) do
    SMODS.Consumable {
        set = "Aesthetic",
        key = name,
        loc_txt = {
            name = key_to_name(name),
            text = {
                "Enhance up to {C:attention}#1#{} selected",
                "Joker with {C:attention}#2#{}",
                credit("Pangaea"),
            }
        },
        pos = aesthetic_positions[name],
        atlas = "aes",

        config = { extra = { select = 1, edition = edit } },

        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.select, localize({ type = "name_text", set = "Edition", key = card.ability.extra.edition }) } }
        end,
        can_use = function(self, card)
            local sed = true

            for i, jkr in ipairs(G.jokers.highlighted) do
                if jkr.edition then
                    sed = false
                end
            end

            return (#G.jokers.highlighted > 0) and (#G.jokers.highlighted <= card.ability.extra.select) and sed
        end,
        use = function(self, card, area, copier)
            for i, high in ipairs(G.jokers.highlighted) do
                high:set_edition(card.ability.extra.edition)
            end
        end
    }
end

SMODS.Consumable {
    set = "Spectral",
    key = "prune",
    loc_txt = {
        name = "Prune",
        text = {
            "{C:attention}Editions{} of all owned jokers are {C:red}banished{}",
            "{C:attention}Editions{} appear {C:attention}X#1#{} more often",
            credit("Pangaea"),
        }
    },
    pos = {x=4,y=0},
    atlas = "aes",

    config = { extra = { mult = 10 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    can_use = function(self, card)

        for i, jkr in ipairs(G.jokers.cards) do
            if jkr.edition then
                return true 
            end
        end
        return false
    end,
    use = function(self, card, area, copier)
        for i,joker in ipairs(G.jokers.cards) do
            if joker.edition then

                G.P_CENTERS[joker.edition.key].old_weight = G.P_CENTERS[joker.edition.key].weight
                G.P_CENTERS[joker.edition.key].weight = 0 

            end
        end

        G.GAME.edition_rate = G.GAME.edition_rate * card.ability.extra.mult
    end,
    in_pool = function()
        for i, jkr in ipairs(G.jokers.cards) do
            if jkr.edition then
                return true 
            end
        end
        return false
    end
}
