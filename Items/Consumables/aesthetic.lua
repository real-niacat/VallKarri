local lc = loc_colour
local aes_colour = HEX("4500FF")
function loc_colour(_c, _default)
    if not G.ARGS.LOC_COLOURS then
        lc()
    end
    G.ARGS.LOC_COLOURS.valk_aesthetic = aes_colour
    return lc(_c, _default)
end

G.C.VALK_AESTHETIC = aes_colour

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

local aesthetic_cards = {

    { pos = { x = 0, y = 0 }, key = "e_foil", name = "frutiger_aero" },
    { pos = { x = 1, y = 0 }, key = "e_holo", name = "synthwave" },
    { pos = { x = 2, y = 0 }, key = "e_polychrome", name = "chromecore" },
    { pos = { x = 3, y = 0 }, key = "e_negative", name = "vaporwave" },
    -- { pos = { x = 0, y = 1 }, key = "e_cry_glitched", name = "glitch" },
    -- { pos = { x = 1, y = 1 }, key = "e_cry_mosaic", name = "antique" },
    -- { pos = { x = 2, y = 1 }, key = "e_cry_oversat", name = "weirdcore" },
    -- { pos = { x = 3, y = 1 }, key = "e_cry_glass", name = "net__art" },
    -- { pos = { x = 0, y = 2 }, key = "e_cry_gold", name = "vectorheart" },
    -- { pos = { x = 1, y = 2 }, key = "e_cry_blur", name = "liminality" },
    -- { pos = { x = 2, y = 2 }, key = "e_cry_noisy", name = "analog_horror" },
    -- { pos = { x = 3, y = 2 }, key = "e_cry_astral", name = "raygun_gothic" },
    -- { pos = { x = 4, y = 2 }, key = "e_cry_m", name = "metalheart" },
}

for _, edit in ipairs(aesthetic_cards) do
    SMODS.Consumable {
        set = "Aesthetic",
        key = edit.name,
        loc_txt = {
            name = key_to_name(edit.name),
            text = {
                "Enhance up to {C:attention}#1#{} selected",
                "Joker with {C:attention}#2#{}",
                credit("Pangaea"),
            }
        },
        pos = edit.pos,
        atlas = "aes",
        config = { extra = { select = 1, edition = edit.key } },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS[edit.key]
            return { vars = { 
                card.ability.extra.select,
                localize({ type = "name_text", set = "Edition", key = card.ability.extra.edition })
            } }
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
    pos = { x = 4, y = 0 },
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
        for i, joker in ipairs(G.jokers.cards) do
            if joker.edition then
                G.P_CENTERS[joker.edition.key].old_weight = G.P_CENTERS[joker.edition.key].weight
                G.P_CENTERS[joker.edition.key].weight = 0
                joker:set_edition("e_base")
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
