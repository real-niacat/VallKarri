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

SMODS.Back {
    key = "tauic",
    loc_txt = {
        name = "Tauic Deck",
        text = {
            "{C:cry_ember}Tauic{} Jokers do not need {C:attention}Tauist{} to spawn",
            "and spawn {C:attention}2x{} more often.",
            "{C:attention}0.5x{} {C:cry_ember}Tauic{} Joker chance increase"
        }
    },

    config = { rate = 2, inc = 0.5 },
    pos = {x=7, y=9},
    atlas = "main",
    apply = function(self)
        G.GAME.tauic_deck = true
    end
}

SMODS.Back {
    key = "sunbeam",
    loc_txt = {
        name = "Sunbeam Deck",
        text = {
            "Start with {C:attention,T:v_valk_legendary_perkup}Legendary PERK-UP{},",
            "{C:attention,T:v_valk_exotic_perkup}Exotic PERK-UP{}, and ",
            "{C:attention,T:v_valk_prestige_up}PRESTIGE-UP{}",
        }
    },
    config = { vouchers = { "v_valk_legendary_perkup", "v_valk_exotic_perkup", "v_valk_prestige_up" } },
    pos = {x=9, y=8},
    atlas = "main",
}