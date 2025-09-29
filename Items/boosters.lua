SMODS.Booster {
    key = "ascended_booster",
    atlas = "main",
    pos = {x=4, y=9},
    discovered = true,
    loc_txt = {
        name = "Ascended Booster Pack",
        text = {
            "Pick {C:attention}#1#{} of up to {C:attention}#2#{} {C:cry_ascendant}Powerful{} cards",
            "to use immediately or take",
        },
        group_name = "Ascended Booster Pack"
    },
    valk_artist = "Scraptake",
    draw_hand = false,
    config = {choose = 1, extra = 3},

    loc_vars = function(self, info_queue, card) 
        return {vars = {card.ability.choose, card.ability.extra}}
    end,

    weight = 0.7,
    cost = 50,

    create_card = function(self, card, i)
        ease_background_colour({new_colour = G.C.CRY_ASCENDANT})
        --TODO: FIX
        local r = pseudorandom("valk_ascended_pack", 1, 5)
        if (r == 1) then
            return create_card("Superplanet", G.pack_cards, nil, nil, true, nil, nil, "valk_ascended_pack")
        else
            local choices = {}
            -- add either 10 instances or floor(100*soul_rate) then pick randomly

            for i,center in ipairs(G.P_CENTER_POOLS.Spectral) do

                if center.hidden and center.key then

                    if center.soul_rate then
                        for _=1,math.floor(center.soul_rate*100)+1 do choices[#choices+1] = center.key end
                    else
                        for _=1,10 do choices[#choices+1] = center.key end
                    end

                end

            end


            local pick = pseudorandom("valk_ascended_pack", 1, #choices)
            

            return create_card("Consumable", G.pack_cards, nil, nil, true, nil, choices[pick], "valk_ascended_pack")
        end

    end,
    in_pool = function(self, args)
        return to_big(G.GAME.dollars) > to_big(self.cost)
    end
}

SMODS.Booster {
    key = "deckfixing",
    atlas = "main",
    pos = {x=7, y=2},
    discovered = true,
    loc_txt = {
        name = "Deck-Fixing Pack",
        text = {
            "Pick {C:attention}#1#{} of {C:attention}#2#{} {C:attention}deck-fixing{} cards to use immediately",
        },
        group_name = "Deck-Fixing Pack"
    },
    valk_artist = "mailingway",
    draw_hand = true,
    config = {choose = 1, extra = 3},

    loc_vars = function(self, info_queue, card) 
        return {vars = {card.ability.choose, card.ability.extra}}
    end,

    weight = 1.2,
    cost = 9,

    create_card = function(self, card, i)
        ease_background_colour(G.C.ORANGE)
        local choices = {"c_death", "c_hanged_man", "c_cryptid", "c_strength"} --will add freeway when it exists
        local pick = pseudorandom("valk_deckfixing_pack", 1, #choices)
            

        return create_card("Consumable", G.pack_cards, nil, nil, true, nil, choices[pick], "valk_deckfixing_pack")

    end,
}