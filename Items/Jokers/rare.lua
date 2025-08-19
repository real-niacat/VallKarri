SMODS.Joker {
    key = "femtanyl",
    loc_txt = {
        name = "Femtanyl",
        text = {
            "Prevent death at the cost of {C:attention}#1#{} Joker slot",
            "Restore {C:attention}#1#{} taken joker slot when {C:attention}boss{} defeated on an odd ante",
            "{C:inactive}(Does not work below {C:attention}#2#{C:inactive} Joker slots)",
            quote("femtanyl"),
            credit("Scraptake")
        }
    },
    config = { extra = { cost = 1, req = 4, taken = 0 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.cost, card.ability.extra.req } }
    end,
    pools = { ["Kitties"] = true },
    rarity = 3,
    atlas = "main",
    pos = { x = 0, y = 5 },
    soul_pos = { x = 1, y = 5 },
    cost = 6,
    immutable = true,
    calculate = function(self, card, context)
        if context.end_of_round and context.game_over and G.jokers.config.card_limit >= card.ability.extra.req then
            G.jokers:change_size(-card.ability.extra.cost)
            card.ability.extra.taken = card.ability.extra.taken + card.ability.extra.cost
            return {
                message = localize('k_saved_ex'),
                saved = true,
                colour = G.C.RED
            }
        elseif context.end_of_round and not context.game_over and G.GAME.blind.boss and (G.GAME.round_resets.ante % 2 == 1) and card.ability.extra.taken > 0 then
            G.jokers:change_size(card.ability.extra.cost)
            card.ability.extra.taken = card.ability.extra.taken - card.ability.extra.cost
        end
    end
}

SMODS.Joker {
    key = "planetarium",
    loc_txt = {
        name = "Planetarium",
        text = {
            "When {C:attention}hand{} played, increase {C:chips}chips{} and {C:mult}mult{} per level",
            "of played {C:attention}poker hand{} by {C:attention}#1#{}",
            credit("Grahkon")
        }
    },
    config = { extra = { inc = 1 } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.inc
            }
        }
    end,
    atlas = "main",
    pos = { x = 10, y = 4 },
    cost = 7,
    rarity = 3,
    calculate = function(self, card, context)
        if context.before then
            quick_card_speak(card, localize("k_upgrade_ex"))
            local text = G.FUNCS.get_poker_hand_info(context.full_hand)
            G.GAME.hands[text].l_chips = G.GAME.hands[text].l_chips + card.ability.extra.inc
            G.GAME.hands[text].l_mult = G.GAME.hands[text].l_mult + card.ability.extra.inc
        end
    end,
}

SMODS.Joker {
    key = "matchbox",
    loc_txt = {
        name = "Matchbox",
        text = {
            "This Joker gains {X:mult,C:white}X#1#{} Mult per",
            "{C:attention}consecutive{} hand played larger than blind size",
            "{C:inactive}(Does not reset on Boss Blinds){}",
            "{C:inactive}(Currently {X:red,C:white}X#2#{C:inactive} Mult){}",

            credit("Scraptake")
        }
    },
    config = { extra = { cur = 1, gain = 0.3 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, card.ability.extra.cur } }
    end,
    rarity = 3,
    atlas = "main",
    pos = { x = 4, y = 13 },
    cost = 8,
    blueprintcompat = true,


    calculate = function(self, card, context)
        -- is a little fucked with The Tax boss blind but idk how to fix, help
        if context.after then
            if hand_chips * mult > G.GAME.blind.chips then
                card.ability.extra.cur = card.ability.extra.cur + card.ability.extra.gain
                quick_card_speak(card, "Upgraded!")
            else
                if not G.GAME.blind.boss then
                    card.ability.extra.cur = 1
                    quick_card_speak(card, "Reset!")
                end
            end
        end

        if context.joker_main or context.forcetrigger then
            return { xmult = card.ability.extra.cur }
        end
    end,

}

SMODS.Joker {
    key = "leopard_print",
    loc_txt = {
        name = "Leopard Print",
        text = {
            "Retrigger all {C:attention}Kitty{} Jokers once",
            "for each {C:attention}Kitty{} Joker owned",
            credit("mailingway")
        }
    },
    config = { extra = {} },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    rarity = 3,
    atlas = "main",
    pos = { x = 12, y = 4 },
    cost = 8,
    blueprintcompat = true,
    pools = { ["Kitties"] = true },

    calculate = function(self, card, context)
        if context.retrigger_joker_check and Cryptid.safe_get(context.other_card.config.center, "pools", "Kitties") then
            local count = 0
            for _, joker in ipairs(G.jokers.cards) do
                if Cryptid.safe_get(joker.config.center, "pools", "Kitties") then
                    count = count + 1
                end
            end

            return {
                repetitions = count
            }
        end
    end,
    in_pool = function(self, args)
        for i, joker in ipairs(G.jokers.cards) do
            if Cryptid.safe_get(joker.config.center, "pools", "Kitties") then
                return true
            end
        end
        return false
    end,

}

