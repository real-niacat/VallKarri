SMODS.Joker {
    key = "killmult",
    loc_txt = {
        name = "Avulsion",
        text = {
            "Permanently disables {C:mult}Mult{} in {C:attention}#1#{} rounds",
            "{C:inactive,s:0.6}(Yes, this does everything you think it does.)",
            "{C:red,E:1}Dramatically{} set money to {C:money}-$#2#{} when removed",
        }
    },
    config = { extra = { rounds = 5 }, immutable = {drama = 66} },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.rounds, card.ability.immutable.drama}}
    end,
    rarity = "valk_supercursed",
    atlas = "main",
    pos = {x=9, y=6},
    cost = -1e10,
    demicoloncompat = true,
    calculate = function(self, card, context)
        
        if
			context.end_of_round
			and not context.blueprint
			and not context.individual
			and not context.repetition
			and not context.retrigger_joker
		then
            card.ability.extra.rounds = card.ability.extra.rounds - 1

            if (card.ability.extra.rounds <= 0) then
                disable_mult_ui()
                card_eval_status_text(card,"extra",nil,nil,nil,{message = "Multn't!"})
                card:quick_dissolve()
            end
        end

        if (context.forcetrigger) then
            disable_mult_ui()
            card_eval_status_text(card,"extra",nil,nil,nil,{message = "Multn't!"})
            card:quick_dissolve()
        end

    end,

    add_to_deck = function(self, card, from_debuff)
        if from_debuff then return end
        card:set_eternal(true)
    end,

    remove_from_deck = function(self, card, from_debuff)
        if from_debuff then return end

        G.GAME.dollars = 0
        for i=1,card.ability.immutable.drama do
            ease_dollars(-1)
        end
    end
}

SMODS.Joker {
    key = "rooter",
    loc_txt = {
        name = "Hexaract",
        text = {
            "All jokers give {X:dark_edition,C:white}^#1#{} Chips when triggered",
        }
    },
    config = { extra = { echips = 0.006 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.echips}}
    end,
    rarity = "valk_supercursed",
    atlas = "main",
    pos = {x=9, y=7},
    cost = -1e10,
    immutable = true,
    calculate = function(self, card, context)
        
        if context.post_trigger and hand_chips then
            hand_chips = hand_chips:pow(card.ability.extra.echips)
            card_eval_status_text(card, "extra", nil, nil, nil, { message = "^" .. card.ability.extra.echips .. " Chips" })
        end

    end,

    add_to_deck = function(self, card, from_debuff)
        card:set_eternal(true)
    end
}

SMODS.Joker {
    key = "nocards",
    loc_txt = {
        name = "Joker of None",
        text = {
            "When card {C:red,E:1}touched{}, {C:red,E:1}destroy it{}",
            "Half levels of all {C:attention}Poker Hands{} when card added to deck",
        }
    },
    config = { extra = {}, immutable = {} },
    loc_vars = function(self, info_queue, card)
        return { vars = {}}
    end,
    rarity = "valk_supercursed",
    atlas = "main",
    pos = {x=8, y=7},
    cost = -1e10,
    calculate = function(self, card, context)
        
        if context.other_card and context.other_card.area == G.hand then
            context.other_card:start_dissolve({G.C.BLACK}, nil, 2 * G.SETTINGS.GAMESPEED)
        end

        if context.playing_card_added then

            level_all_hands(card, 0, -0.5)

        end

    end,

    add_to_deck = function(self, card, from_debuff)
        if from_debuff then return end
        card:set_eternal(true)
    end,
}