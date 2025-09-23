SMODS.Joker {
    key = "niko",
    loc_txt = {
        name = "Niko Gray",
        text = {
            "When blind selected, {C:red}debuff{} leftmost Joker and {C:attention}double{} its values",
            "Remove {C:red}debuff{} from all Jokers at end of round",
            quote("niko"),
            credit("Scraptake")
        }
    },
    config = { extra = { saved_joker = nil } },
    loc_vars = function(self, info_queue, card)

    end,
    rarity = 4,
    atlas = "main",
    pools = { ["Kitties"] = true },
    pos = { x = 0, y = 4 },
    soul_pos = { x = 1, y = 4 },
    cost = 20,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if (context.setting_blind) then
            if G.jokers.cards[1] and G.jokers.cards[1].config.center.key ~= "j_valk_niko" then
                G.jokers.cards[1].debuff = true
                Cryptid.manipulate(G.jokers.cards[1], { type = "X", value = 2 }) --oh no! hardcoding!
            end
        end

        if (context.end_of_round and context.main_eval) then
            for i, joker in ipairs(G.jokers.cards) do
                joker.debuff = false
            end
        end
    end
}

SMODS.Joker {
    key = "hornet",
    -- feb 14th 2019
    -- it's out!
    loc_txt = {
        name = "Hornet",
        text = {
            "{X:dark_edition,C:white}^#1#{} Mult for every day since {C:attention}Hollow Knight Silksong{} was released",
            "{C:inactive}(Currently {X:dark_edition,C:white}^#2#{C:inactive} Mult)",
            quote("hornet"),
            credit("Scraptake"),
        }
    },
    config = { extra = { gain = 0.05 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, 1 + (card.ability.extra.gain * days_since(2025, 9, 4)) } }
    end,
    rarity = 4,
    atlas = "main",
    pos = { x = 5, y = 0 },
    soul_pos = { x = 6, y = 0 },
    cost = 20,
    demicoloncompat = true,
    calculate = function(self, card, context)
        if (context.joker_main) or context.forcetrigger then
            return { emult = 1 + (card.ability.extra.gain * days_since(2025, 9, 4)) }
        end
    end

}

