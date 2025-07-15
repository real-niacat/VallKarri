SMODS.Joker {
    key = "niko",
    loc_txt = {
        name = "Niko Gray",
        text = {
            "When blind selected, {C:red}debuff{} leftmost Joker and {C:attention}double{} its values",
            "Remove {C:red}debuff{} from all Jokers at end of round",
            quote("niko"),
            credit("Scraptake")
        }
    },
    config = { extra = { saved_joker = nil } },
    loc_vars = function(self, info_queue, card)

    end,
    rarity = 4,
    atlas = "main",
    pools = { ["Kitties"] = true },
    pos = {x=0,y=4},
    soul_pos = {x=1,y=4},
    cost = 20,
    blueprint_compat = true,
    calculate = function(self, card, context)

        if (context.setting_blind) then 
            
            if G.jokers.cards[1] and G.jokers.cards[1].config.center.key ~= "j_valk_niko" then
                G.jokers.cards[1].debuff = true
                Cryptid.manipulate(G.jokers.cards[1], {type = "X", value = 2}) --oh no! hardcoding!
            end

        end

        if (context.end_of_round and context.main_eval) then
            for i,joker in ipairs(G.jokers.cards) do
                joker.debuff = false
            end
        end

    end
}

SMODS.Joker {
    key = "hornet",
    -- feb 14th 2019
    loc_txt = {
        name = "Hornet",
        text = {
            "{X:mult,C:white}X#1#{} Mult for every day since {C:attention}Hollow Knight Silksong{} was announced",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)",
            quote("hornet"),
            credit("Scraptake"),
        }
    },
    config = { extra = {gain = 0.1}},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.extra.gain, card.ability.extra.gain * days_since(2019, 2, 14)}}
    end,
    rarity = 4,
    atlas = "main",
    pos = {x=5,y=0},
    soul_pos = {x=6,y=0},
    cost = 20,
    demicoloncompat = true,
    calculate = function(self, card, context) 
        if (context.joker_main) or context.forcetrigger then
            return {x_mult = card.ability.extra.gain * days_since(2019, 2, 14)}
        end
    end

}

SMODS.Joker {
    key = "lilac",
    loc_txt = {
        name = "Lilac Lilybean",
        text = {
            "Creates a random {C:dark_edition}Negative{} {C:attention}Food Joker{} at end of round.",
            "When boss blind defeated, Increase ",
            "{C:attention}sell value{} of all Food Jokers by {C:attention}X#1#{}.",
            quote("lilac"),
            credit("Scraptake")
        }
    },
    config = { extra = {money = 5.4} },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.money}}
    end,
    rarity = 4,
    pools = { ["Kitties"] = true },
    atlas = "main",
    pos = {x=0,y=7},
    soul_pos = {x=1,y=7},
    cost = 20, 
    calculate = function(self, card, context)
        if (context.end_of_round and not context.repetition and not context.individual and not context.blueprint) then

            local c = create_card("Food", G.jokers, nil, nil, nil, nil, nil, "valk_lilac")
            c:add_to_deck()
            c:set_edition("e_negative", true)
            G.jokers:emplace(c)

            if (G.GAME.blind.boss) then
                
                for _i,joker in pairs(G.jokers.cards) do
                
                    local res = Cryptid.safe_get(joker.config.center, "pools", "Food")
                    for _j,pooljoker in pairs(G.P_CENTER_POOLS.Food) do
                        res = res or (pooljoker.key == joker.key)
                        -- print(pooljoker.key)
                    end

                    if res then
                        joker.sell_cost = joker.sell_cost * card.ability.extra.money
                    end
            
                end

            end

        end
    end
}
-- abcdefg
--    defg

