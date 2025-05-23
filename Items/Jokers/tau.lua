tauics = {
    {base = "j_joker",  tau = "j_valk_tau_joker"},
    {base = "j_lusty_joker",  tau = "j_valk_tau_sins"},
    {base = "j_chaos",  tau = "j_valk_tau_clown"}
}

function tauic_owned()
    for i,joker in ipairs(G.jokers.cards) do

        for j,tauic in ipairs(tauics) do

            if (joker.config.center_key == tauic.base) then
                return true
            end

        end

        

    end

    return false
end

SMODS.Consumable {
    set = "Spectral",
    key = "twopi",

    cost = 15,
    atlas = "phold",
    pos = short_sprites.placeholder,
    soul_rate = 0.01,

    loc_txt = { 
        name = "Two Pi",
        text = {
            "Converts all applicable jokers into {C:cry_ember}Tauic{} jokers",
            credit("Nobody!")
        }
    },

    can_use = function(self, card)
        return tauic_owned()
    end,

    in_pool = function()
        return tauic_owned()
    end,

    use = function(self, card, area, copier) 

        for i,joker in ipairs(G.jokers.cards) do

            for j,tauic in ipairs(tauics) do

                if (joker.config.center_key == tauic.base) then
                    joker:set_ability(G.P_CENTERS[tauic.tau])
                end

            end

            

        end

    end



}

SMODS.Joker {
    key = "tau_joker",
    loc_txt = {
        name = "{C:cry_ember}Tauic Joker{}",
        text = {
            "{X:mult,C:white}^#1#{} Mult for every Tauic card",
            "{C:inactive}Includes this card{}",
            credit("Scraptake")
        }
    },
    config = { extra = { mult = 1.4444} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=0, y=1},
    cost = 4,
    calculate = function(self, card, context)
        if (context.other_joker and context.other_joker.config.center.rarity == "valk_tauic") then
            return {e_mult = card.ability.extra.mult}
        end
    end
}

SMODS.Joker {
    key = "tau_clown",
    loc_txt = {
        name = "{C:cry_ember}Tauic Chaos the Clown{}",
        text = {
            "{C:attention}#1#{} free {C:green}rerolls{} in shop",
            "When blind selected, gain {C:attention}#2#{} {C:blue}hand{} and {C:red}discard{} per {C:green}reroll{} in last shop",
            "{C:inactive}Currently +#3# hands and discards{}",
            credit("Scraptake")
        }
    },
    config = { extra = { rerolls = 2, bonus = 1, current = 0} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.rerolls, card.ability.extra.bonus, card.ability.extra.current } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=1, y=1},
    cost = 4,

    add_to_deck = function(self, card, from_debuff)
        SMODS.change_free_rerolls(card.ability.extra.rerolls)
    end,

    remove_from_deck = function(self, card, from_debuff)
        SMODS.change_free_rerolls(-card.ability.extra.rerolls)
    end,

    calculate = function(self, card, context)
        if (context.setting_blind) then

            ease_hands_played(card.ability.extra.bonus * card.ability.extra.current)
            ease_discard(card.ability.extra.bonus * card.ability.extra.current)

            G.GAME.current_round.hands_left = G.GAME.current_round.hands_left + (card.ability.extra.bonus * card.ability.extra.current) 
            G.GAME.current_round.discards_left = G.GAME.current_round.discards_left + (card.ability.extra.bonus * card.ability.extra.current)
            card.ability.extra.current = 0
        end

        if (context.reroll_shop) then
            card.ability.extra.current = card.ability.extra.current + 1
        end
    end
}

SMODS.Joker {
    key = "tau_sins",
    loc_txt = {
        name = "{C:cry_ember}Tauic Sin Joker{}",
        text = {
            "{X:chips,C:white}^#1#{} Chips for every card with a suit scored, in hand or in deck",
            credit("Scraptake")
        }
    },
    config = { extra = { chips = 1.03} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=2, y=1},
    cost = 4,
    calculate = function(self, card, context)
        if (context.individual and context.other_card and not context.end_of_round) then
            if (context.other_card:is_suit("Spades") or context.other_card:is_suit("Hearts") or context.other_card:is_suit("Clubs") or context.other_card:is_suit("Diamonds")) then
                return {e_chips = card.ability.extra.chips}
            end
        end
    end
}