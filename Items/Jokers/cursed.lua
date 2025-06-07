SMODS.Joker {
    key = "killmult",
    loc_txt = {
        name = "placeholder",
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
    atlas = "phold",
    pos = {x=0, y=0},
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
        name = "placeholder",
        text = {
            "All jokers give {X:chips,C:white}^#1#{} Chips when triggered",
        }
    },
    config = { extra = { echips = 0.006 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.echips}}
    end,
    rarity = "valk_supercursed",
    atlas = "phold",
    pos = {x=0, y=0},
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
        name = "placeholder",
        text = {
            "When card drawn, {C:red,E:1}destroy it{}",
            "Half levels of all {C:attention}Poker Hands{} when card added to deck",
        }
    },
    config = { extra = {}, immutable = {} },
    loc_vars = function(self, info_queue, card)
        return { vars = {}}
    end,
    rarity = "valk_supercursed",
    atlas = "phold",
    pos = {x=0, y=0},
    cost = -1e10,
    calculate = function(self, card, context)
        
        if context.other_card and context.other_card.area ~= G.deck then
            context.other_card:quick_dissolve()
            level_all_hands(card, -1)
        end

        if context.playing_card_added then

            for i,hand in pairs(G.GAME.hands) do
                level_up_hand(card, i, nil, -(hand.level/2))
            end

        end

    end,

    add_to_deck = function(self, card, from_debuff)
        if from_debuff then return end
        card:set_eternal(true)
    end,
}