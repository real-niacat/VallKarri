SMODS.ConsumableType {
    key = "SpecialCards",
    collection_rows = {3, 3},
    primary_colour = HEX("FFAFE7"),
    secondary_colour = HEX("FF7088"),
    shop_rate = 0,

    loc_txt = {
        collection = "Special Cards",
        label = "special",
        name = "Special Cards",
        undiscovered = {
            name = "go turn on unlock all",
            text = {
                "this mod is intended to be used",
                "with unlock all enabled"
            }
        }
    },
}






SMODS.Consumable {
    set = "SpecialCards",
    loc_txt = {
        name = "Gravity Well",
        text = {
            "{X:mult,C:white}X#1#{} Mult",
            "Once used, +{X:inactive}[S]{} to {C:money}final score{} for {X:inactive}[N]{} hands",
            "{C:inactive}S = Score while this card is active, increasing exponentially.{}",
            "{C:inactive}N = Total hands this card was active.{}",
            "{C:inactive,s:1.2}Score: #3#, Hands: #4#{}",
            "{C:inactive,s:1.5}Currenty #2#{}",
            credit("Scraptake")
        }
    },

    no_doe = true,

    config = { extra = { multifactor = 0.5, stored = to_big(0), active = true, rounds = 0} },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.multifactor, card.ability.extra.active and "charging up" or "discharging", card.ability.extra.stored, card.ability.extra.rounds}}
    end,

    can_use = function(self, card)
        -- currently only returns true need to make it only work when u have the joker.
        return true
    end,

    use = function(self, card, area, copier)
        if (card.ability.extra.active) then
            card.ability.extra.active = false
        else
            card.ability.extra.active = true
            card.ability.extra.stored = to_big(0)
        end
    end,

    keep_on_use = function(self, card)
        return true
    end,

    calculate = function(self, card, context)
        local active = card.ability.extra.active

        if (context.final_scoring_step and active) then --active is true by nature
            card.ability.extra.stored = to_big(card.ability.extra.stored + to_big(G.GAME.chips):pow(card.ability.extra.rounds/2))
            card.ability.extra.rounds = card.ability.extra.rounds + 1
            return {xmult = card.ability.extra.multifactor}
        end
        -- i have no fucking clue how elif works in lua
        if (context.final_scoring_step and not active) and card.ability.extra.rounds > 0 then
            G.GAME.chips = G.GAME.chips + card.ability.extra.stored
            card.ability.extra.rounds = card.ability.extra.rounds - 1
        end
    end,

    key = "gravitywell",
    pos = {x=2, y=0},
    -- soul_pos = {x=0,y=0},
    atlas = "main",
}

SMODS.Consumable {
    set = "SpecialCards",
    loc_txt = { 
        name = "The Lordess Call",
        text = {
            "{C:attention}+#1# Hand size {}and {C:attention}Card selection limit{}",
            "Creates {C:cry_azure,s:1.5}The Dormant Lordess{}",
            credit("Scraptake")
        }
    },
    key = "lordcall",
    pos = { x = 2, y = 1 },
    soul_pos = {x = 3, y = 1},
    atlas = "main",
    -- soul_rate = 0.00001, --0.001%

    loc_vars = function(self, info_queue, card)

        return {vars = { card.ability.extra.morecards }}
        
    end,

    can_use = function(self, card)
        return true
    end,

    config = { extra = { morecards = 9} },

    use = function(self, card, area, copier)
        G.hand:change_size(card.ability.extra.morecards)
        SMODS.change_play_limit(card.ability.extra.morecards)
        SMODS.change_discard_limit(card.ability.extra.morecards)
        G.hand.config.highlighted_limit = G.hand.config.highlighted_limit + card.ability.extra.morecards

        local lily = create_card("Joker", G.jokers, nil, nil, nil, nil, "j_valk_dormantlordess", "valk_lordcall")
        lily:add_to_deck()
        lily.ability.cry_absolute = true
        G.jokers:emplace(lily)
        lily:juice_up(0.3, 0.5)

    end
}

SMODS.Consumable {
    set = "Spectral",
    loc_txt = { 
        name = "Luck",
        text = {
            "Select {C:attention}#1#{} joker, change all values on selected joker by between {C:attention}X#2#{} and {C:attention}X#3#{}",
            credit("Scraptake"),
            concept("techwizard72")
        }
    },
    key = "luck",
    pos = { x = 4, y = 4 },
    atlas = "main",
    soul_rate = 0.07,
    -- is_soul = true,

    config = { extra = { jokers = 1, limit = 50, base = 1.2} },

    loc_vars = function(self, info_queue, card)

        return {vars = { card.ability.extra.jokers, card.ability.extra.base, card.ability.extra.base+(card.ability.extra.limit/100) }}
        
    end,

    can_use = function(self, card)
        return #G.jokers.highlighted <= card.ability.extra.jokers and #G.jokers.highlighted > 0
    end,

    

    use = function(self, card, area, copier)
        
        for i,c in ipairs(G.jokers.highlighted) do

            Cryptid.misprintize(c, {min=card.ability.extra.base, max=card.ability.extra.base+(card.ability.extra.limit/100)}, nil, true)

        end

    end
}

SMODS.Consumable {
    set = "Code",
    loc_txt = { 
        name = "://MEMORYLEAK",
        text = {
            "Make all jokers {C:dark_edition}Absolute{}, multiply their values by {C:attention}#1#{}",
            "set joker slots to {C:attention}[Jokers]+#2#{} and create an {C:cry_azure}Unsurpassed{} Joker",
            credit("Scraptake")
        }
    },
    key = "memoryleak",
    pos = { x = 3, y = 4 },
    atlas = "main",
    -- soul_rate = 0.07,
    soul_rate = 2,
    -- is_soul = true,

    config = { extra = { valuemult = 1e-10, create_new = true, inc = 1} },

    loc_vars = function(self, info_queue, card)

        return {vars = { number_format(card.ability.extra.valuemult), card.ability.extra.inc }}
        
    end,

    can_use = function(self, card)
        return true
    end,

    update = function(self, card, front)
        
        if (card.area == G.pack_cards and card.ability and card.ability.extra and card.ability.extra.create_new) then
            card.ability.extra.create_new = false
            card:quick_dissolve()
            simple_create("Consumable", G.consumeables, "c_valk_memoryleak")
        end

    end,

    add_to_deck = function(self, card, from_debuff)

        if (#G.jokers.cards > 0 ) then 
            for i,joker in ipairs(G.jokers.cards) do
                joker:set_eternal(true)
            end
        end
    end,

    remove_from_deck = function(self, card, from_debuff)

        if (#G.jokers.cards > 0 ) then 
            for i,joker in ipairs(G.jokers.cards) do
                joker:set_eternal(false)
            end
        end

    end,

    use = function(self, card, area, copier)
        
        G.jokers.config.card_limit = #G.jokers.cards + card.ability.extra.inc
        for i,c in ipairs(G.jokers.cards) do

            Cryptid.misprintize(c, {min=card.ability.extra.valuemult,max=card.ability.extra.valuemult}, nil, true)

            c.ability.cry_absolute = true

        end

        local jkr = create_card("Joker", G.jokers, nil, "valk_unsurpassed", nil, nil, nil, "c_valk_memoryleak")
        jkr:add_to_deck()
        G.jokers:emplace(jkr)

    end
}