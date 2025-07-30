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
    rarity = "cry_exotic",
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
    rarity = "cry_exotic",
    atlas = "main",
    pools = { ["Kitties"] = true },
    pos = {x=0,y=2},
    soul_pos = {x=1, y=2},
    cost = 50,
    demicoloncompat = true,
    calculate = function(self, card, context)
        
        if (context.individual and context.cardarea == G.play) or context.forcetrigger then
            Cryptid.misprintize(context.other_card, {min=card.ability.extra.strong, max=card.ability.extra.strong}, nil, true)


            for i,c in ipairs(G.jokers.cards) do
                if (c.config.center_key ~= "j_valk_illena") then
                    Cryptid.misprintize(c, {min=card.ability.extra.mid, max=card.ability.extra.mid}, nil, true)
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
    rarity = "cry_exotic",
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
    key = "lily",
    loc_txt = {
        name = "Lily Felli",
        text = {
            "{X:dark_edition,C:white}^#1#{} Mult for each Joker owned",
            "Increase by {X:dark_edition,C:white}^#2#{} for every card scored",
            "{C:inactive}(Currently {X:dark_edition,C:white}^#3#{C:inactive} Mult)",
            quote("lily"),
            quote("lily2"),
            credit("Scraptake")
        }
    },
    config = { extra = { per = 0.05, inc = 0.01 } },
    loc_vars = function(self, info_queue, card)
        local jkrs = 0
        if G.jokers then
            jkrs = #G.jokers.cards
        end
        return {
            vars = {
                card.ability.extra.per,
                card.ability.extra.inc,
                1 + (card.ability.extra.per * jkrs) 
            }
        }
    end,
    rarity = "cry_exotic",
    atlas = "main",
    pos = {x = 0, y = 0},
    soul_pos = {x=3,y=2},
    no_doe = true,
    cost = 50,
    demicoloncompat = true,
    calculate = function(self, card, context)

        

        if context.individual and context.cardarea == G.play then
            card.ability.extra.per = card.ability.extra.per + card.ability.extra.inc
            quick_card_speak(card, localize("k_upgrade_ex"))
        end

        if context.joker_main or context.forcetrigger then

            return {
                emult = 1 + (card.ability.extra.per * #G.jokers.cards)
            }

        end
        
    end,

    lore = {
        "Lily is a Fellinian Entropic Lord, this means",
        "she was exposed to a lot of entropy, and eventually mutating her.",
        "This allowed her to control entropy around her, similar to weak reality bending.",
        "",
        "As a person, Lily tries her best, but is inherently unstable mentally",
        "due to the effects of entropy on a person's mental health.",
        "",
        "Her entropic lord powers allow for heightened senses,",
        "so it doesn't affect her as much, but she can barely see!"
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
            credit("Scraptake")
        }
    },
    config = { extra = { perblue = 0.02, perred = 0.02 } },
    loc_vars = function(self, info_queue, card)
        
        return {vars = { card.ability.extra.perblue, card.ability.extra.perred, 1 + (card.ability.extra.perblue * vallkarri.librat_vals.blue), 1 + (card.ability.extra.perred * vallkarri.librat_vals.red)} }
    end,
    rarity = "cry_exotic",
    atlas = "main",
    pos = {x = 7, y = 5},
    soul_pos = {x = 9, y = 5, extra = {x = 8, y = 5}},
    cost = 50,
    immutable = true,
    demicoloncompat = true,
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
    rarity = "cry_exotic",
    atlas = "main",
    pos = {x = 7, y = 0},
    soul_pos = {x = 9, y = 0, extra = {x = 8, y = 0}},
    cost = 50,

    calculate = function(self, card, context)
        if context.before then
            ease_dollars(-G.GAME.dollars)
        end
    end,

    calc_dollar_bonus = function(self, card)
        return G.GAME.hands_played * card.ability.extra.per
    end,
}