SMODS.Atlas {
    key = "tau",
    path = "tauics.png",
    px = 71,
    py = 95,
}

function load_tauics()

    for key,card in pairs(G.P_CENTERS) do

        if card.bases then
            for i,base in ipairs(card.bases) do
                -- print(base)
                G.P_CENTERS[base].tau = key
            end
        end

    end

end

legendary_tauics = {
    {base = "j_canio", tau = "j_valk_tau_canio"},
    {base = "j_triboulet", tau = "j_valk_tau_triboulet"},
    {base = "j_yorick", tau = "j_valk_tau_yorick"},
    {base = "j_chicot", tau = "j_valk_tau_chicot"},
    {base = "j_perkeo", tau = "j_valk_tau_perkeo"},
}

function tauic_check()
    for i,joker in ipairs(G.jokers.cards) do
        if joker.config.center.tau then
            return true
        end
    end

    return false
end

function tauic_owned()

    for i,joker in ipairs(G.jokers.cards) do

        if joker.config.center.rarity == "valk_tauic" then
            return true 
        end 

    end

    return false
end

SMODS.Joker {
    key = "tauist",
    loc_txt = {
        name = "Tauist",
        text = {
            "{C:cry_ember}Tauic{} Joker variants have their spawn",
            "chances increased whenever their roll fails",
            "{C:inactive}(Currently a {C:green}#1#%{C:inactive} chance to replace)",
            credit("Scraptake")
        }
    },
    config = { extra = { } },
    loc_vars = function(self, info_queue, card)
        local c = 0
        if G.GAME and G.GAME.tau_replace then
            c = 100 * (1 / G.GAME.tau_replace)
        end
        return { vars = { c } }
    end,
    rarity = 3,
    atlas = "main",
    pos = {x=8, y=4},
    soul_pos = {x=8, y=8, extra = {x=9, y=4}},
    cost = 12,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.tau_increase = G.GAME.tau_increase + 2
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.tau_increase = G.GAME.tau_increase - 2
    end
}

SMODS.Consumable {
    set = "Spectral",
    key = "absolutetau",

    cost = 150,
    atlas = "main",
    pos = {x=3, y=5},
    -- is_soul = true,
    soul_rate = 0.01,

    loc_txt = { 
        name = "Absolute Tau",
        text = {
            "Create a random {C:cry_ember}Tauic{} {C:legendary}Legendary{}",
            credit("mailingway")
        }
    },

    can_use = function(self, card)
        return true
    end,

    in_pool = function()
        return false 
    end,

    use = function(self, card, area, copier) 

        local legendary_keys = {}
        for i,t in ipairs(legendary_tauics) do
            table.insert(legendary_keys, t.tau)
        end
        
        simple_create("Joker", G.jokers, legendary_keys[math.random(#legendary_keys)])

    end,
    dependencies = {"Talisman"},
}

-- SMODS.Joker {
--     key = "",
--     loc_txt = {
--         name = "{C:cry_ember}Tauic {}",
--         text = {
--             "",
--             "",
--             credit("Scraptake")
--         }
--     },
--     config = { extra = { } },
--     loc_vars = function(self, info_queue, card)
--         return { vars = {  } }
--     end,
--     rarity = "valk_tauic",
--     atlas = "tau",
--     pos = {x=0, y=0},
--     soul_pos = {x=0, y=1},
--     cost = 4,
--     no_doe = true,
--     calculate = function(self, card, context)
        
--     end
-- }











