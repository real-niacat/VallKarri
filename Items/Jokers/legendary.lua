SMODS.Joker {
    key = "niko",
    loc_txt = {
        name = "Niko Gray",
        text = {
            "When blind selected, {C:red}debuff{} leftmost joker and {C:attention}double{} its values",
            "Remove {C:red}debuff{} from all jokers at end of round",
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
            "Creates a random {C:attention}food joker{} at end of round.",
            "When boss blind defeated, Increase ",
            "{C:attention}sell value{} of all food jokers by {C:attention}X#1#{}.",
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

SMODS.Joker {
    key = "cassknows",
    loc_txt = {
        name = "Cass None",
        text = {
            "Gains {C:mult}+#1#{} Mult and {X:mult,C:white}X#2#{} XMult",
            "if played hand is {C:attention}None{}",
            "{C:inactive}(Currently {C:mult}+#3#{C:inactive} Mult and {X:mult,C:white}X#4#{C:inactive} XMult)"
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