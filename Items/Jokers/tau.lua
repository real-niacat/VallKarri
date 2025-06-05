tauics = {
    {base = "j_joker",  tau = "j_valk_tau_joker"},
    {base = "j_lusty_joker",  tau = "j_valk_tau_sins"},
    {base = "j_greedy_joker",  tau = "j_valk_tau_sins"},
    {base = "j_wrathful_joker",  tau = "j_valk_tau_sins"},
    {base = "j_gluttenous_joker",  tau = "j_valk_tau_sins"},

    {base = "j_jolly_joker",  tau = "j_valk_tau_emotion"},
    {base = "j_zany_joker",  tau = "j_valk_tau_emotion"},
    {base = "j_mad_joker",  tau = "j_valk_tau_emotion"},
    {base = "j_crazy_joker",  tau = "j_valk_tau_emotion"},
    {base = "j_droll_joker",  tau = "j_valk_tau_emotion"},
    {base = "j_sly_joker",  tau = "j_valk_tau_emotion"},
    {base = "j_wily_joker",  tau = "j_valk_tau_emotion"},
    {base = "j_clever_joker",  tau = "j_valk_tau_emotion"},
    {base = "j_devious_joker",  tau = "j_valk_tau_emotion"},
    {base = "j_crafty_joker",  tau = "j_valk_tau_emotion"},
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

legendary_tauics = {
    {base = "j_canio", tau = "j_valk_tau_canio"},
    {base = "j_triboulet", tau = "j_valk_tau_triboulet"},
    {base = "j_yorick", tau = "j_valk_tau_yorick"},
    {base = "j_chicot", tau = "j_valk_tau_chicot"},
    {base = "j_perkeo", tau = "j_valk_tau_perkeo"},
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
    -- is_soul = true,
    soul_rate = 0.12,

    loc_txt = { 
        name = "Tauism",
        text = {
            "Converts the leftmost joker applicable joker into a {C:cry_ember}Tauic{} joker",
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

        for i,joker in ipairs(G.jokers.cards) do

            for j,tauic in ipairs(tauics) do

                if (joker.config.center_key == tauic.base) then
                    joker:set_ability(G.P_CENTERS[tauic.tau])
                    return
                end

            end

            

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

SMODS.Joker {
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
            "{X:mult,C:white}^#1#{} Mult when any face card or Ace is scored",
            "Increases by {X:mult,C:white}+^#2#{} when any face card or Ace is scored",
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
            "{X:mult,C:white}^#1#{} Mult",
            "Increases by {X:mult,C:white}+^#2#{} when any card discarded",
            "Scales {C:attention}Quadratically{}",
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
                card_eval_status_text(self, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled')})
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
            "Create {C:attention}#1#{} copies of a random consumable when exiting shop",
            "Remove {C:dark_edition}negative{} from {C:attention}#2#{} random consumable at end of round",
            credit("Scraptake")
        }
    },
    config = { extra = { copies = 2, reverse = 1} },
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
            
            
            
            if G.consumeables.cards[1] then
                for i = 1, card.ability.extra.copies do
                    G.E_MANAGER:add_event(Event({
                        func = function() 
                            local total, checked, center = 0, 0, nil
                            for i = 1, #G.consumeables.cards do
                                total = total + 1
                            end
                            local poll = pseudorandom(pseudoseed('tau_perkeo')) * total
                            for i = 1, #G.consumeables.cards do
                                checked = checked + 1
                                if checked >= poll then
                                    center = G.consumeables.cards[i]
                                    break
                                end
                            end
                            local copied_card = copy_card(center, nil)
                            if (copied_card.ability.qty) then
                                copied_card.ability.qty = 1
                                copied_card.ability.infinite = nil
                            end
                            copied_card:set_edition({negative = true}, true)
                            copied_card:add_to_deck()
                            G.consumeables:emplace(copied_card) 
                            return true
                        end
                    }))
                end
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('k_duplicated_ex')})
                -- return {calculated = true}
            end

        end

        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then

            if G.consumeables.cards[1] then
                G.E_MANAGER:add_event(Event({
                    func = function() 
                        local total, checked, center = 0, 0, nil
                        for i = 1, #G.consumeables.cards do
                            total = total + 1
                        end
                        local poll = pseudorandom(pseudoseed('tau_perkeo')) * total
                        for i = 1, #G.consumeables.cards do
                            checked = checked + 1
                            if checked >= poll and G.consumeables.cards[i].edition then
                                center = G.consumeables.cards[i]
                                break
                            end
                        end
                        if (center) then 
                            center:set_edition({negative = false}, true)
                        end
                        return true
                    end
                }))
                -- return {calculated = true}
            end
            
        end

    end
}