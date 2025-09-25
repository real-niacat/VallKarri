-- SMODS.Joker {
local orivander = {
    key = "orivander",
    loc_txt = {
        name = "Orivander",
        text = {
            "Creates an Eternal {C:attention}Gravity Well{} when obtained.",
            "Allows for building up score and releasing it all across multiple hands.",
            quote("orivander"),
            credit("Scraptake")
        },
    },
    config = { extra = {} },
    loc_vars = function(self, info_queue, card)

    end,

    cost = 50,
    rarity = "valk_exquisite",
    atlas = "main",
    pos = {x = 0, y = 1},
    soul_pos = {x = 1, y = 1},
    calculate = function(self, card, context)

    end,
    --  (select(2, next(SMODS.find_card("c_valk_gravitywell")))):quick_dissolve()
    add_to_deck = function(self, card, from_debuff)
        if (not from_debuff) then
            local ability = create_card("Consumable", G.consumeables, nil, nil, nil, nil, "c_valk_gravitywell", "orivander")
            ability:add_to_deck()
            
            G.consumeables:emplace(ability)
            ability.ability.eternal = true
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if (not from_debuff) then
            local found = SMODS.find_card("c_valk_gravitywell")
            if #found > 0 then
                (select(2, next(found))):quick_dissolve()
            end
        end
    end,
}

SMODS.Joker {
    key = "illena",
    loc_txt = {
        name = "Illena Vera",
        text = {
            "Multiply playing card values by {C:attention}X#1#{} when scored.",
            "Multiply all Joker values by {C:attention}X#2#{} when any playing card scored.",
            "{C:inactive}(Does not include Illena Vera){}",
            quote("illena"),
            credit("Scraptake")
        }
    },
    config = { extra = { strong = 1.4444, mid = 1.04444 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.strong, card.ability.extra.mid} }
    end,
    rarity = "valk_exquisite",
    atlas = "main",
    pools = { ["Kitties"] = true },
    pos = {x=0,y=2},
    soul_pos = {x=1, y=2},
    cost = 50,
    demicoloncompat = true,
    calculate = function(self, card, context)
        
        if (context.individual and context.cardarea == G.play) or context.forcetrigger then
            Cryptid.manipulate(context.other_card, {value=card.ability.extra.strong})


            for i,c in ipairs(G.jokers.cards) do
                if (c.config.center_key ~= "j_valk_illena") then
                    Cryptid.manipulate(c, {value=card.ability.extra.mid})
                end
                
            end
        end

    end,
    lore = {
        "Illena is a Fellinian, who was in her early life used as a",
        "test subject by the EMC, causing her to develop psychic powers.",
        "",
        "These powers allow her to read the mind of people, initially",
        "being a weak form of mind reading, which becomes stronger over time.",
        "",
        "She chooses to isolate herself from people, but also cares for people.",
        "This makes it a tough balance between her sanity and her empathy.",
        "",
        "Illena's extreme obsession with people and their mental makes her unreliable",
        "in other parts of life, often forgetting to take care of herself."
    }
}

SMODS.Joker {
    key = "arris",
    loc_txt = {
        name = "Arris",
        text = {
            "{C:valk_superplanet}Superplanets{} appear {C:attention}X#1#{} more frequently in the shop",
            "Using a {C:valk_superplanet}Superplanet{} generates {C:attention}#2#{} random {C:planet}Planetoids{}",
            "Using a {C:planet}Planetoid{} generates {C:attention}#2#{} random {C:planet}Planets{}",
            credit("Scraptake")
        }
    },
    config = { extra = {rate = 200, copies = 2} },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.rate, card.ability.extra.copies} }
    end,
    rarity = "valk_exquisite",
    atlas = "main",
    pos = {x=8,y=14},
    soul_pos = {x=9,y=14},
    cost = 50,
    demicoloncompat = true,
    blueprint_compat = true,
   
    calculate = function(self, card, context)

        if context.using_consumeable and context.consumeable.config.center.set == "Superplanet" then
            for i=1,card.ability.extra.copies do
                local c = create_card("Planetoid", G.consumeables, nil, nil, nil, nil, nil, "valk_arris")
                c:add_to_deck()
                G.consumeables:emplace(c)
            end
            quick_card_speak(card,"We have much to discover, don't we?")
        end

        if context.using_consumeable and context.consumeable.config.center.set == "Planetoid" then
            for i=1,card.ability.extra.copies do
                local c = create_card("Planet", G.consumeables, nil, nil, nil, nil, nil, "valk_arris")
                c:add_to_deck()
                G.consumeables:emplace(c)
            end
        end
        
    end,
 
    add_to_deck = function(self, card, from_debuff )
        if not from_debuff then
            G.GAME.superplanet_rate = G.GAME.superplanet_rate * card.ability.extra.rate
        end
    end,  

    remove_from_deck = function(self, card, from_debuff )
        if not from_debuff then
            G.GAME.superplanet_rate = G.GAME.superplanet_rate / card.ability.extra.rate
        end
    end,   

        lore = {
        "A 23 year old skeleton who was transformed into such ",
        "due to an incorrect death, as well as his family.",
        "",
        "Not much is known about his human life, ",
        "other than the fact that he had yellow hair and yellow eyes.",
        "",
        "Cursed with this second chance at life, he tries to make the most out of every day,",
        "no matter how much pain he went through, and unknown to him...",
        "...he is about to go through so much more. ",
        "",
        "He likes to spend his days going on walks or spending time in the park,",
        "embracing the wild life that goes about."
    }
}


