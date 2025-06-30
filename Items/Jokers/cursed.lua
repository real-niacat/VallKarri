SMODS.Joker {
    key = "killmult",
    loc_txt = {
        name = "Avulsion",
        text = {
            "Permanently disables {C:mult}Mult{} in {C:attention}#1#{} rounds",
            "{C:inactive,s:0.6}(Yes, this does everything you think it does.)",
            "{C:red,E:1}Dramatically{} set money to {C:money}-$#2#{} when removed",
        }
    },
    config = { extra = { rounds = 7 }, immutable = {drama = 66} },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.rounds, card.ability.immutable.drama}}
    end,
    rarity = "valk_supercursed",
    atlas = "main",
    pos = {x=9, y=6},
    cost = -1e10,
    immutable = true,
    demicoloncompat = true,
    calculate = function(self, card, context)
        
        if
			context.end_of_round
			and not context.blueprint
			and not context.individual
			and not context.repetition
			and not context.retrigger_joker
		then
            card.ability.extra.rounds = card.ability.extra.rounds - 1

            if (card.ability.extra.rounds <= 0) then
                disable_mult_ui()
                card_eval_status_text(card,"extra",nil,nil,nil,{message = "Multn't!"})
                card:quick_dissolve()
            end
        end

        if (context.forcetrigger) then
            disable_mult_ui()
            card_eval_status_text(card,"extra",nil,nil,nil,{message = "Multn't!"})
            card:quick_dissolve()
        end

        if context.selling_self then

            G.GAME.dollars = 0
            for i=1,card.ability.immutable.drama do
                ease_dollars(-1)
            end
        end

    end,

    add_to_deck = function(self, card, from_debuff)
        if from_debuff then return end
        card:set_eternal(true)
    end,
}

SMODS.Joker {
    key = "rooter",
    loc_txt = {
        name = "Hexaract",
        text = {
            "All Jokers give {X:dark_edition,C:white}^#1#{} Chips & Mult",
        }
    },
    config = { extra = { echips = 1 - (1/6) } },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.echips}}
    end,
    rarity = "valk_supercursed",
    atlas = "main",
    pos = {x=9, y=7},
    cost = -1e10,
    immutable = true,
    calculate = function(self, card, context)
        
        if context.other_joker and context.other_joker.ability.set == "Joker" then
			if not Talisman.config_file.disable_anims then
				G.E_MANAGER:add_event(Event({
					func = function()
						context.other_joker:juice_up(0.5, 0.5)
						return true
					end,
				}))
			end
			return {
				emult = card.ability.extra.echips,
                echips = card.ability.extra.echips,
			}
		end

    end,

    add_to_deck = function(self, card, from_debuff)
        card:set_eternal(true)
    end
}

SMODS.Joker {
    key = "nocards",
    loc_txt = {
        name = "Joker of None",
        text = {
            "Playing cards are {C:red,E:1}destroyed{} when scored",
        }
    },
    config = { extra = {}, immutable = {} },
    loc_vars = function(self, info_queue, card)
        return { vars = {}}
    end,
    rarity = "valk_supercursed",
    atlas = "main",
    pos = {x=8, y=7},
    cost = -1e10,
    calculate = function(self, card, context)
        
        if context.individual and context.other_card and context.cardarea == G.play then
            context.other_card:start_dissolve({G.C.BLACK}, nil, 2 * G.SETTINGS.GAMESPEED)
        end

    end,

    add_to_deck = function(self, card, from_debuff)
        card:set_eternal(true)
    end
}

-- local function is_allowed(key)
--     return G.P_CENTERS[key] and not key:find("j_valk")
-- end

-- SMODS.Joker {
--     key = "goddamnit",
--     loc_txt = {
--         name = "I Am Not Releasing This Card It Is Just For Testing",
--         text = {
--             "Inherits the effect of {C:attention,s:1.5,E:1}every{} modded joker",
--         }
--     },
--     config = { extra = {}, immutable = {} },
--     loc_vars = function(self, info_queue, card)
--         return { vars = {}}
--     end,
--     rarity = "valk_supercursed",
--     atlas = "phold",
--     pos = {x=0, y=0},
--     cost = 0,
--     calculate = function(self, card, context)
--         local f = "remove_from_deck"
--         for i,center in pairs(G.P_CENTERS) do
--             if G.P_CENTERS[i][f] and is_allowed(i) then
--                 print("running on " .. i .. " for calculate")
--                 G.P_CENTERS[i][f](self, card, context)
--             end
--         end
        
--     end,

--     add_to_deck = function(self, card, from_debuff)

--         local f = "add_to_deck"
--         for i,center in pairs(G.P_CENTERS) do
--             if G.P_CENTERS[i][f] and is_allowed(i) then
                
--                 if G.P_CENTERS[i].config and G.P_CENTERS[i].config.extra and type(G.P_CENTERS[i].config.extr) == "table" then
--                     for name,entry in pairs(G.P_CENTERS[i].config.extra) do
--                         if not card.ability.extra[name] then
--                             card.ability.extra[name] = entry
--                         end
--                     end
--                 end

--                 if G.P_CENTERS[i].config and G.P_CENTERS[i].config.immutable then
--                     for name,entry in pairs(G.P_CENTERS[i].config.immutable) do
--                         if not card.ability.immutable[name] then
--                             card.ability.immutable[name] = entry
--                         end
--                     end
--                 end

--                 print("running on " .. i .. " for add to deck")
--                 G.P_CENTERS[i][f](self, card, from_debuff)
--             end
--         end
--     end,

--     remove_from_deck = function(self, card, from_debuff)
--         local f = "remove_from_deck"
--         for i,center in pairs(G.P_CENTERS) do
--             if G.P_CENTERS[i][f] and is_allowed(i) then
--                 print("running on " .. i .. " for remove from deck")
--                 G.P_CENTERS[i][f](self, card, from_debuff)
--             end
--         end
--     end
-- }