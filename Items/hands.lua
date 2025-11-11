SMODS.PokerHand {
    key = "fullmansion",
    mult = 20,
    chips = 400,
    l_mult = 10,
    l_chips = 150,
    visible = false,
    example = {
        {"S_9"},
        {"H_9"},
        {"D_9"},
        {"S_T"},
        {"C_T"},
        {"H_T"},
        {"C_T"},
    },
    visible = false,
    loc_txt = {
        name = "Full Mansion",
        description = {
            "3 of a kind and 4 of a kind"
        }
    },
    evaluate = function(parts, hand)
        if #parts._3 >= 2 and #parts._4 >= 1 then return parts._all_pairs end
        return {}
    end
}

SMODS.Joker {
    key = "homely_joker",
    loc_txt = {
        name = "Homely Joker",
        text = {
            "{C:mult}+#1#{} Mult if played hand",
            "contains a {C:attention}Full Mansion{}",
        }
    },
    valk_artist = "Pangaea",
    config = {extra = {mult = 60}},
    rarity = 1,
    atlas = "main",
    pos = {x=1, y=10},
    cost = 6,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult}}
    end,

    calculate = function(self, card, context)

        if context.joker_main and context.poker_hands ~= nil and next(context.poker_hands["valk_fullmansion"]) then
            return {
                mult = card.ability.extra.mult
            }
        end

    end,
    in_pool = function()
        return G.GAME.hands["valk_fullmansion"].played > 0
    end

}

SMODS.Joker {
    key = "roomy_joker",
    loc_txt = {
        name = "Roomy Joker",
        text = {
            "{C:chips}+#1#{} Chips if played hand",
            "contains a {C:attention}Full Mansion{}",
        }
    },
    valk_artist = "Pangaea",
    config = {extra = {chips = 600}},
    rarity = 1,
    atlas = "main",
    pos = {x=2, y=10},
    cost = 6,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips}}
    end,

    calculate = function(self, card, context)

        if context.joker_main and context.poker_hands ~= nil and next(context.poker_hands["valk_fullmansion"]) then
            return {
                chips = card.ability.extra.chips
            }
        end

    end,
    in_pool = function()
        return G.GAME.hands["valk_fullmansion"].played > 0
    end

}

SMODS.Joker {
    key = "homely_joker",
    loc_txt = {
        name = "Homely Joker",
        text = {
            "{X:mult,C:white}X#1#{} Mult if played hand",
            "contains a {C:attention}Full Mansion{}",
        }
    },
    valk_artist = "Pangaea",
    config = {extra = {mult = 9}},
    rarity = 1,
    atlas = "main",
    pos = {x=1, y=10},
    cost = 6,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult}}
    end,

    calculate = function(self, card, context)

        if context.joker_main and context.poker_hands ~= nil and next(context.poker_hands["valk_fullmansion"]) then
            return {
                xmult = card.ability.extra.mult
            }
        end

    end,
    in_pool = function()
        return G.GAME.hands["valk_fullmansion"].played > 0
    end

}

SMODS.Consumable {
    set = "Planet",
    key = "etheirys",
    loc_txt = {
        name = "Janssen",
        text = {
            "{S:0.8}({S:0.8,V:1}lvl.#1#{S:0.8}){} Level up",
            "{C:attention}#2#{}",
            "{C:mult}+#3#{} Mult and {C:chips}+#4#{} Chips",
        }
    },
    valk_artist = "mailingway",
    config = { hand_type = "valk_fullmansion"},
    loc_vars = function(self, info_queue, card)


        return { vars = {
            G.GAME.hands[card.ability.hand_type].level,
            localize(card.ability.hand_type, 'poker_hands'),
            G.GAME.hands[card.ability.hand_type].l_mult,
            G.GAME.hands[card.ability.hand_type].l_chips,
            colours = {
                to_number(G.GAME.hands[card.ability.hand_type].level) == 1 and G.C.UI.TEXT_DARK or G.C.HAND_LEVELS[math.min(7, to_number(G.GAME.hands[card.ability.hand_type].level))]
            }
        }}
    end,
    atlas = "main",
    pos = {x=4, y=8},
    in_pool = function(self, args)
        return G.GAME.hands[card.ability.hand_type].played > 0
    end
}