SMODS.Joker {
    key = "libratpondere",
    loc_txt = {
        name = "Librat Pondere",
        text = {
            "{X:dark_edition,C:white}^#1#{} Chips per {C:blue}blue team{} member in the {C:attention}VallKarri{} discord server",
            "{X:dark_edition,C:white}^#2#{} Mult per {C:red}red team{} member in the {C:attention}VallKarri{} discord server",
            "{C:inactive}(Currently {X:dark_edition,C:white}^#3#{C:inactive} Chips and {X:dark_edition,C:white}^#4#{C:inactive} Mult)",
            "{V:1,S:0.7}https://discord.gg/5d3HWu88yn{}",
            credit("Scraptake")
        }
    },
    config = { extra = { perblue = 0.02, perred = 0.02 } },
    loc_vars = function(self, info_queue, card)
        
        return {vars = {
            card.ability.extra.perblue,
            card.ability.extra.perred,
            1 + (card.ability.extra.perblue * vallkarri.librat_vals.blue),
            1 + (card.ability.extra.perred * vallkarri.librat_vals.red),
            colours = {
                HEX("7289DA")
            }
        }}
    end,
    rarity = "valk_exquisite",
    atlas = "main",
    pos = {x = 7, y = 5},
    soul_pos = {x = 9, y = 5, extra = {x = 8, y = 5}},
    cost = 50,
    demicoloncompat = true,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        
        -- vallkarri.librat_vals.blue, vallkarri.librat_vals.red

        if context.joker_main then
            return {
                emult = 1 + (card.ability.extra.perred * vallkarri.librat_vals.red),
                echips = 1 + (card.ability.extra.perblue * vallkarri.librat_vals.blue)
            }
        end
    end
}

SMODS.Joker {
    key = "scraptake",
    loc_txt = {
        name = "Scraptake",
        text = {
            "{C:red}Lose all money{} when hand played",
            "Earn {C:money}$#1#{} for each hand played this run at end of round",
            quote("scraptake"),
            credit("Scraptake")
        }
    },
    config = { extra = { per = 3 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.per} }
    end,
    rarity = "valk_exquisite",
    atlas = "main",
    pos = {x = 7, y = 0},
    soul_pos = {x = 9, y = 0, extra = {x = 8, y = 0}},
    cost = 50,
    pools = { ["Kitties"] = true },
    calculate = function(self, card, context)
        if context.before then
            G.E_MANAGER:add_event(Event({
                func = function()
                    ease_dollars(-G.GAME.dollars)
                    G.GAME.dollars = 0
                    return true
                end
            }))
            
        end
    end,

    calc_dollar_bonus = function(self, card)
        return G.GAME.hands_played * card.ability.extra.per
    end,
}

