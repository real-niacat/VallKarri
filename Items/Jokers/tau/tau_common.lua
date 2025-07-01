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
        local n = 52
        if G.deck then
            n = #G.deck.cards
        end
        return {
            vars = {
                card.ability.extra.per,
                card.ability.extra.per * n
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
    bases = {"j_mystic_summit"},
    key = "tau_summit",
    loc_txt = {
        name = "{C:cry_ember}Tauic Summit{}",
        text = {
            "When {C:red}discarding{}, multiply all hand levels by the amount",
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

            level_all_hands(card, 0, G.GAME.current_round.discards_left)
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
    bases = {"j_jolly", "j_zany", "j_mad", "j_crazy" ,"j_droll",
            "j_sly", "j_wily", "j_clever", "j_devious", "j_crafty"},
    key = "tau_emotion",
    loc_txt = {
        name = "{C:cry_ember}Tauic Emotional Joker{}",
        text = {
            "{X:dark_edition,C:white}^#1#{} Chips & Mult per {C:attention}poker hand{} contained in played hand",
            credit("Scraptake")
        }
    },
    config = { extra = { gain = 2} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=1, y=0},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
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
                local amount = 2 ^ count
                return {e_mult = amount, e_chips = amount}
            end
        end

    end
}

SMODS.Joker {
    bases = {"j_half"},
    key = "tau_half",
    loc_txt = {
        name = "{C:cry_ember}Tauic Half Joker{}",
        text = {
            "At end of round, multiply all {C:attention}Joker values{}",
            "by amount of {C:attention}empty Joker slots{}",
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
        if context.end_of_round and context.main_eval then

            local n = G.jokers.config.card_limit - #G.jokers.cards
            for i,joker in ipairs(G.jokers.cards) do
                Cryptid.misprintize(joker, {min=n,max=n},false, true )
            end
        end
    end
}

SMODS.Joker {
    bases = {"j_8_ball"},
    key = "tau_8_ball",
    loc_txt = {
        name = "{C:cry_ember}Tauic 8 Ball{}",
        text = {
            "When an {C:attention}8{} is scored, create a random {C:attention}tarot{} card",
            "with {C:attention}X#1#{} values",
            credit("Scraptake")
        }
    },
    config = { extra = { vmult = 8 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.vmult } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=0, y=5},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.base.id == 8 and #G.consumeables.cards < G.consumeables.config.card_limit then
            local tarot = create_card("Tarot", G.consumeables, nil, nil, nil, nil, nil, "valk_tau_8ball")
            tarot:add_to_deck()
            G.consumeables:emplace(tarot)
            Cryptid.manipulate(tarot, {value = card.ability.extra.vmult})
        end
    end
}

SMODS.Joker {
    bases = {"j_smiley"},
    key = "tau_smiley",
    loc_txt = {
        name = "{C:cry_ember}Tauic Smiley Face{}",
        text = {
            "{C:attention}Non-face{} cards are converted into a random {C:attention}face{} card when {C:attention}scored{}",
            "{C:attention}Face{} cards give {X:dark_edition,C:white}^#1#{} Mult",
            credit("Scraptake")
        }
    },
    config = { extra = { emult = 1.55 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.emult } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=6, y=15},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            
            if not context.other_card:is_face() then
                local faces = {"Jack", "King", "Queen"}
                SMODS.change_base(context.other_card, nil, faces[pseudorandom("valk_tau_smiley", 1, #faces)])
            else    
                return {
                    emult = card.ability.extra.emult,
                    card = card
                }
            end

        end
    end
}

SMODS.Joker {
    bases = {"j_gros_michel"},
    key = "tau_gros_michel",
    loc_txt = {
        name = "{C:cry_ember}Tauic Gros Michel{}",
        text = {
            "{X:mult,C:white}X#1#{} Mult",
            "{C:green}#2# in #3#{} chance to convert into {C:cry_ember}Tauic Cavendish{} at end of round",
            credit("Scraptake")
        }
    },
    config = { extra = { xmult = 15, outof = 15 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult, G.GAME.probabilities.normal, card.ability.extra.outof } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=7, y=6},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end

        if context.end_of_round and context.main_eval and pseudorandom("valk_tau_michel", 1, card.ability.extra.outof) <= G.GAME.probabilities.normal then
            card:set_ability("j_valk_tau_cavendish")
        end
    end
}

SMODS.Joker {
    bases = {"j_cavendish"},
    key = "tau_cavendish",
    loc_txt = {
        name = "{C:cry_ember}Tauic Cavendish{}",
        text = {
            "{X:dark_edition,C:white}^#1#{} Mult",
            "{C:green}#2# in #3#{} chance to",
            credit("Scraptake")
        }
    },
    config = { extra = { emult = 3.33, outof = 1000 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.emult, G.GAME.probabilities.normal, card.ability.extra.outof } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=5, y=11},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                emult = card.ability.extra.emult
            }
        end
    end
}

SMODS.Joker {
    bases = {"j_delayed_grat"},
    key = "tau_delayed_grat",
    loc_txt = {
        name = "{C:cry_ember}Tauic Delayed Gratification{}",
        text = {
            "At end of round, multiply your money by remaining {C:red}discards{}",
            credit("Scraptake")
        }
    },
    config = { extra = { } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.emult, G.GAME.probabilities.normal, card.ability.extra.outof } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=4, y=3},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and not context.blueprint then
            local mult = math.max(1, G.GAME.current_round.discards_left)
            ease_dollars(G.GAME.dollars*(mult-1))

        end
    end
}

SMODS.Joker {
    bases = {"j_hanging_chad"},
    key = "tau_hanging_chad",
    loc_txt = {
        name = "{C:cry_ember}Tauic Hanging Chad{}",
        text = {
            "Retrigger the {C:attention}first{} played card {C:attention}once{} for each card played",
            credit("Scraptake")
        }
    },
    config = { extra = { } },
    loc_vars = function(self, info_queue, card)
        return { vars = { } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=9, y=6},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play and context.other_card == G.play.cards[1] then
            return {
                repetitions = #G.play.cards,
                message = localize("k_again_ex"),
				card = card,
            }
        end
    end
}

SMODS.Joker {
    bases = {"j_misprint"},
    key = "tau_misprint",
    loc_txt = {
        name = "{C:cry_ember}Tauic Misprint{}",
        text = {
            "{X:dark_edition,C:white}#1##2#{}#3#",
            credit("Scraptake")
        }
    },
    immutable = true,
    config = { extra = {min = 105, max = 113 } },
    loc_vars = function(self, info_queue, card)
        local text = corrupt_text("^^1.", 0.2)
        local text1 = corrupt_text("xxx", 1, "01234567890123456789012345678901234567890123456789!@#$%^&*()-_=+[];:',.<>/?|")
        local text2 = corrupt_text(" Mult", 0.2)
        return { vars = { text, text1, text2 } }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=6, y=3},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            local temp_Mult = pseudorandom('tau misprint',card.ability.extra.min, card.ability.extra.max)/100
            return {
                EEmult_mod = temp_Mult,
				message =  '^^' .. number_format(temp_Mult) .. ' Mult',
				colour = { 0.8, 0.45, 0.85, 1 },
                
            }
        end
    end
}


SMODS.Joker {
    bases = {"j_photograph"},
    key = "tau_photograph",
    loc_txt = {
        name = "{C:cry_ember}Tauic Photograph{}",
        text = {
            "The first scored {C:attention}face{} card gives",
            "{X:dark_edition,C:white}^^1+([CardsPlayed]/100){} Mult",
            credit("Scraptake")
        }
    },
    immutable = true,
    config = { extra = {min = 105, max = 113 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=2, y=13},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if (context.individual and context.cardarea == G.play) then
            local first_face = nil
            for i = 1, #context.scoring_hand do
                if context.scoring_hand[i]:is_face() then first_face = context.scoring_hand[i]; break end
            end
            if context.other_card == first_face then
                photo_mult = 1 + ((#G.play.cards)/100)
                return {eemult = photo_mult}
            end
        end
    end
}


SMODS.Joker {
    bases = {"j_ice_cream"},
    key = "tau_ice_cream",
    loc_txt = {
        name = "{C:cry_ember}Tauic Ice Cream{}",
        text = {
            "{X:dark_edition,C:white}^#1#{} Chips",
            "{X:dark_edition,C:white}+^#2#{} per hand played",
            credit("Scraptake")
        }
    },
    immutable = true,
    config = { extra = {cur = 1, gain = 0.25 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.cur, card.ability.extra.gain} }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    pos = {x=0, y=0},
    soul_pos = {x=4, y=10},
    cost = 4,
    no_doe = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.after and context.main_eval then
            card.ability.extra.cur = card.ability.extra.cur + card.ability.extra.gain
            quick_card_speak(card, "Upgraded!")
        end

        if context.joker_main then
            return {
                echips = card.ability.extra.cur
            }
        end
    end
}

SMODS.Joker {
    bases = {"j_ride_the_bus"},
    key = "tau_ride_the_bus",
    loc_txt = {
        name = "{C:cry_ember}Tauic Ride the Bus{}",
        text = {
            "Non {C:attention}face{} cards give",
            "{X:dark_edition,C:white}^#1#{} Mult",
            credit("Scraptake")
        }
    },
    config = { extra = {powmult = 1.25 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.powmult} }
    end,
    rarity = "valk_tauic",
    atlas = "tau",
    blueprint_compat = true,
    pos = {x=0, y=0},
    soul_pos = {x=1, y=6},
    cost = 4,
    no_doe = true,
    calculate = function(self, card, context)
        if (context.individual and context.cardarea == G.play) then
            if not context.other_card:is_face() then
                return {emult = card.ability.extra.powmult }
            end
        end
    end
}
