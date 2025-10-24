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
            "Apply {C:blue}Transformative{} to {C:attention}#1#{}",
            "selected eligible Joker",
        }
    },
    valk_artist = "mailingway",

    can_use = function(self, card)
        if #G.jokers.highlighted > card.ability.extra.max or #G.jokers.highlighted < 1 then
            return false
        end

        for _,joker in pairs(G.jokers.highlighted) do
            if not joker.config.center.tau then
                return false
            end
        end
        return true 
    end,

    in_pool = function()
        for _,joker in pairs(G.jokers.cards) do
            if joker.config.center.tau then
                return true 
            end
        end
        return false 
    end,
    config = {extra = {max = 1}},

    use = function(self, card, area, copier) 
        
        for _,joker in pairs(G.jokers.highlighted) do
            if joker.config.center.tau then
                joker:add_sticker("valk_transformative")
            end
        end

    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.max}}
    end
}







