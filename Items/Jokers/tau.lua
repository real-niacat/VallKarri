tauics = {
    {base = "j_joker",  tau = "j_valk_tau_joker"},
    {base = "j_lusty_joker",  tau = "j_valk_tau_sins"},
    {base = "j_greedy_joker",  tau = "j_valk_tau_sins"},
    {base = "j_wrathful_joker",  tau = "j_valk_tau_sins"},
    {base = "j_gluttenous_joker",  tau = "j_valk_tau_sins"},
    -- localthunk PLEASE stop FUCKING WITH ME
    -- ITS SPELLED GLUTTONOUS
    {base = "j_chaos",  tau = "j_valk_tau_clown"},
    {base = "j_mime", tau = "j_valk_tau_mime"},
    {base = "j_obelisk", tau = "j_valk_tau_obelisk"},
    {base = "j_cartomancer", tau = "j_valk_tau_cartomancer"},
    {base = "j_rocket", tau = "j_valk_tau_rocket"},
    {base = "j_oops", tau = "j_valk_tau_oops"},
    {base = "j_troubadour", tau = "j_valk_tau_troubadour"},
}

function tauic_check()
    if (#G.jokers.cards > 0) then
        local jkr = select(2,next(G.jokers.cards))

        for j,tauic in ipairs(tauics) do

            if (jkr.config.center_key == tauic.base) then
                return true
            end

        end

        

    end

    return false
end

function tauic_owned()

    if (#G.jokers.cards > 0) then

        for i,joker in ipairs(G.jokers.cards) do

            for j,tauic in ipairs(tauics) do
        
                if (joker.config.center_key == tauic.base) then
                    return true
                end

           end 

        end

    end
end

SMODS.Consumable {
    set = "Spectral",
    key = "tauism",

    cost = 15,
    atlas = "main",
    pos = {x=2, y=5},
    soul_rate = 0.03,

    loc_txt = { 
        name = "Tauism",
        text = {
            "Converts the leftmost joker into a {C:cry_ember}Tauic{} joker",
            "{C:inactive,s:0.8}(If this spawned naturally, you have an applicable joker)",
            credit("Scraptake")
        }
    },

    can_use = function(self, card)
        return tauic_check()
    end,

    in_pool = function()
        return tauic_owned()
    end,

    use = function(self, card, area, copier) 

        if (#G.jokers.cards > 0) then
            local joker = select(2,next(G.jokers.cards))

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
    no_doe = true,
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
    no_doe = true,

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
    no_doe = true,
    calculate = function(self, card, context)
        if (context.individual and context.other_card and not context.end_of_round) then
            if (context.other_card:is_suit("Spades") or context.other_card:is_suit("Hearts") or context.other_card:is_suit("Clubs") or context.other_card:is_suit("Diamonds")) then
                return {e_chips = card.ability.extra.chips}
            end
        end
    end
}

SMODS.Joker {
    key = "tau_rocket",
    loc_txt = {
        name = "{C:cry_ember}Tauic Rocket{}",
        text = {
            "Earn {C:money}$#1#{} at end of round",
            "Multiply dollars earned by {X:money,C:white}$x#2#{} when {C:attention}Boss Blind{} defeated",
            "Gives {X:mult,C:white}Xmult{} equal to money",
            credit("Scraptake")
        }
    },
    config = { extra = { cur = 1, mult = 2} },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.cur, card.ability.extra.mult}}
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=3, y=1},
    cost = 4,
    no_doe = true,

    calc_dollar_bonus = function(self, card)
		return card.ability.extra.cur
	end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint and G.GAME.blind.boss then

            card.ability.extra.cur = card.ability.extra.cur * card.ability.extra.mult

        end

        if context.joker_main then
            return {x_mult = G.GAME.dollars}
        end

    end
}

SMODS.Joker {
    key = "tau_mime",
    loc_txt = {
        name = "{C:cry_ember}Tauic Mime{}",
        text = {
            "Retrigger all cards {C:attention}#1#{} times",
            "{C:inactive}Does not include held-in-hand effects{}",
            credit("Scraptake")
        }
    },
    config = { extra = { triggers = 5 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.triggers}}
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=4, y=1},
    cost = 4,
    no_doe = true,

    calculate = function(self, card, context)

		if context.repetition and context.cardarea == G.play then
            -- print("p.card")
			return {
				message = localize("k_again_ex"),
				repetitions = card.ability.extra.triggers,
				card = card,
			}
		end

    end
}

SMODS.Joker {
    key = "tau_obelisk",
    loc_txt = {
        name = "{C:cry_ember}Tauic Obelisk{}",
        text = {
            "Gains {X:mult,C:white}X#1#{} Mult per scored card if",
            "played hand is not your most played {C:attention}poker hand{}",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
            credit("Scraptake")
        }
    },
    config = { extra = { gain = 1, current = 1 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.gain, card.ability.extra.current}}
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=5, y=1},
    cost = 4,
    no_doe = true,

    calculate = function(self, card, context)

        if (context.before) then
            local play_more_than = (G.GAME.hands[context.scoring_name].played or 0)
            for k, v in pairs(G.GAME.hands) do
                if k ~= context.scoring_name and v.played >= play_more_than and v.visible then
                    card.ability.extra.current = card.ability.extra.current + card.ability.extra.gain
                end
            end

        end

        if (context.joker_main) then
            return {x_mult = card.ability.extra.current}
        end

    end
}

