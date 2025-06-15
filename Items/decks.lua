SMODS.Back {
    key = "inertia",
    loc_txt = {
        name = "Inertia Deck",
        text = {
            "Normal ante gain is {C:red,E:1}disabled{}",
            "{C:attention}Overscoring{} is substantially harsher"
        }
    },
    pos = {x=7, y=7},
    atlas = "main",
    apply = function()
        config_reset()
        G.GAME.disable_ante_gain = true
        G.GAME.ante_config.base_exponent = 1.4
        G.GAME.ante_config.arrow_exponent = 1.05
        G.GAME.ante_config.ante_exponent = 2
    end
}

SMODS.Back {
    key = "encore",
    loc_txt = {
        name = "Encore Deck",
        text = {
            "After hand scores,",
            "all joker {C:attention}end-of-round{}",
            "effects are triggered",
        }
    },
    pos = {x=7, y=8},
    atlas = "main",
    calculate = function(center, back, context)

        if context.after then
            
            for i,joker in ipairs(G.jokers.cards) do

                local res = eval_card(joker, {end_of_round = true, main_eval = true})
                card_eval_status_text(joker, "extra", nil, nil, nil, res)

            end

        end

    end
}