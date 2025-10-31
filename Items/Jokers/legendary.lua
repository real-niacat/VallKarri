SMODS.Joker {
    key = "niko",
    loc_txt = {
        name = "Niko Gray",
        text = {
            "When blind selected, {C:red}debuff{} leftmost Joker and {C:attention}double{} its values",
            "Remove {C:red}debuff{} from all Jokers at end of round",
            quote("niko"),
        }
    },
    valk_artist = "Scraptake",
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
                Cryptid.manipulate(G.jokers.cards[1], { value = 2 }) --oh no! hardcoding!
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
            "{X:mult,C:white}X#1#{} Mult for every day since {C:attention}Hollow Knight Silksong{} was released",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
            quote("hornet"),
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { gain = 0.1 } },
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
            return { xmult = 1 + (card.ability.extra.gain * days_since(2025, 9, 4)) }
        end
    end

}

SMODS.Joker {
    key = "lilac",
    loc_txt = {
        name = "Lilac Lilybean",
        text = {
            "Multiply {C:money}Sell Value{} of all Jokers by {X:money,C:white}X#1#{} at end of round",
            quote("lilac"),
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { money = 5 } },
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
            for _,joker in pairs(G.jokers.cards) do
                joker.ability.extra_value = (joker.sell_cost + joker.ability.extra_value) * card.ability.extra.money
                joker:set_cost()
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
        }
    },
    valk_artist = "unexian",
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
            "When {C:attention}blind{} selected, add {C:attention}#1#{} editioned",
            "{C:attention}CCD{} {C:planet}Planet{} cards to {C:attention}Hand{}",
            "When {C:attention}Boss Blind{} defeated, add {C:attention}#2#{} editioned",
            "{C:attention}CCD{} {C:planet}Planet{} cards with {C:attention}Seals{} to {C:attention}Deck{}",
        }
    },
    valk_artist = "mailingway",
    config = { extra = { cards = 5, sealed = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cards, card.ability.extra.sealed } }
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
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                func = function()
                    for i = 1, card.ability.extra.cards do
                        local _card = SMODS.add_card({set = "Base", area = G.hand})
                        _card:set_edition(poll_edition("valk_kathleen", nil, nil, true), true)
                        _card:set_ability(G.P_CENTER_POOLS.Planet[pseudorandom("valk_kathleen", 1, #G.P_CENTER_POOLS.Planet)])
                    end
                    return true 
                end,
            })) 
        end

        if context.end_of_round and context.main_eval and G.GAME.blind.boss then
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                func = function()
                    for i = 1, card.ability.extra.sealed do
                        local _card = SMODS.add_card({set = "Base", area = G.deck})
                        _card:set_edition(poll_edition("valk_kathleen", nil, nil, true), true)
                        _card:set_ability(G.P_CENTER_POOLS.Planet[pseudorandom("valk_kathleen", 1, #G.P_CENTER_POOLS.Planet)])
                        _card:set_seal(SMODS.poll_seal({key = "valk_kathleen", guaranteed = true}), true)
                    end
                    return true 
                end,
            })) 
        end
    end,
}

SMODS.Joker {
    key = "sinep",
    loc_txt = {
        name = "Sin E.P. Scarlett",
        text = {
            "Cards permanently gain between",
            "{X:chips,C:white}X#1#{} and {X:chips,C:white}X#2#{} Chips when scored",
        }
    },
    valk_artist = "mailingway",
    config = { extra = { min = 0.69, max = 4.2 } },
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
        if context.individual and context.cardarea == G.play then
            local num = card.ability.extra.min + (pseudorandom("valk_sinep") * (card.ability.extra.max - card.ability.extra.min))
            context.other_card.ability.perma_x_chips = context.other_card.ability.perma_x_chips+num
            quick_card_speak(context.other_card, localize("k_upgrade_ex"))
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
        }
    },
    valk_artist = "Grahkon",
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
        }
    },
    valk_artist = "Scraptake",
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
        }
    },
    valk_artist = "Scraptake",
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