SMODS.Joker {
    key = "legeater",
    loc_txt = {
        name = "Leg-Eater",
        text = {
            "Creates a copy of the {C:attention}topmost{} tag when blind selected",
            "Lose {C:money}$#1#{} when this happens",
            credit("Scraptake")
        }
    },
    config = { extra = { money = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money } }
    end,
    rarity = 3,
    atlas = "main",
    pos = { x = 5, y = 1 },
    soul_pos = { x = 6, y = 1 },
    cost = 15,
    demicoloncompat = true,
    calculate = function(self, card, context)
        if (context.setting_blind or context.forcetrigger) and #G.GAME.tags > 0 then
            add_tag(Tag(G.GAME.tags[#G.GAME.tags].key))
            ease_dollars(-card.ability.extra.money)
        end
    end
}

SMODS.Joker {
    key = "familiarface",
    loc_txt = {
        name = "Familiar Face",
        text = {
            "Scored {C:attention}9s{} give {X:mult,C:white}X#1#{} Mult",
            "Scored {C:attention}Mirrored{} cards give {X:chips,C:white}X#2#{} Chips",
            "{C:inactive,s:0.7}hm, where have i seen this face before?",
            credit("aduckted")
        }
    },
    config = { extra = { xmult = 1.09, xchips = 2.9 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_valk_mirrored
        return { vars = { card.ability.extra.xmult, card.ability.extra.xchips } }
    end,
    rarity = 3,
    atlas = "main",
    pos = { x = 11, y = 8 },
    cost = 8,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            local returntable = {}
            if SMODS.has_enhancement(context.other_card, "m_valk_mirrored") then
                returntable.xchips = card.ability.extra.xchips
            end
            if context.other_card:get_id() == 9 then
                returntable.xmult = card.ability.extra.xmult
            end

            return returntable
        end
    end
}

-- {x=10, y=8}

SMODS.Joker {
    key = "neffy",
    rarity = 3,
    atlas = "atlas2",
    pos = { x = 2, y = 1 },
    cost = 8,
    loc_txt = {
        name = "Neffy",
        text = {
            "{X:mult,C:white}X#1#{} Mult",
            "Lose {X:mult,C:white}X#2#{} for every other {C:attention}Kitty{} Joker owned",
            credit("mailingway"),
            catby("cg")
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.base - math.max(kitty_count(-1) * card.ability.extra.loss, 0), card.ability.extra.loss } }
    end,
    demicoloncompat = true,
    config = { extra = { base = 3, loss = 0.25 } },
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                xmult = card.ability.extra.base - math.max(kitty_count(-1) * card.ability.extra.loss, 0)
            }
        end
    end,
    pools = { ["Kitties"] = true },

}

SMODS.Joker {
    key = "norma",
    rarity = 3,
    atlas = "atlas2",
    pos = { x = 2, y = 0 },
    cost = 8,
    loc_txt = {
        name = "Norma",
        text = {
            "Cards in hand are {C:attention}flipped{} when cards are drawn",
            "Gain {X:mult,C:white}X#1#{} Mult for each card drawn",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
            credit("mailingway"),
            catby("Ren")
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, card.ability.extra.xmult } }
    end,
    demicoloncompat = true,
    config = { extra = { xmult = 1, gain = 0.03, real_gain = 0 } },
    calculate = function(self, card, context)
        if context.drawing_cards then
            card.ability.extra.real_gain = (card.ability.extra.gain * context.amount)
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.real_gain

            SMODS.scale_card(card, { ref_table = card.ability.extra, ref_value = "xmult", scalar_value = "real_gain" })

            for i, handcard in ipairs(G.hand.cards) do
                handcard:flip()
            end
        end

        if context.joker_main or context.forcetrigger then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
    pools = { ["Kitties"] = true },

}

SMODS.Joker {
    key = "boxofkittens",
    rarity = 3,
    atlas = "atlas2",
    pos = { x = 3, y = 2 },
    cost = 8,
    loc_txt = {
        name = "Box of Kittens",
        text = {
            "Create a {C:attention}Kitty Tag{} when rerolling the shop",
            "{C:mult}+#1#{} Mult for each {C:attention}Kitty Tag{} owned",
            "{C:inactive}(Currently {C:mult}+#2#{C:inactive} Mult)",
            credit("mailingway"),
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult * vallkarri.count_kitty_tags() } }
    end,
    demicoloncompat = true,
    config = { extra = { mult = 3 } },
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                mult = card.ability.extra.mult * vallkarri.count_kitty_tags()
            }
        end

        if context.reroll_shop then
            add_tag(Tag("tag_valk_kitty"))
        end
    end,
    pools = { ["Kitties"] = true },

}

SMODS.Joker {
    key = "dupli_cat_ion",
    rarity = 3,
    atlas = "atlas2",
    pos = { x = 3, y = 3 },
    cost = 8,
    loc_txt = {
        name = "Dupli-cat-ion",
        text = {
            "At end of round, each {C:attention}Kitty Tag{} has a {C:green}#1# in #2#{}",
            "chance to create another {C:attention}Kitty Tag{}",
            "Increase denominator by {C:attention}#3#{} for every {C:attention}#4# Kitty Tags{} owned",
            credit("mailingway"),
        }
    },
    loc_vars = function(self, info_queue, card)
        local num, den = SMODS.get_probability_vars(card, card.ability.extra.base_num,
            card.ability.extra.base_den + math.floor(vallkarri.count_kitty_tags() / card.ability.extra.thresh))

        return { vars = { num, den, card.ability.extra.inc, card.ability.extra.thresh } }
    end,
    demicoloncompat = true,
    config = { extra = { base_num = 1, base_den = 2, inc = 1, thresh = 4 } },
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            local to_make = 0

            for i, tag in ipairs(G.GAME.tags) do
                if tag.key == "tag_valk_kitty" then
                    if SMODS.pseudorandom_probability(card, "duplication", card.ability.extra.base_num, card.ability.extra.base_den + math.floor(vallkarri.count_kitty_tags() / card.ability.extra.thresh)) then
                        to_make = to_make + 1
                    end
                end
            end

            for i = 1, to_make do
                add_tag(Tag("tag_valk_kitty"))
            end
        end
    end,
    pools = { ["Kitties"] = true },

}

SMODS.Joker {
    key = "greedy_bastard",
    rarity = 3,
    atlas = "atlas2",
    pos = { x = 2, y = 2 },
    cost = 8,
    loc_txt = {
        name = "Greedy Bastard",
        text = {
            "At end of round, gain {X:mult,C:white}X#1#{} Mult for each {C:attention}Kitty Tag{} owned",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult){}",
            credit("mailingway"),
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, card.ability.extra.mult } }
    end,
    demicoloncompat = true,
    config = { extra = { mult = 1, gain = 0.05 } },
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return {
                xmult = card.ability.extra.mult
            }
        end

        if context.end_of_round and context.main_eval then
            local upgr = false
            for i, tag in ipairs(G.GAME.tags) do
                if tag.key == "tag_valk_kitty" then
                    upgr = true
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.gain
                end
            end
            if upgr then
                quick_card_speak(card, localize("k_upgrade_ex"))
            end
        end
    end,
    pools = { ["Kitties"] = true },

}

SMODS.Joker {
    key = "thecolonthree",
    rarity = 3,
    atlas = "atlas2",
    pos = { x = 0, y = 2 },
    cost = 8,
    loc_txt = {
        name = "The :3",
        text = {
            "{X:mult,C:white}X#1#{} Mult if the last message in the {C:attention}Vallkarri{}",
            "discord server contains {E:1}\":3\"{}",
            "{C:inactive,s:0.8}(#2#)",
            credit("notmario"),
        }
    },
    loc_vars = function(self, info_queue, card)
        local active = string.find(vallkarri.last_message, ":3") and "Active!" or "Inactive"
        return { vars = { card.ability.extra.mult, active } }
    end,
    demicoloncompat = true,
    config = { extra = { mult = 5 } },
    blueprint_compat = true,
    calculate = function(self, card, context)
        if (context.joker_main and string.find(vallkarri.last_message, ":3")) or context.forcetrigger then
            return {
                xmult = card.ability.extra.mult
            }
        end
    end,
    pools = { ["Kitties"] = true },

}

SMODS.Joker {
    key = "coronal",
    loc_txt = {
        name = "Coronal Ejection",
        text = {
            "{C:green}#1# in #2#{} chance to increase {C:gold}Ascension Power{} of played {C:attention}poker hand{} by {X:gold,C:white}+#3#{}",
            credit("mailingway")
        }
    },
    config = { extra = { num = 1, den = 10, power = 10 } },
    loc_vars = function(self, info_queue, card)
        local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, 'coronal')
        return { vars = { num, den, card.ability.extra.power } }
    end,
    rarity = 3,
    atlas = "main",
    pos = { x = 4, y = 14 },
    cost = 8,
    demicoloncompat = true,
    blueprint_compat = true,

    calculate = function(self, card, context)
        if context.before then
            if SMODS.pseudorandom_probability(card, 'coronal', card.ability.extra.num, card.ability.extra.den, 'coronal') then
                local text = G.FUNCS.get_poker_hand_info(context.full_hand)
                G.GAME.hands[text].AscensionPower = (G.GAME.hands[text].AscensionPower and G.GAME.hands[text].AscensionPower + card.ability.extra.power) or
                card.ability.extra.power
                quick_card_speak(card, "Upgraded!")
            end
        end
    end,
    dependencies = {"entr"},

}
