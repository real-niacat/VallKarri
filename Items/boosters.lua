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
            credit("Scraptake (Edit by Grahkon)")
        },
        group_name = "Ascended Booster Pack"
    },

    draw_hand = false,
    config = {choose = 1, extra = 7},

    loc_vars = function(self, info_queue, card) 
        return {vars = {card.ability.choose, card.ability.extra}}
    end,

    weight = 0.666,
    cost = 99,

    create_card = function(self, card, i)
        ease_background_colour(G.C.CRY_ASCENDANT)
        local r = pseudorandom("valk_ascended_pack", 1, 3)
        if (r == 1) then
            return create_card("Superplanet", G.pack_cards, nil, nil, true, nil, nil, "valk_ascended_pack")
        elseif r == 2 then
            local choices = {"c_valk_absolutetau", "c_valk_memoryleak", "c_valk_freeway"} --will add freeway when it exists
            local pick = pseudorandom("valk_ascended_pack", 1, #choices)
            

            return create_card("Consumable", G.pack_cards, nil, nil, true, nil, choices[pick], "valk_ascended_pack")
        elseif r == 3 then
            local choices = {"c_valk_perfected_gem", "c_valk_socket", "c_valk_binding_energy", "c_valk_halo_fragment"} --will add freeway when it exists
            local pick = pseudorandom("valk_ascended_pack", 1, #choices)
            

            return create_card("Consumable", G.pack_cards, nil, nil, true, nil, choices[pick], "valk_ascended_pack")
        end

    end,
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
            credit("Scraptake")
        },
        group_name = "Deck-Fixing Pack"
    },

    draw_hand = true,
    config = {choose = 1, extra = 3},

    loc_vars = function(self, info_queue, card) 
        return {vars = {card.ability.choose, card.ability.extra}}
    end,

    weight = 1.2,
    cost = 9,

    create_card = function(self, card, i)
        ease_background_colour(G.C.ORANGE)
        local choices = {"c_death", "c_hanged_man", "c_cryptid", "c_strength", "c_cry_ctrl_v"} --will add freeway when it exists
        local pick = pseudorandom("valk_deckfixing_pack", 1, #choices)
            

        return create_card("Consumable", G.pack_cards, nil, nil, true, nil, choices[pick], "valk_deckfixing_pack")

    end,
}