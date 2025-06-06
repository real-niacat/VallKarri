SMODS.Joker {
    key = "killmult",
    loc_txt = {
        name = "placeholder",
        text = {
            "Permanently disables {C:mult}Mult{} in {C:attention}#1#{} rounds",
            "{C:inactive,s:0.6}(Yes, this does everything you think it does.)",
        }
    },
    config = { extra = { rounds = 5 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.rounds}}
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
            end
        end

    end,

    add_to_deck = function(self, card, from_debuff)
        card:set_eternal(true)
    end
}