SMODS.Joker {
    key = "lilac",
    loc_txt = {
        name = "Lilac Lilybean",
        text = {
            "Creates a random {C:dark_edition}Negative{} {C:attention}Food Joker{} at end of round.",
            "When boss blind defeated, Increase ",
            "{C:attention}sell value{} of all Food Jokers by {C:attention}X#1#{}.",
            quote("lilac"),
            credit("Scraptake")
        }
    },
    config = { extra = { money = 5.4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    rarity = 4,
    pools = { ["Kitties"] = true },
    atlas = "main",
    pos = { x = 0, y = 7 },
    soul_pos = { x = 1, y = 7 },
    cost = 20,
    calculate = function(self, card, context)
        if (context.end_of_round and not context.repetition and not context.individual and not context.blueprint) then
            local c = create_card("Food", G.jokers, nil, nil, nil, nil, nil, "valk_lilac")
            c:add_to_deck()
            c:set_edition("e_negative", true)
            G.jokers:emplace(c)

            if (G.GAME.blind.boss) then
                for _i, joker in pairs(G.jokers.cards) do
                    local res = Cryptid.safe_get(joker.config.center, "pools", "Food")
                    for _j, pooljoker in pairs(G.P_CENTER_POOLS.Food) do
                        res = res or (pooljoker.key == joker.key)
                        -- print(pooljoker.key)
                    end

                    if res then
                        joker.sell_cost = joker.sell_cost * card.ability.extra.money
                    end
                end
            end
        end
    end
}
-- abcdefg
--    defg

SMODS.Joker {
    key = "cassknows",
    loc_txt = {
        name = "Cass None",
        text = {
            "Gains {X:mult,C:white}X#1#{} Mult when hand is played",
            "Lose {X:mult,C:white}X#4#{} for each card played",
            "{C:inactive}(Currently {X:mult,C:white}X#3#{C:inactive} Mult)",
            credit("unexian")
        }
    },
    config = { extra = { gx = 0.05, x = 1, thresh = 5 } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.gx * 5,
                card.ability.extra.thresh,
                card.ability.extra.x,
                card.ability.extra.gx
            }
        }
    end,
    rarity = 4,
    atlas = "main",
    pos = { x = 7, y = 6 },
    soul_pos = { x = 8, y = 6 },
    cost = 20,
    calculate = function(self, card, context)
        if context.before then
            SMODS.scale_card(card,
                {
                    ref_table = card.ability.extra,
                    ref_value = "x",
                    scalar_value = "gx",
                    operation = function(ref_table, ref_value, initial, change)
                        ref_table[ref_value] = initial + (card.ability.extra.thresh - #context.scoring_hand) * change
                    end
                })
        end

        if context.joker_main then
            return {
                xmult = card.ability.extra.x
            }
        end
    end
}

SMODS.Joker {
    key = "kathleen",
    loc_txt = {
        name = "Kathleen Rosetail",
        text = {
            "{C:planet}Planet{} cards may replace {C:spectral}Spectral{} and {C:tarot}Tarot{} cards.",
            "When {C:attention}blind{} selected, add {C:attention}#1#{} editioned",
            "{C:attention}CCD{} {C:planet}planet{} cards to {C:attention}deck{}",
            credit("mailingway")
        }
    },
    config = { extra = { cards = 5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cards } }
    end,
    rarity = 4,
    atlas = "main",
    pos = { x = 0, y = 11 },
    soul_pos = { x = 1, y = 11 },
    cost = 20,
    blueprint_compat = true,
    pools = { ["Kitties"] = true },
    immutable = true,
    calculate = function(self, card, context)
        if context.setting_blind then
            for i = 1, card.ability.extra.cards do
                local _card = create_card("Base", G.play, nil, nil, nil, nil, nil, "valk_kathleen")
                SMODS.change_base(_card, random_suit(), random_rank())
                _card:set_edition(random_edition(), true)
                _card:set_ability(G.P_CENTER_POOLS.Planet[pseudorandom("valk_kathleen", 1, #G.P_CENTER_POOLS.Planet)])
                _card:add_to_deck()
                G.deck:emplace(_card)
                table.insert(G.playing_cards, _card)
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if from_debuff then return end
        G.GAME.tarot_planet_replacement = 15
        G.GAME.spectral_planet_replacement = 15
    end,
    remove_from_deck = function(self, card, from_debuff)
        if from_debuff then return end
        if #SMODS.find_card("j_valk_kathleen") < 1 then
            G.GAME.tarot_planet_replacement = 0
            G.GAME.spectral_planet_replacement = 0
        end
    end
}

SMODS.Joker {
    key = "sinep",
    loc_txt = {
        name = "Sin E.P. Scarlett",
        text = {
            "When hand played, increase the values on a random ",
            "{C:attention}Joker{} between {C:attention}X#1#{} and {C:attention}X#2#{}",
            credit("mailingway")
        }
    },
    config = { extra = { min = 1.1, max = 6.9 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.min, card.ability.extra.max } }
    end,
    rarity = 4,
    atlas = "main",
    pos = { x = 0, y = 12 },
    soul_pos = { x = 1, y = 12 },
    cost = 20,
    blueprint_compat = false,
    immutable = true,
    calculate = function(self, card, context)
        if context.before and not context.blueprint then
            local chosen = G.jokers.cards[pseudorandom("valk_sinep", 1, #G.jokers.cards)]
            if not Card.no(chosen, "immutable", true) then
                Cryptid.with_deck_effects(chosen, function(cards)
                    Cryptid.manipulate(chosen,
                        {
                            value = math.map(pseudorandom("valk_sinep"), 0, 1, card.ability.extra.min,
                                card.ability.extra.max)
                        })
                end)
            end
        end
    end,
}

SMODS.Joker {
    key = "tasal",
    loc_txt = {
        name = "TASAL",
        text = {
            "{C:attention}+#1#{} Card Selection Limit and Hand Size.",
            "{C:planet}Planet{} cards have a {C:green}#2# in #3#{} chance",
            "to level up your most played {C:attention}poker hand #4#{} Times",
            credit("Grahkon")
        }
    },
    config = { extra = { csl = 3, num = 1, den = 3, levels = 3 } },
    loc_vars = function(self, info_queue, card)
        local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den)
        return { vars = { card.ability.extra.csl, num, den, card.ability.extra.levels } }
    end,
    rarity = 4,
    atlas = "main",
    pos = { x = 2, y = 12 },
    soul_pos = { x = 3, y = 12 },
    cost = 20,
    blueprint_compat = false,
    calculate = function(self, card, context)
        if context.using_consumeable then
            if context.consumeable.ability.set == "Planet" and SMODS.pseudorandom_probability(card, "valk_tasal", card.ability.extra.num, card.ability.extra.den) then
                local hand = vallkarri.get_most_played_hand()
                vallkarri.quick_hand_text(hand, nil, nil, G.GAME.hands[hand].level)
                level_up_hand(card, hand, false, card.ability.extra.levels)
            end
        end
    end,

    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.hand:change_size(card.ability.extra.csl)
            SMODS.change_play_limit(card.ability.extra.csl)
            SMODS.change_discard_limit(card.ability.extra.csl)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            G.hand:change_size(-card.ability.extra.csl)
            SMODS.change_play_limit(-card.ability.extra.csl)
            SMODS.change_discard_limit(-card.ability.extra.csl)
        end
    end,
}

SMODS.Joker {
    key = "maow",
    loc_txt = {
        name = "mrrp,,,, maow :3 ",
        text = {
            "{X:blue,C:white}X#1#{} Chips and {X:red,C:white}X#1#{} Mult",
            "{C:blue}+#1#{} Hands and {C:red}+#1#{} Discards",
            "When playing card is scored, earn {C:money}$#1#{}",
            credit("Scraptake"),
        }
    },
    config = { extra = { meow = 3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.meow } }
    end,
    rarity = 4,
    atlas = "main",
    pos = { x = 4, y = 12 },
    cost = 20,
    immutable = false,
    blueprint_compat = false,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            ease_dollars(card.ability.extra.meow)
        end
        if (context.joker_main) or context.forcetrigger then
            return { x_mult = card.ability.extra.meow, x_chips = card.ability.extra.meow }
        end
        if (context.setting_blind) then
            ease_hands_played(card.ability.extra.meow)
            ease_discard(card.ability.extra.meow)
        end
    end,

}


SMODS.Joker {
    key = "issbrokie",
    loc_txt = {
        name = "ISSBROKIE",
        text = {
            "All{C:attention} Aces, Kings, 4s{} and {C:attention}7s{} increase",
            "chips and mult of played hand type by {C:attention}X1+(rank/100){}",
            credit("Scraptake")
        }
    },
    config = { extra = { inc = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.inc } }
    end,
    rarity = 4,
    atlas = "main",
    pos = { x = 2, y = 14 },
    soul_pos = { x = 3, y = 14 },
    cost = 20,
    blueprint_compat = true,
    immutable = true,


    calculate = function(self, card, context)
        if (context.individual and context.cardarea == G.play) and (context.other_card:get_id() == 4 or
                context.other_card:get_id() == 7 or
                context.other_card:get_id() == 13 or
                context.other_card:get_id() == 14) then
            card.ability.extra.inc = 1 + (context.other_card:get_id() / 100)
            local text = G.FUNCS.get_poker_hand_info(context.full_hand)
            G.GAME.hands[text].chips = G.GAME.hands[text].chips * card.ability.extra.inc
            G.GAME.hands[text].mult = G.GAME.hands[text].mult * card.ability.extra.inc
        end
    end,

}

SMODS.ObjectType({
    object_type = "ObjectType",
    key = "aesthetijoker",
    cards = {},
    inject = function(self)
        SMODS.ObjectType.inject(self)
    end,
})

SMODS.Joker {
    key = "frutiger",
    loc_txt = {
        name = "Frutiger",
        text = {
            "Adjacent Jokers are given {C:dark_edition}Foil{}",
            "All {C:attention}other Jokers{} have their Editions {C:red}removed{}",
            "{C:dark_edition}Foil{} cards additionally give {X:chips,C:white}X#1#{} Chips",
            "when triggered, and cannot be {C:red}debuffed{}",
            credit("Lil Mr. Slipstream"),
        }
    },
    config = { extra = { edition = "e_foil", xchips = 1.25 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.edition]
        return { vars = { card.ability.extra.xchips } }
    end,
    rarity = 4,
    atlas = "atlas2",
    pos = { x = 5, y = 0 },
    soul_pos = { x = 5, y = 1 },
    cost = 20,
    pools = { ["aesthetijoker"] = true },

    calculate = function(self, card, context)
        
        
        if context.valk_rearrange and context.card == card then
            for _, joker in pairs(G.jokers.cards) do
                joker:apply_aesthetijoker_edition()
            end
        end

        if context.post_trigger and context.other_card.edition and context.other_card.edition.key == card.ability.extra.edition then
            return {
                xchips = card.ability.extra.xchips
            }
        end

    end,

}

SMODS.Joker {
    key = "synth",
    loc_txt = {
        name = "Synth",
        text = {
            "Adjacent Jokers are given {C:dark_edition}Holographic{}",
            "All {C:attention}other Jokers{} have their Editions {C:red}removed{}",
            "{C:dark_edition}Holographic{} Jokers additionally give {X:mult,C:white}X#1#{} Mult",
            "when triggered",
            credit("Lil Mr. Slipstream")
        }
    },
    config = { extra = { edition = "e_holo", xmult = 1.5 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.edition]
        return { vars = { card.ability.extra.xmult } }
    end,
    rarity = 4,
    atlas = "atlas2",
    pos = { x = 6, y = 0 },
    soul_pos = { x = 6, y = 1 },
    cost = 20,
    pools = { ["aesthetijoker"] = true },

    calculate = function(self, card, context)
        if context.valk_rearrange and context.card == card then
            for _, joker in pairs(G.jokers.cards) do
                joker:apply_aesthetijoker_edition()
            end
        end

        if context.post_trigger and context.other_card.edition and context.other_card.edition.key == card.ability.extra.edition then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,

}

SMODS.Joker {
    key = "chrome",
    loc_txt = {
        name = "Chrome",
        text = {
            "Adjacent Jokers are given {C:dark_edition}Polychrome{}",
            "All {C:attention}other Jokers{} have their Editions {C:red}removed{}",
            "{C:dark_edition}Polychrome{} Jokers are retriggered {C:attention}once{} and",
            "give an additional {X:mult,C:white}X#1#{} Mult",
            credit("Lil Mr. Slipstream")
        }
    },
    config = { extra = { edition = "e_polychrome", xmult = 1.5 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.edition]
        return { vars = { card.ability.extra.xmult } }
    end,
    rarity = 4,
    atlas = "atlas2",
    pos = { x = 4, y = 0 },
    soul_pos = { x = 4, y = 1 },
    cost = 20,
    pools = { ["aesthetijoker"] = true },

    calculate = function(self, card, context)
        if context.valk_rearrange and context.card == card then
            for _, joker in pairs(G.jokers.cards) do
                joker:apply_aesthetijoker_edition()
            end
        end

        if context.post_trigger and context.other_card.edition and context.other_card.edition.key == card.ability.extra.edition then
            return {
                xmult = card.ability.extra.xmult
            }
        end

        if context.retrigger_joker_check and context.other_card.edition and context.other_card.edition.key == card.ability.extra.edition then
            return {
                repetitions = 1
            }
        end
    end,

}



SMODS.Joker {
    key = "vapor",
    loc_txt = {
        name = "Vapor",
        text = {
            "Adjacent Jokers are given {C:dark_edition}Negative{}",
            "All {C:attention}other Jokers{} have their Editions {C:red}removed{}",
            "{C:dark_edition}Negative{} Jokers additionally give {X:dark_edition,C:white}X#1#{}",
            "Blind Size when triggered",
            credit("Lil Mr. Slipstream")
        }
    },
    config = { extra = { edition = "e_negative", blind_size = 0.9 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.edition]
        return { vars = {card.ability.extra.blind_size} }
    end,
    rarity = 4,
    atlas = "atlas2",
    pos = { x = 7, y = 0 },
    soul_pos = { x = 7, y = 1 },
    cost = 20,
    pools = { ["aesthetijoker"] = true },

    calculate = function(self, card, context)
        if context.valk_rearrange and context.card == card then
            for _, joker in pairs(G.jokers.cards) do
                joker:apply_aesthetijoker_edition()
            end
        end

        if context.post_trigger and context.other_card.edition and context.other_card.edition.key == card.ability.extra.edition then
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound("timpani")
                    G.GAME.blind.chips = G.GAME.blind.chips * card.ability.extra.blind_size
                    G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
                    G.HUD_blind:recalculate()
                    G.hand_text_area.blind_chips:juice_up()
                    context.other_card:juice_up()
                    quick_card_speak(context.other_card, "X" .. card.ability.extra.blind_size)
                    return true
                end
            }))
        end
    end,

}
