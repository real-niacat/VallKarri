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
    pools = { ["Kitties"] = true },
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
                ease_dollars(card.ability.extra.money)
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
    config = { extra = {gm = 10, gx = 0.2, m = 0, x = 1} },
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