SMODS.Joker {
    key = "madstone_whiskey",
    loc_txt = {
        name = "Madstone Whiskey",
        text = {
            "When a booster pack is skipped, create a {C:dark_edition}Negative{} {C:attention}The Fool{}",
            "When {C:attention}The Fool{} is used, create {C:attention}#1#{} random tag",
            "Increase by {C:attention}#2#{} when {C:attention}Boss Blind{} defeated",
            credit("Pangaea")
        }
    },
    config = { extra = { tags = 1, increase = 1 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.tags, card.ability.extra.increase} }
    end,
    rarity = "valk_exquisite",
    atlas = "main",
    pos = {x = 5, y = 12},
    soul_pos = {x = 5, y = 13, extra = {x = 5, y = 14}},
    cost = 50,
    immutable = true,
    calculate = function(self, card, context)
        if context.skipping_booster then
            local fool = SMODS.create_card({key = "c_fool", edition = "e_negative"})
            fool:add_to_deck()
            G.consumeables:emplace(fool)
        end

        if context.using_consumeable and context.consumeable and context.consumeable.config.center.key == "c_fool" then
            for i=1,card.ability.extra.tags do
                add_random_tag("valk_madstone_whiskey")
            end
        end

        if context.end_of_round and context.main_eval and G.GAME.blind.boss then
            card.ability.extra.tags = card.ability.extra.tags + card.ability.extra.increase
            card.ability.extra.tags = math.min(card.ability.extra.tags, 40)
            card.ability.extra.increase = math.min(card.ability.extra.increase, 40)
        end
    end,
}

SMODS.Joker {
    key = "astracola",
    loc_txt = {
        name = "Astracola",
        text = {
            "Create {C:attention}#1# Meteor Tags{} when blind skipped",
            "Increase tags by {C:attention}#2#{} when a {C:planet}Planet{} card is used",
            "At {C:attention}#3#{} tags, reset back to {C:attention}#4#{} and increase",
            "Chips and Mult per level on all hands by {C:attention}X#5#{}",
            credit("Pangaea")
        }
    },
    config = { extra = { tags = 2, tags_base = 2, inc = 1, max = 5, mult = 5 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_TAGS.tag_meteor
        return {vars = { card.ability.extra.tags, card.ability.extra.inc, card.ability.extra.max, card.ability.extra.tags_base, card.ability.extra.mult } }
    end,
    rarity = "valk_exquisite",
    atlas = "main",
    pos = {x = 6, y = 12},
    soul_pos = {x = 6, y = 13, extra = {x = 6, y = 14}},
    cost = 50,
    immutable = true,
    calculate = function(self, card, context)
        
        if context.skip_blind then

            for i=1,card.ability.extra.tags do
                add_tag(Tag("tag_meteor"))
            end

        end

        if context.using_consumeable and context.consumeable and context.consumeable.config.center.set == "Planet" then
            card.ability.extra.tags = card.ability.extra.tags + card.ability.extra.inc
            quick_card_speak(card, localize("k_upgrade_ex"))
            if card.ability.extra.tags > card.ability.extra.max then
                card.ability.extra.tags = card.ability.extra.tags_base
                quick_card_speak(card, localize("k_reset"))
                for name,_ in pairs(G.GAME.hands) do
                    G.GAME.hands[name].l_chips = G.GAME.hands[name].l_chips * card.ability.extra.mult
                    G.GAME.hands[name].l_mult = G.GAME.hands[name].l_mult * card.ability.extra.mult 
                end
            end
        end

    end,
}

SMODS.Joker {
    key = "phylactequila",
    loc_txt = {
        name = "Phylactequila",
        text = {
            "Create a {C:spectral}Spectral{} card when any other {C:attention}Consumable{} is used",
            "Fill empty {C:attention}Consumable{} slots with random {C:planet}Planet{} cards if",
            "played {C:attention}poker hand{} is a {C:attention}#1#{}",
            "{C:inactive}(Poker Hand changes at end of round)",
            credit("Pangaea")
        }
    },
    config = { extra = { hand = "Four of a Kind" } },
    loc_vars = function(self, info_queue, card)
        return {vars = {localize(card.ability.extra.hand, "poker_hands")} }
    end,
    rarity = "valk_exquisite",
    atlas = "main",
    pos = {x = 7, y = 12},
    soul_pos = {x = 7, y = 13, extra = {x = 7, y = 14}},
    cost = 50,

    calculate = function(self, card, context)
        if context.before and context.scoring_name == card.ability.extra.hand then
            for i=1,(G.consumeables.config.card_limit - G.consumeables.config.card_count) do
                local c = SMODS.add_card({set = "Planet", area = G.consumeables})
                quick_card_speak(card, localize("k_plus_planet"))
            end
        end

        if context.using_consumeable and context.consumeable.config.center.set ~= "Spectral" then
            SMODS.add_card({set = "Spectral", area = G.consumeables})
            quick_card_speak(card, localize("k_plus_spectral"))
        end

        if context.end_of_round and context.main_eval then
            card.ability.extra.hand = pseudorandom_element(G.handlist, "valk_phylactequila")
        end
    end,
    
}