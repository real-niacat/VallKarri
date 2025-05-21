SMODS.Joker {
    key = "niko",
    loc_txt = {
        name = "Niko Gray",
        text = {
            "When blind selected, {C:red}debuff{} a random joker.",
            "This joker's values will be {C:attention}doubled{} and {C:red}un-debuffed{} upon cashing out.",
            quote("niko"),
            credit("Scraptake")
        }
    },
    config = { extra = { saved_joker = nil } },
    loc_vars = function(self, info_queue, card)

    end,
    rarity = 4,
    atlas = "main",
    pos = {x=0,y=4},
    soul_pos = {x=1,y=4},
    cost = 20,
    calculate = function(self, card, context)

        if (context.setting_blind) then 
            
            local allowed = {}
            for i,c in ipairs(G.jokers.cards) do
                if (c.config.center_key ~= "j_valk_niko") then
                    table.insert(allowed, c)
                end
            end
            local jkr = allowed[math.random(#allowed)]

            if (jkr) then
                card.ability.extra.saved_joker = jkr -- to save
                jkr.debuff = true
                Cryptid.misprintize(jkr, {min=2, max=2}, nil, true) --multiply values by 2
            end

        end

        if (context.starting_shop) then
            local jkr = card.ability.extra.saved_joker
            if (jkr) then
                jkr.debuff = false
                card.ability.extra.saved_joker = nil
            end
        end

    end
}

SMODS.Joker {
    key = "lilac",
    loc_txt = {
        name = "Lilac Lilybean",
        text = {
            "Creates a random {C:attention}food joker{} at end of round.",
            "Earn {C:money}$#1#{} when boss blind defeated.",
            quote("lilac"),
            credit("Scraptake")
        }
    },
    config = { extra = {money = 54.01} },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.money}}
    end,
    rarity = 4,
    atlas = "main",
    pos = {x=0,y=7},
    soul_pos = {x=1,y=7},
    cost = 20, 
    calculate = function(self, card, context)
        if (context.end_of_round and not context.blueprint and not context.individual) then

            local c = create_card("Food", G.jokers, nil, nil, nil, nil, nil, "valk_lilac")
            c:add_to_deck()
            G.jokers:emplace(c)

            if (G.GAME.blind.boss) then
                ease_dollars(card.ability.extra.money)
            end

        end
    end
}