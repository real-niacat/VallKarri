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