SMODS.Joker {
    key = "tau_cartomancer",
    loc_txt = {
        name = "{C:cry_ember}Tauic Cartomancer{}",
        text = {
            "{C:green}#1# in #2#{} chance to create a {C:tarot}tarot{} card when a {C:attention}consumable{} is used",
            "{C:inactive}(Mustn't have room){}",
            credit("Scraptake")
        }
    },
    config = { extra = { min = 1, prob = 2 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.min, card.ability.extra.prob}}
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=6, y=1},
    cost = 4,
    no_doe = true,

    calculate = function(self, card, context)

        if (context.using_consumeable and pseudorandom("tau_cartomancer", 1, card.ability.extra.prob) <= (card.ability.extra.min * G.GAME.probabilities.normal) ) then
            local tarot = create_card("Tarot", G.consumeables, nil, nil, nil, nil, nil, "tauic_cartomancer")
            tarot:add_to_deck()
            G.consumeables:emplace(tarot)
        end

    end
}

SMODS.Joker {
    key = "tau_satellite",
    loc_txt = {
        name = "{C:cry_ember}Tauic Satellite{}",
        text = {
            "Earn {C:money}$#1#{} at end of round",
            "Increases by {C:money}$#2#{} when planet card used",
            "Increases the increase by {C:money}$#3#{} when planet card used",
            credit("Scraptake")
        }
    },
    config = { extra = { cur = 1, inc = 1, incsq = 1 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.cur, card.ability.extra.inc, card.ability.extra.incsq}}
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=7, y=1},
    cost = 4,
    no_doe = true,

    calculate = function(self, card, context)

        if (context.using_consumeable) then

            local con = context.consumeable

            if (con.ability.set == "Planet") then 
            
                card.ability.extra.cur = card.ability.extra.cur + card.ability.extra.inc
                card.ability.extra.inc = card.ability.extra.inc + card.ability.extra.incsq

            end

        end

        -- select(2,next(G.consumeables.cards))

    end,

    calc_dollar_bonus = function(self, card)
		return card.ability.extra.cur
	end,


}

SMODS.Joker {
    key = "tau_oops",
    loc_txt = {
        name = "{C:cry_ember}Oops! All six point two eights!{}",
        text = {
            "Quadruples all {C:attention}listed{} {C:green}probabilities{}",
            "{C:green}#1# in #2#{} chance to earn {C:dark_edition}+#3#{} joker slot and {C:money}$#4#{} when {C:attention}consumable{} used",
            credit("Scraptake")
        }
    },
    config = { extra = { base = 1, chance = 40, slots = 1, money = 8 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.base * G.GAME.probabilities.normal, card.ability.extra.chance, card.ability.extra.slots, card.ability.extra.money}}
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=8, y=1},
    cost = 4,
    no_doe = true,

    add_to_deck = function(self, card, from_debuff)
        G.GAME.probabilities.normal = G.GAME.probabilities.normal * 4
    end,

    remove_from_deck = function(self, card, debuff)
        G.GAME.probabilities.normal = G.GAME.probabilities.normal / 4
    end,

    calculate = function(self, card, context)

        if (context.using_consumeable and pseudorandom("tau_oops", 1, card.ability.extra.chance) <= card.ability.extra.base * G.GAME.probabilities.normal ) then

            G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            ease_dollars(card.ability.extra.money)

        end

        -- select(2,next(G.consumeables.cards))

    end,

}

SMODS.Joker {
    key = "tau_troubadour",
    loc_txt = {
        name = "{C:cry_ember}Tauic Troubadour{}",
        text = {
            "{C:attention}+#1#{} hand size when card scored",
            "Convert hand size beyond {C:attention}#2#{} to consumable slots at a {C:attention}#3# : 1{} ratio",
            "Convert consumable slots beyond {C:attention}#2#{} to joker slots at a {C:attention}#3# : 1{} ratio",
            "Convert joker slots beyond {C:attention}#2#{} to shop slots at a {C:attention}#3# : 1{} ratio",
            credit("Scraptake")
        }
    },
    config = { extra = { max = 100, gain = 1, ratio = 5} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, card.ability.extra.max, card.ability.extra.ratio } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=9, y=1},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        
        if context.individual and context.cardarea == G.play then

            G.hand.config.card_limit = G.hand.config.card_limit + card.ability.extra.gain
            -- change_shop_size(center_table.extra)

            if (G.hand.config.card_limit > card.ability.extra.max) then
                G.hand.config.card_limit = G.hand.config.card_limit - card.ability.extra.ratio
                G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.gain
            end

            if (G.consumeables.config.card_limit > card.ability.extra.max) then
                G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.ratio
                G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.gain
            end

            if (G.jokers.config.card_limit > card.ability.extra.max) then
                G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.ratio
                change_shop_size(card.ability.extra.gain)
            end

        end

    end
}