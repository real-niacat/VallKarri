SMODS.PokerHand {
    key = "fullmansion",
    mult = 80,
    chips = 860,
    l_mult = 20,
    l_chips = 260,
    example = {
        {"S_9"},
        {"H_9"},
        {"D_9"},
        {"S_T"},
        {"C_T"},
        {"H_T"},
        {"S_2"},
        {"H_2"},
        {"C_2"},
    },
    visible = true,
    loc_txt = {
        name = "Full Mansion",
        description = {
            "3 Three of a Kinds"
        }
    },
    evaluate = function(parts, hand)
        local cardsbyrank = {}
        local morethanthree = {}
        local sum = {}
        local count = 0

        -- print(hand)

        for i,card in ipairs(hand) do
            -- print(card.base.id)
            
            if not cardsbyrank[card.base.id] then
                -- print("a")
                cardsbyrank[card.base.id] = {card}
            else
                -- print("b")
                cardsbyrank[card.base.id][#cardsbyrank[card.base.id]+1] = card
            end

        end

        for name,piece in pairs(cardsbyrank) do
            -- print("there are " .. #piece .. " " .. name .. "s")
            if #piece >= 3 then
                count = count + 1
                morethanthree[#morethanthree+1] = piece
                for _,card in ipairs(piece) do
                    sum[#sum+1] = card
                end
            end

        end

        for name,cards in ipairs(cardsbyrank) do
            print(name,#cards)
        end

        if #morethanthree >= 3 then
            return { sum }
        end
    end
}

SMODS.Joker {
    key = "homely_joker",
    loc_txt = {
        name = "Homely Joker",
        text = {
            "{C:mult}+#1#{} Mult if played hand",
            "contains a {C:attention}Full Mansion{}"
        }
    },
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
            "contains a {C:attention}Full Mansion{}"
        }
    },
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
            "contains a {C:attention}Full Mansion{}"
        }
    },
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