SMODS.Joker {
    key = "cassknows",
    loc_txt = {
        name = "Cass None",
        text = {
            "Gains {C:mult}+#1#{} and {X:mult,C:white}X#2#{} Mult",
            "if played hand is {C:attention}None{}",
            "{C:inactive}(Currently {C:mult}+#3#{C:inactive} and {X:mult,C:white}X#4#{C:inactive} Mult)"
        }
    },
    config = { extra = {gm = 10, gx = 0.2, m = 10, x = 1} },
    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.extra.gm,
            card.ability.extra.gx,
            card.ability.extra.m,
            card.ability.extra.x
        }}
    end,
    rarity = 4,
    atlas = "main",
    pos = {x=7, y=6},
    soul_pos = {x=8, y=6},
    cost = 20,
    calculate = function(self, card, context)

        if context.before and context.scoring_name == "cry_None" then
            card.ability.extra.m = card.ability.extra.m + card.ability.extra.gm
            card.ability.extra.x = card.ability.extra.x + card.ability.extra.gx
            return {message = "Upgraded!"}
        end

        if context.joker_main then
            return {
                mult = card.ability.extra.m,
                xmult = card.ability.extra.x
            }
        end

    end
}

SMODS.Joker {
    key = "elder",
    loc_txt = {
        name = "Elder",
        text = {
            "Creates a random {C:attention}Crafting Ingredient{} at end of round",
            credit("Scraptake")
        }
    },
    config = { extra = {} },
    loc_vars = function(self, info_queue, card)
    end,
    rarity = 4,
    atlas = "main",
    pos = {x=0, y=8},
    soul_pos = {x=1, y=8},
    cost = 20,
    blueprint_compat = true,
    calculate = function(self, card, context)

        if context.end_of_round and context.main_eval then
            local valid = {"c_valk_binding_energy", "c_valk_perfected_gem", "c_valk_socket", "c_valk_halo_fragment"}
            local choice = valid[pseudorandom("valk_elder",1,#valid)]

            simple_create("Consumable", G.consumeables, choice)
        end

    end
}

SMODS.Joker {
    key = "kathleen",
    loc_txt = {
        name = "Kathleen Rosetail",
        text = {
            "{C:planet}Planet{} cards may replace {C:spectral}Spectral{} and {C:tarot}Tarot{} cards.",
            "When {C:attention}blind{} selected, add {C:attention}#1#{} editioned",
            "{C:attention}CCD{} {C:planet}planet{} cards to {C:attention}deck{}",
            credit("mailingway")
        }
    },
    config = { extra = {cards = 5} },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.cards}}
    end,
    rarity = 4,
    atlas = "main",
    pos = {x=0, y=11},
    soul_pos = {x=1, y=11},
    cost = 20,
    blueprint_compat = true,
    pools = { ["Kitties"] = true },
    immutable = true,
    calculate = function(self, card, context)

        if context.setting_blind then
            for i=1,card.ability.extra.cards do
                local _card = create_card("Base", G.play, nil, nil, nil, nil, nil, "valk_kathleen")
                SMODS.change_base(_card, random_suit(), random_rank())
                _card:set_edition(random_edition(), true)
                _card:set_ability(G.P_CENTER_POOLS.Planet[pseudorandom("valk_kathleen", 1, #G.P_CENTER_POOLS.Planet)])
                _card:add_to_deck()
                G.deck:emplace(_card)
                table.insert(G.playing_cards, _card)
                
            end

        end

    end,
    add_to_deck = function(self, card, from_debuff)
        if from_debuff then return end
        G.GAME.tarot_planet_replacement = 15
        G.GAME.spectral_planet_replacement = 15
    end,
    remove_from_deck = function(self, card, from_debuff)
        if from_debuff then return end
        if #SMODS.find_card("j_valk_kathleen") < 1 then
            G.GAME.tarot_planet_replacement = 0
            G.GAME.spectral_planet_replacement = 0
        end
    end
}

SMODS.Joker {
    key = "sinep",
    loc_txt = {
        name = "Sin E.P. Scarlett",
        text = {
            "When hand played, increase the values on a random ",
            "{C:attention}Joker{} between {C:attention}X#1#{} and {C:attention}X#2#{}",
            credit("mailingway")
        }
    },
    config = { extra = {min = 1.1, max = 6.9} },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.min, card.ability.extra.max}}
    end,
    rarity = 4,
    atlas = "main",
    pos = {x=0, y=12},
    soul_pos = {x=1, y=12},
    cost = 20,
    blueprint_compat = false,
    immutable = true,
    calculate = function(self, card, context)

        if context.before and not context.blueprint then
            local chosen = G.jokers.cards[pseudorandom("valk_sinep", 1, #G.jokers.cards)]
            if not Card.no(chosen, "immutable", true) then
				Cryptid.with_deck_effects(chosen, function(cards)
					Cryptid.manipulate(chosen,
                        {value = math.map(pseudorandom("valk_sinep"), 0, 1, card.ability.extra.min, card.ability.extra.max)})
				end)
			end
            
        end

    end,
}

SMODS.Joker {
    key = "tasal",
    loc_txt = {
        name = "TASAL",
        text = {
            "{C:attention}+#1#{} Card Selection Limit and Hand Size.",
            "{X:gold,C:white}X#2#{} Ascension scaling per level of {C:attention}Sol{}.",
            "When {C:planet}Planet{} card used, increase power of {C:attention}Ascended{} hands",
            credit("Grahkon")
        }
    },
    config = { extra = {csl = 3, scaling = 4} },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.c_cry_sunplanet
        return {vars = {card.ability.extra.csl, card.ability.extra.scaling + 1}}
    end,
    rarity = 4,
    atlas = "main",
    pos = {x=2, y=12},
    soul_pos = {x=3, y=12},
    cost = 20,
    blueprint_compat = false,
    calculate = function(self, card, context)

        if context.using_consumeable then
            if context.consumeable.ability.set == "Planet" then
                level_ascended_hands(1, card)
            end
            if context.consumeable.config.center.key == "c_cry_sunplanet" then
                level_ascended_hands(card.ability.extra.scaling, card)
            end
        end
        
    end,

    add_to_deck = function(self, card, from_debuff )
        if not from_debuff then
            G.hand:change_size(card.ability.extra.csl)
            SMODS.change_play_limit(card.ability.extra.csl)
            SMODS.change_discard_limit(card.ability.extra.csl)
        end
    end,
    remove_from_deck = function(self, card, from_debuff )
        if not from_debuff then
            G.hand:change_size(-card.ability.extra.csl)
            SMODS.change_play_limit(-card.ability.extra.csl)
            SMODS.change_discard_limit(-card.ability.extra.csl)
        end
    end,
}

SMODS.Joker {
    key = "maow",
    loc_txt = {
        name = "mrrp,,,, maow :3 ",
        text = {
            "{X:blue,C:white}X#1#{} Chips and {X:red,C:white}X#1#{} Mult",
            "{C:blue}+#1#{} Hands and {C:red}+#1#{} Discards",
            "{C:attention}+#1#{} Card Selection Limit and Hand Size",
            "When playing card is scored, earn {C:money}$#1#{}",
            credit("Scraptake"),
        } 
    },
    config = { extra = {meow = 3} },
     loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.meow}}
    end,
    rarity = 4,
    atlas = "main",
    pos = {x=4, y=12}, 
    cost = 20,
    immutable = false,
    blueprint_compat = false,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            ease_dollars(card.ability.extra.meow)
        end
        if (context.joker_main) or context.forcetrigger then
            return {x_mult = card.ability.extra.meow,x_chips = card.ability.extra.meow}

        end
        if (context.setting_blind) then
            ease_hands_played(card.ability.extra.meow)
            ease_discard(card.ability.extra.meow)
        end
    end,

    add_to_deck = function(self, card, from_debuff )
        if not from_debuff then
            G.hand:change_size(3)
            SMODS.change_play_limit(3)
            SMODS.change_discard_limit(3)
            
        end
    end,  
    remove_from_deck = function(self, card, from_debuff )
        if not from_debuff then
            G.hand:change_size(-3)
            SMODS.change_play_limit(-3)
            SMODS.change_discard_limit(-3)
            
        end
    end,     
}