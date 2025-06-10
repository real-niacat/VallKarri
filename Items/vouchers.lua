local decks = {
    ["Red Deck"] = function(redeeming, context)
        if redeeming then SMODS:change_discard_limit(2) end
    end,
    ["Blue Deck"] = function(redeeming, context)
        if redeeming then SMODS:change_play_limit(2) end
    end,
    ["Yellow Deck"] = function(redeeming, context)
        if redeeming then G.GAME.eor_earn = 2
        elseif context.end_of_round and context.main_eval then
            ease_dollars(G.GAME.eor_earn)
        end
    end,
    ["Green Deck"] = function(redeeming, context)
        if redeeming then G.GAME.modifiers.money_per_discard = G.GAME.modifiers.money_per_discard + 1 end
    end,
    ["Black Deck"] = function(redeeming, context)
        if redeeming then G.GAME.refund_hands = true
        elseif G.GAME.refund_hands and context.before and context.scoring_name and context.scoring_name == mostplayed_name() then
            ease_hands_played(0.5)
        end
    end,
    ["Magic Deck"] = function(redeeming, context)
        if redeeming then G.GAME.consumable_after_round = true
        elseif G.GAME.consumable_after_round and context.end_of_round and context.main_eval then
            
            local type = pseudorandom("valk_quantum_magicdeck", 1, 2) == 1 and "Spectral" or "Tarot"
            local c = create_card(type, G.consumeables, nil, nil, nil, nil, nil, "valk_quantum_magicdeck")
            c:add_to_deck()
            c:set_edition("e_negative", true)
            G.consumeables:emplace(c)

        end
    end,
    ["Nebula Deck"] = function(redeeming, context)
        if redeeming then G.GAME.consume_planets = true
        elseif G.GAME.consume_planets and context.end_of_round and context.main_eval then

            for i,consumable in ipairs(G.consumeables.cards) do
                if consumable.ability and consumable.ability.hand_type then
                    local amt = Overflow and consumable.ability.immutable.overflow_amount or 1
                    level_up_hand(consumable, consumable.ability.hand_type, nil, amt)
                end
            end

        end
    end,
    ["Ghost Deck"] = function(redeeming, context)
        if redeeming then G.GAME.reroll_consumables = true
        elseif G.GAME.reroll_consumables and context.selling_card and context.card.sell_cost > 0 and context.card.ability.set == "Spectral" then
            local c = create_card("Spectral", G.consumeables, nil, nil, nil, nil, nil, "valk_quantum_magicdeck")
            c:add_to_deck()
            c:set_edition("e_negative", true)
            G.consumeables:emplace(c)
            c.sell_cost = 0
        end
    end,
    ["Abandoned Deck"] = function(redeeming, context)
        if redeeming then G.GAME.suitconvert = true
        elseif G.GAME.suitconvert and context.individual and context.other_card and context.other_card.area == G.play then

            if context.other_card.base.suit == "Clubs" then
                SMODS.change_base(context.other_card, "Spades")
            elseif context.other_card.base.suit == "Diamonds" then
                SMODS.change_base(context.other_card, "Hearts")
            end

        end 
    end,
    ["Checkered Deck"] = function(redeeming, context)
        if redeeming then G.GAME.rankconvert = true
        elseif G.GAME.rankconvert and context.individual and context.other_card and context.other_card.area == G.play then
            -- print("success 1")
            if context.other_card.base.suit == "Spades" then
                -- print("success 2")
                SMODS.change_base(context.other_card, context.other_card.base.suit, "14")
            elseif context.other_card.base.suit == "Hearts" then
                -- print("success 3")
                SMODS.change_base(context.other_card, context.other_card.base.suit, "9")
            elseif context.other_card.base.suit == "Clubs" then
                -- print("success 4")
                SMODS.change_base(context.other_card, context.other_card.base.suit, "7")
            elseif context.other_card.base.suit == "Diamonds" then
                -- print("success 5")
                SMODS.change_base(context.other_card, context.other_card.base.suit, "2")
            end

        end 
    end,
    ["Zodiac Deck"] = function(redeeming, context)
        if redeeming then mspl(3) end
    end,
    ["Painted Deck"] = function(redeeming, context)
        if redeeming then G.GAME.handsize_on_sell = 1 end
    end,
    ["Anaglyph Deck"] = function(redeeming, context)
        if redeeming then G.GAME.doubletag_create = true end
    end,
    ["Plasma Deck"] = function(redeeming, context)
        if redeeming then G.GAME.price_mod = -1 end
    end,
    ["Erratic Deck"] = function(redeeming, context)
        if redeeming then G.GAME.randomize_card = true end
    end,
}

-- this is for crossmod compat, if you'd like to add a deck to compatibility with Quantum Particle
-- simply pass in the name of the deck (capitalization matters) and a function(redeeming, context) which will be called
-- when redeemed and whenever anything happens
function vallkarri.add_quantum_deck(deckname, func)
    decks[deckname] = func
end 


SMODS.Voucher {
    key = "quantumparticle",
    atlas = "main",
    pos = {x=7, y=4},
    loc_txt = {
        name = "{C:cry_azure}Quantum Particle{}",
        text = {
            "Severely {C:attention,E:1}enhances{} your deck",
            "{C:inactive,s:0.85}(If applicable){}",
            "{C:inactive,s:0.8}(Is #1##2# on current deck)",
        }
    },

    loc_vars = function(self, info_queue, card)

        if G and G.GAME and G.GAME.selected_back and decks[G.GAME.selected_back.name] then
            return {vars = {"applicable", ""}}
        else
            return {vars = {"", "not applicable"}}
        end

    end,

    in_pool = function()
        local v = table:contains(decks, G.GAME.selected_back.name)
        return v
    end,

    redeem = function(self, card)
        local deckname = G.GAME.selected_back.name
        if decks[deckname] then
            decks[deckname](true, nil)
        end
    end,

    calculate = function(self, card, context)
        local deckname = G.GAME.selected_back.name
        if decks[deckname] then
            decks[deckname](false, context)
        end

        
         
    end

    


}