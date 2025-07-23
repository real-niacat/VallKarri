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
            "{C:valk_superplanet}Superplanets{} appear {C:attention}#1#X{} more frequently in the shop",
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

