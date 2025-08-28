SMODS.Back {
    key = "inertia",
    loc_txt = {
        name = "Inertia Deck",
        text = {
            "Normal ante gain is {C:red,E:1}disabled{}",
            "{C:attention}Overscoring{} is substantially harsher",
            credit("Scraptake")
        }
    },
    pos = {x=7, y=7},
    atlas = "main",
    apply = function()
        config_reset()
        G.GAME.disable_ante_gain = true
        G.GAME.overscoring_threshold_base = 2
    end
}

SMODS.Back {
    key = "encore",
    loc_txt = {
        name = "Encore Deck",
        text = {
            "After hand scores,",
            "all Joker {C:attention}end-of-round{}",
            "effects are triggered",
            credit("Scraptake")
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
            "{C:cry_ember}Tauic{} Jokers spawn {C:attention}five times{} as often.",
            "and have their {C:green}chance{} increase when the roll fails",
            "{C:attention}X#1#{} Effective Ante",
            -- "{C:attention}X3{} Blind Size",
            credit("Scraptake")
        }
    },

    config = { rate = 2, inc = 0.5, eante = 2},
    pos = {x=7, y=9},
    atlas = "main",
    apply = function(self)
        G.GAME.tauic_deck = true
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                self.config.eante
            }
        }
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
            "{C:attention}X#1#{} Effective Ante when a card is bought",
            credit("Scraptake")
        }
    },
    config = { vouchers = { "v_valk_legendary_perkup", "v_valk_exotic_perkup", "v_valk_prestige_up" }, eante = 1.05 },
    pos = {x=9, y=8},
    atlas = "main",
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.eante } }
    end,
    calculate = function(self, card, context)
        if context.buying_card then
            -- print("joker obtained")
            vallkarri.add_effective_ante_mod(function(x) return x * self.config.eante end) --no data to store, no self-destruct condition
        end
    end,
}

if AKYRS then

    SMODS.Back {
        key = "hyperalphabetical",
        loc_txt = {
            name = "Hyperalphabetical Deck",
            text = {
                "Letters-only deck",
                "{C:attention}+8{} Hand Size",
                "The shop does {C:red}not exist{}",
                "{C:attention}X10{} Blind Size",
                "{C:attention}Infinite{} card selection limit",
                "Spelling a card {C:attention}creates it{}",
                "{C:red}Pointer blacklist{} applies to spelled words",
                credit("aikoyori")
            }
        },
        pos = {x=10, y=8},
        atlas = "main",
        calculate = function(center, back, context)

            if G.GAME.akyrs_character_stickers_enabled and G.GAME.akyrs_wording_enabled and context.before then
                local word = ""

                for i,pcard in ipairs(G.play.cards) do
                    local letter = pcard.ability.aikoyori_letters_stickers
                    if letter then word = word .. letter end 
                end

                -- print(word)

                for i,cen in pairs(G.P_CENTERS) do
                    local check = localize({type="name_text", set=cen.set, key=cen.key}):gsub(" ", ""):lower()
                    if tostring(word):lower() == check then
                        -- print("succeeded against " .. check)
                        -- print("attempting creation")
                        local ar = area_by_key(cen.key)
                        local blist = Cryptid.pointergetblist(cen.key) or {}
                        if ar and blist and (not blist[1]) then
                            -- print("cardarea exists")
                            local card = create_card(cen.set, ar, nil, nil, nil, nil, cen.key, "valk_hyperalphabetical")
                            card:add_to_deck()
                            ar:emplace(card)
                        end
                    

                        


                    end
                end
                
            end

        end,
        apply = function(self, back)
            G.GAME.akyrs_always_skip_shops = true
        end,
        dependencies = {"aikoyorisshenanigans"},
        config = {
            akyrs_starting_letters = AKYRS.scrabble_letters,
            starting_deck_size = 100,
            akyrs_selection = 1e100,
            discards = 2,
            akyrs_start_with_no_cards = true,
            akyrs_letters_mult_enabled = true,
            akyrs_hide_normal_hands = true,
            hand_size = 8,
            ante_scaling = 10,
            vouchers = {'v_akyrs_alphabet_soup','v_akyrs_crossing_field'}
        },
    }

end

