SMODS.Atlas {
    key = "tau",
    path = "tauic_jokers.png",
    px = 71,
    py = 95,
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
            "{C:valk_fire}Tauic{} Jokers are {X:valk_tauic,C:white}X#1#{} more likely to spawn",
            "Increase by {X:valk_tauic,C:white}X#2#{} at end of round",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { mult = 1, gain = 0.25} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.gain } }
    end,
    rarity = 3,
    atlas = "main",
    pos = {x=8, y=4},
    soul_pos = {x=8, y=8, extra = {x=9, y=4}},
    cost = 12,
    calculate = function(self, card, context)
        if context.valk_tau_probability_mod then
            return {
                numerator = context.numerator * card.ability.extra.mult
            }
        end

        if context.end_of_round and context.main_eval then
            SMODS.scale_card(card, {ref_table = card.ability.extra, scalar_value = "gain", ref_value = "mult"})
        end
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
            "Create a random {C:valk_fire}Tauic{} {C:legendary}Legendary{} Joker",
        }
    },
    valk_artist = "mailingway",

    can_use = function(self, card)
        return true
    end,

    in_pool = function()
        return false 
    end,

    use = function(self, card, area, copier) 
        local allowed = {}
        for i,joker in pairs(G.P_CENTER_POOLS.Joker) do
            if joker.rarity == 4 and joker.tau then
                allowed[#allowed+1] = joker.tau
            end
        end
        
        simple_create("Joker", G.jokers, allowed[pseudorandom("valk_absolute_tau",1,#allowed)])

    end,
    dependencies = {"Talisman"},
}







