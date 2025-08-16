SMODS.Joker {
    key = "suckit",
    loc_txt = {
        name = "{C:red}Suck It{}",
        text = {
            "Creates itself when removed",
            "{C:inactive}Suck it.{}",
            credit("Lily")
        }
    },
    config = { extra = {} },
    rarity = 1,
    atlas = "main",
    pos = { x = 4, y = 5 },
    cost = 0,
    pools = { ["Meme"] = true },

    remove_from_deck = function(self, card, from_debuff)
        -- simple_create("Joker", G.jokers, "j_valk_suckit")
        if G.jokers and #SMODS.find_card("j_valk_suckit") <= 0 then
            local new = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_valk_suckit", "suckit")
            new.sell_cost = 0
            new:add_to_deck()
            G.jokers:emplace(new)
        end
    end
}

SMODS.Joker {
    key = "antithesis",
    loc_txt = {
        name = "Antithesis",
        text = {
            "{C:mult}+#1#{} Mult for every {C:attention}unscoring{} card",
            credit("mailingway")
        }
    },
    config = { extra = { per = 2 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.per } }
    end,
    rarity = 1,
    atlas = "main",
    pos = { x = 10, y = 5 },
    cost = 5,
    blueprintcompat = true,


    calculate = function(self, card, context)
        if context.joker_main then
            local amount = (#context.full_hand - #context.scoring_hand)
            return { mult = card.ability.extra.per * amount }
        end
    end,

}

SMODS.Joker {
    key = "kitty",
    loc_txt = {
        name = "Kitty",
        text = {
            "At end of round, {C:green}#1# in #2#{} chance",
            "to create a {C:attention}Cat Tag{}",
            credit("Nobody!")
        }
    },
    config = { extra = { num = 1, den = 2 } },
    loc_vars = function(self, info_queue, card)
        local n,d = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, "kitty")
        return { vars = { n,d } }
    end,
    rarity = 1,
    atlas = "phold",
    pos = { x = 0, y = 1 },
    cost = 5,
    blueprintcompat = true,
    pools = { ["Kitties"] = true },

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and 
            SMODS.pseudorandom_probability(card, "valk_kitty", card.ability.extra.num, card.ability.extra.den, "valk_kitty") then
            add_tag(Tag("tag_cry_cat"))
        end
    end,

}