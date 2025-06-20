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

        if joker.config.center.key:find("tau_") then
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
            "{C:attention}Jokers{} may be replaced by their {C:cry_ember}Tauic{} variants",
            "{C:inactive}Chance increases when it fails, resets when it succeeds{}",
            "{C:inactive}(Currently a {C:green}#1#%{C:inactive} chance to replace)",
            credit("Scraptake")
        }
    },
    config = { extra = { } },
    loc_vars = function(self, info_queue, card)
        local c = 100
        if G.GAME and G.GAME.tau_replace then
            c = G.GAME.tau_replace
        end
        return { vars = { 100 * (1 / c) } }
    end,
    rarity = 3,
    atlas = "main",
    pos = {x=8, y=4},
    soul_pos = {x=8, y=8, extra = {x=9, y=4}},
    cost = 12,
    calculate = function(self, card, context)
        
    end
}

SMODS.Consumable {
    set = "Spectral",
    key = "absolutetau",

    cost = 150,
    atlas = "main",
    pos = {x=3, y=5},
    -- is_soul = true,
    soul_rate = 0.0000,

    loc_txt = { 
        name = "Absolute Tau",
        text = {
            "Create a random {C:cry_ember}Tauic{} {C:legendary}Legendary{}",
            credit("Scraptake")
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

    end



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





SMODS.Joker {
    bases = {"j_joker"},
    key = "tau_joker",
    loc_txt = {
        name = "{C:cry_ember}Tauic Joker{}",
        text = {
            "{X:dark_edition,C:white}^#1#{} Mult for every Tauic card",
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
    bases = {"j_chaos"},
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
    bases = {"j_lusty_joker", "j_greedy_joker", "j_wrathful_joker", "j_gluttenous_joker"},
    key = "tau_sins",
    loc_txt = {
        name = "{C:cry_ember}Tauic Sin Joker{}",
        text = {
            "{X:dark_edition,C:white}^#1#{} Chips for every card with a suit scored, in hand or in deck",
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
    bases = {"j_rocket"},
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
    bases = {"j_mime"},
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
    bases = {"j_obelisk"},
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
    bases = {"j_cartomancer"},
    key = "tau_cartomancer",
    loc_txt = {
        name = "{C:cry_ember}Tauic Cartomancer{}",
        text = {
            "{C:green}#1# in #2#{} chance to create a {C:tarot}tarot{} card when a {C:attention}consumable{} is used",
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
    bases = {"j_satellite"},
    key = "tau_satellite",
    loc_txt = {
        name = "{C:cry_ember}Tauic Satellite{}",
        text = {
            "Earn {C:money}$#1#{} at end of round",
            "Increases by {C:money}$#2#{} when planet card used",
            "Scales {C:dark_edition,E:1}Quadratically{}",
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
    bases = {"j_oops"},
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
    bases = {"j_half"},
    key = "tau_half",
    loc_txt = {
        name = "{C:cry_ember}Tauic Half Joker{}",
        text = {
            "At end of round, multiply all {C:attention}joker values{}",
            "by amount of {C:attention}empty joker slots{}",
            credit("Scraptake")
        }
    },
    config = { extra = { } },
    loc_vars = function(self, info_queue, card)
        return { vars = {  } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=1, y=2},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        if
			context.end_of_round
			and not context.blueprint
			and not context.individual
			and not context.repetition
			and not context.retrigger_joker then

            local n = G.jokers.config.card_limit - #G.jokers.cards
            for i,joker in ipairs(G.jokers.cards) do
                Cryptid.misprintize(joker, {min=n,max=n},false, true )
            end
        end
    end
}

SMODS.Joker {
    bases = {"j_troubadour"},
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

            -- oops? why the FUCK
            if (to_big(G.hand.config.card_limit) > to_big(card.ability.extra.max)) then
                G.hand.config.card_limit = G.hand.config.card_limit - card.ability.extra.ratio
                G.consumeables.config.card_limit = G.consumeables.config.card_limit + card.ability.extra.gain
            end

            if (to_big(G.consumeables.config.card_limit) > to_big(card.ability.extra.max)) then
                G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.ratio
                G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.gain
            end

            if (to_big(G.jokers.config.card_limit) > to_big(card.ability.extra.max)) then
                G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.ratio
                change_shop_size(card.ability.extra.gain)
            end

        end

    end
}

SMODS.Joker {
    bases = {"j_jolly", "j_zany", "j_mad", "j_crazy" ,"j_droll",
            "j_sly", "j_wily", "j_clever", "j_devious", "j_crafty"},
    key = "tau_emotion",
    loc_txt = {
        name = "{C:cry_ember}Tauic Emotional Joker{}",
        text = {
            "{X:dark_edition,C:white}+^#1#{} Chips & Mult per {C:attention}poker hand{} contained in played hand",
            credit("Scraptake")
        }
    },
    config = { extra = { gain = 1} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=1, y=0},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        
        if (context.poker_hands) then
            local count = 0
            
            for i,hand in pairs(context.poker_hands) do
                
                if (hand and next(hand) ~= nil) then
                    -- print(hand)
                    count = count + 1
                end
            end


            if (context.joker_main) then
                return {e_mult = 1 + (card.ability.extra.gain * count), e_chips = 1 + (card.ability.extra.gain * count)}
            end
        end

    end
}

SMODS.Joker {
    bases = {"j_ceremonial"},
    key = "tau_dagger",
    loc_txt = {
        name = "{C:cry_ember}Tauic Ceremonial Dagger{}",
        text = {
            "When {C:attention}blind{} selected, {C:red,E:1}destroy{} joker to the right and",
            "added its sell value to this jokers {X:dark_edition,C:white}^Mult{}",
            "{C:inactive}(Currently {X:dark_edition,C:white}^#1#{C:inactive} Mult)",
            credit("Scraptake")
        }
    },
    config = { extra = { mult = 1 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=5, y=5},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        
        if context.setting_blind and #G.jokers.cards then

            local my_pos = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then my_pos = i; break end
            end
            if my_pos and G.jokers.cards[my_pos+1] and not card.getting_sliced and not G.jokers.cards[my_pos+1].ability.eternal and not G.jokers.cards[my_pos+1].getting_sliced then 
                    local sliced_card = G.jokers.cards[my_pos+1]
                    if sliced_card.config.center.rarity == "cry_exotic" then check_for_unlock({type = "what_have_you_done"}) end
                    sliced_card.getting_sliced = true
                    G.GAME.joker_buffer = G.GAME.joker_buffer - 1
                    G.E_MANAGER:add_event(Event({func = function()
                        G.GAME.joker_buffer = 0
                        card.ability.extra.mult = card.ability.extra.mult + sliced_card.sell_cost
                        card:juice_up(0.8, 0.8)
                        sliced_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                        play_sound('slice1', 0.96+math.random()*0.08)
                    return true end }))
                    card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize{type = 'variable', key = 'a_mult', vars = {card.ability.mult+sliced_card.sell_cost}}, colour = G.C.RED, no_juice = true})
                    return nil, true
                end

        end

        if context.joker_main then
            return {emult = card.ability.extra.mult}
        end

    end
}

SMODS.Joker {
    bases = {"j_credit_card"},
    key = "tau_creditcard",
    loc_txt = {
        name = "{C:cry_ember}Tauic Credit Card{}",
        text = {
            "Refund {C:attention}#1#%{} of all money spent",
            credit("Lily")
        }
    },
    config = { immutable = {refund = 75} }, --value is pointless, it's always a 3/4 refund
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.immutable.refund } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=9, y=0},
    cost = 4,
    no_doe = true,
}

SMODS.Joker {
    bases = {"j_four_fingers"},
    key = "tau_fingers",
    loc_txt = {
        name = "{C:cry_ember}Tauic Four Fingers{}",
        text = {
            "{C:attention}Flushes{} and {C:attention}Straights{} can be made with {C:attention}3{} cards", --booo hardcoding. whatever. go complain to smods.
            "Level up all hands by {C:attention}#1#{} when consumable used",
            "Increases {C:dark_edition,E:1}Quadratically{}",
            credit("Scraptake")
        }
    },
    config = { extra = { levels = 1, inc = 1} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.levels } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=6, y=6},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        
        if context.using_consumeable then

            level_all_hands(context.consumeable, card.ability.extra.levels)
            card.ability.extra.levels = card.ability.extra.levels + card.ability.extra.inc
            
        end

    end
}

SMODS.Joker {
    bases = {"j_stencil"},
    key = "tau_stencil",
    loc_txt = {
        name = "{C:cry_ember}Tauic Joker Stencil{}",
        text = {
            "{C:attention}+#1#{} Joker slots, double this value when joker sold",
            "Gives {X:mult,C:white}Xmult{} equal to total joker slots",
            "{C:inactive}(Caps at {C:attention}+#2#{C:inactive} Joker Slots){}",
            credit("Scraptake")
        }
    },
    config = { extra = { slots = 2 }, immutable = {cap = 1e100} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.slots, card.ability.immutable.cap } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=2, y=5},
    cost = 4,
    no_doe = true,

    add_to_deck = function(self ,card, from_debuff)
        G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
    end,

    calculate = function(self, card, context)
        
        if context.selling_card and context.card and context.card.ability.set == "Joker" then
            local new = card.ability.extra.slots * 2
            if to_big(new) > to_big(card.ability.immutable.cap) then
                new = card.ability.extra.slots
            end
            G.jokers.config.card_limit = to_number(G.jokers.config.card_limit + (new) - card.ability.extra.slots)
            card.ability.extra.slots = new
            card_eval_status_text(card, 'extra', nil, nil, nil, {message = "Upgraded!"})
        end

        if (context.joker_main) then
            return {x_mult = G.jokers.config.card_limit}
        end

    end
}


SMODS.Joker {
    bases = {"j_banner"},
    key = "tau_banner",
    loc_txt = {
        name = "{C:cry_ember}Tauic Banner{}",
        text = {
            "{X:dark_edition,C:white}+^#1#{} Chips per discard remaining",
            "{C:inactive}(Currently {X:dark_edition,C:white}^#2#{C:inactive} Chips)",
            credit("Scraptake")
        }
    },
    config = { extra = { per = 2 } },
    loc_vars = function(self, info_queue, card)
        local d = 4
        if G and G.GAME and G.GAME.current_round then
            d = G.GAME.current_round.discards_left
        end
        return { vars = { card.ability.extra.per, 1 + (card.ability.extra.per * d) } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=8, y=2},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        
        if context.joker_main then

            return {echips = 1 + (card.ability.extra.per * G.GAME.current_round.discards_left)}

        end

    end
}

SMODS.Joker {
    bases = {"j_mystic_summit"},
    key = "tau_summit",
    loc_txt = {
        name = "{C:cry_ember}Tauic Summit{}",
        text = {
            "When {C:red}discarding{}, multiply all hand levels by the {C:attention}square root{}",
            "of discards remaining",
            credit("Scraptake")
        }
    },
    config = { extra = {  } },
    loc_vars = function(self, info_queue, card)

        return { vars = {  } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=2, y=0},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        
        if context.pre_discard then

            level_all_hands(card, 0, math.sqrt(G.GAME.current_round.discards_left) - 1)
        end

    end
}

SMODS.Joker {
    bases = {"j_marble"},
    key = "tau_marble",
    loc_txt = {
        name = "{C:cry_ember}Tauic Marble Joker{}",
        text = {
            "All scored cards are converted into {C:attention}stone{} cards",
            "{C:attention}Stone{} cards give {X:chips,C:white}X#1#{} Chips when scored",
            credit("Scraptake")
        }
    },
    config = { extra = { xchip = 4.2 } },
    loc_vars = function(self, info_queue, card)

        return { vars = { card.ability.extra.xchip } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=3, y=0},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        
        if context.before then

            for i,c in ipairs(context.scoring_hand) do
                c:set_ability("m_stone")
            end

        end

        if context.individual and context.cardarea == G.play then
            local en = SMODS.get_enhancements(context.other_card)
            if en and en.m_stone then
                return {xchips = card.ability.extra.xchip}
            end

        end

    end
}

SMODS.Joker {
    bases = {"j_loyalty_card"},
    key = "tau_loyalty",
    loc_txt = {
        name = "{C:cry_ember}Tauic Loyalty Card{}",
        text = {
            "{C:attention}Double{} this jokers {{X:dark_edition,C:white}^Mult{} every {C:attention}#1#{} {C:inactive}[#2#]{} hands played",
            "{C:inactive}(Currently {X:dark_edition,C:white}^#3#{C:inactive} Mult)",
            credit("Scraptake")
        }
    },
    config = { extra = { emult = 1}, immutable = { hands = 6, req = 6 } },
    loc_vars = function(self, info_queue, card)

        return { vars = { card.ability.immutable.req, card.ability.immutable.hands, card.ability.extra.emult } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=7, y=2},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        
        if context.before and not context.blueprint then

            card.ability.immutable.hands = card.ability.immutable.hands - 1
            if card.ability.immutable.hands < 1 then
                card.ability.immutable.hands = card.ability.immutable.req
                quick_misprintize(card, 2)
                -- self misprintizing! how could this ever go wrong!
            end

        end

        if context.joker_main then
            return {emult = card.ability.extra.emult}
        end

    end
}

SMODS.Joker {
    bases = {"j_egg"},
    key = "tau_egg",
    loc_txt = {
        name = "{C:cry_ember}Tauic Egg{}",
        text = {
            "Gains {X:dark_edition,C:white}^#1#{} of {C:attention}sell value{} at end of round",
            credit("Scraptake")
        }
    },
    config = { extra = { evalue = 1.5 } },
    loc_vars = function(self, info_queue, card)

        return { vars = { card.ability.extra.evalue } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=0, y=10},
    cost = 6,
    no_doe = true,
    calculate = function(self, card, context)
        
        if context.end_of_round and context.main_eval then
            quick_card_speak(card, "Upgraded!")
            card.sell_cost = math.ceil(card.sell_cost ^ card.ability.extra.evalue)
        end

    end
}

SMODS.Joker {
    bases = {"j_even_steven", "j_odd_todd"},
    key = "tau_brothers",
    loc_txt = {
        name = "{C:cry_ember}Tauic Number Brothers{}",
        text = {
            "All scored number cards give {X:mult,C:white}XMult{}",
            "equal to their rank",
            credit("Scraptake")
        }
    },
    config = { extra = { } },
    loc_vars = function(self, info_queue, card)

    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=8, y=4},
    cost = 6,
    no_doe = true,
    calculate = function(self, card, context)
        
        if context.individual and context.cardarea == G.play and context.other_card.base.id <= 10 then
            return {
                xmult = context.other_card.base.id
            }
        end

    end
}

SMODS.Joker {
    bases = {"j_blue_joker"},
    key = "tau_blue",
    loc_txt = {
        name = "{C:cry_ember}Tauic Blue Joker{}",
        text = {
            "{X:dark_edition,C:white}+^#1#{} Chips for each",
            "remaining card in {C:attention}deck{}",
            "{C:inactive}(Currently {X:dark_edition,C:white}^#2#{C:inactive} Chips)",
            credit("Scraptake")
        }
    },
    config = { extra = { per = 0.15 } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.per,
                card.ability.extra.per * #G.deck.cards
            }
        }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=7, y=10},
    cost = 6,
    no_doe = true,
    calculate = function(self, card, context)
        
        if context.joker_main then
            return {
                echips = card.ability.extra.per * #G.deck.cards
            }
        end

    end
}


SMODS.Joker {
    key = "tau_canio",
    loc_txt = {
        name = "{C:cry_ember}Tauic Canio{}",
        text = {
            "{X:dark_edition,C:white}+^^#1#{} Mult when any card destroyed",
            "{C:inactive}Currently {X:dark_edition,C:white}^^#2#{C:inactive} Mult){}",
            credit("Scraptake")
        }
    },
    config = { extra = { gain = 0.2, cur = 1} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, card.ability.extra.cur } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=3, y=9, extra = {x=3, y=8}},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        
        if (context.remove_playing_cards) then

            card.ability.extra.cur = card.ability.extra.cur + (card.ability.extra.gain * #context.removed)

        end

        if (context.joker_main) then
            return {ee_mult = card.ability.extra.cur}
        end

    end
}

SMODS.Joker {
    key = "tau_triboulet",
    loc_txt = {
        name = "{C:cry_ember}Tauic Triboulet{}",
        text = {
            "{X:dark_edition,C:white}^#1#{} Mult when any face card or Ace is scored",
            "Increases by {X:dark_edition,C:white}+^#2#{} when any face card or Ace is scored",
            credit("Scraptake")
        }
    },
    config = { extra = { gain = 0.02, cur = 1} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cur, card.ability.extra.gain } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=4, y=9, extra = {x=4, y=8}},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        
        if (context.individual and context.cardarea == G.play and context.other_card:get_id() >= 11) then

            card.ability.extra.cur = card.ability.extra.cur + card.ability.extra.gain
            return {e_mult = card.ability.extra.cur}

        end

    end
}

SMODS.Joker {
    key = "tau_yorick",
    loc_txt = {
        name = "{C:cry_ember}Tauic Yorick{}",
        text = {
            "{X:dark_edition,C:white}^#1#{} Mult",
            "Increases by {X:dark_edition,C:white}+^#2#{} when any card discarded",
            "Scales {C:dark_edition,E:1}Quadratically{}",
            credit("Scraptake")
        }
    },
    config = { extra = { gainsq = 0.02, gain = 0.02, cur = 1} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cur, card.ability.extra.gain } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=5, y=9, extra = {x=5, y=8}},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        
        if (context.discard) then

            card.ability.extra.cur = card.ability.extra.cur + card.ability.extra.gain
            card.ability.extra.gain = card.ability.extra.gain + card.ability.extra.gainsq

        end

        if (context.joker_main) then
            return {e_mult = card.ability.extra.cur}
        end

    end
}

SMODS.Joker {
    key = "tau_chicot",
    loc_txt = {
        name = "{C:cry_ember}Tauic Chicot{}",
        text = {
            "Disables effect of every {C:attention}Boss Blind{}",
            "{X:dark_edition,C:white}^^(1 / #1#){} blind size",
            "{C:inactive}(Ineffective at large blind sizes)",
            credit("Scraptake")
        }
    },
    config = { extra = { antitetration = 50} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.antitetration } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=6, y=9, extra = {x=6, y=8}},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        

        if context.setting_blind then
            

            if G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
                G.GAME.blind:disable()
                play_sound('timpani')
                card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
            end

            G.GAME.blind.chips = to_big(G.GAME.blind.chips):arrow(2, 1 / card.ability.extra.antitetration)
            G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
            G.HUD_blind:recalculate()

        end

    end
}

SMODS.Joker {
    key = "tau_perkeo",
    loc_txt = {
        name = "{C:cry_ember}Tauic Perkeo{}",
        text = {
            "Create {C:attention}#1#{} {C:dark_edition}negative{} copies of the leftmost consumable when exiting shop",
            "Remove {C:dark_edition}negative{} from rightmost consumable at end of round",
            credit("Scraptake")
        }
    },
    config = { extra = { copies = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.copies, card.ability.extra.reverse } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=7, y=9, extra = {x=7, y=8}},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        

        if context.ending_shop then
            
            
            if (#G.consumeables.cards > 0) then

                for i=1,card.ability.extra.copies do
                    local copy = copy_card(G.consumeables.cards[1])
                    copy:set_edition("e_negative", true)
                    G.consumeables:emplace(copy)
                end

            end
            

        end

        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then

            if (#G.consumeables.cards > 0) then

                G.consumeables.cards[#G.consumeables.cards]:set_edition("e_base", true)

            end
            
        end

    end
}