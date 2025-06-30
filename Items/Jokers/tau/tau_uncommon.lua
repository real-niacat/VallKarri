
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

            if (context.consumeable.ability.set == "Planet") then 
            
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
    bases = {"j_mime"},
    key = "tau_mime",
    loc_txt = {
        name = "{C:cry_ember}Tauic Mime{}",
        text = {
            "Retrigger all playing cards {C:attention}#1#{} times",
            credit("Scraptake")
        }
    },
    config = { extra = { triggers = 3 } },
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

		if context.repetition and context.cardarea == G.play or (context.cardarea == G.hand and context.card_effects and (next(context.card_effects[1]) or #context.card_effects > 1)) then
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
    bases = {"j_steel_joker"},
    key = "tau_steel_joker",
    loc_txt = {
        name = "{C:cry_ember}Tauic Steel Joker{}",
        text = {
            "{X:dark_edition,C:white}+^#1#{} Mult for each {C:attention}Steel card{} in deck",
            "{C:inactive}(Currently {X:dark_edition,C:white}^#2#{C:inactive} Mult)",
            credit("Scraptake")
        }
    },
    config = { extra = { gain = 0.15 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_steel


        return {vars = {card.ability.extra.gain, 1+(card.ability.extra.gain*enhanced_in_deck("m_steel"))}}
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=7, y=3},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)

		if context.joker_main then
            return {
                emult = 1+(card.ability.extra.gain*enhanced_in_deck("m_steel"))
            }
        end

    end
}