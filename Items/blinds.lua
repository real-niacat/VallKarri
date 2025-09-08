SMODS.Atlas {
    key = "bli",
    path = "blinds.png",
    px = 34,
    py = 34,
    atlas_table = 'ANIMATION_ATLAS',
    frames = 21,
}

SMODS.Blind {
    key = "fanningflames",
    loc_txt = {
        name = "Fanning Flames",
        text = {
            "Played cards become perishable",
            "Cards held in hand become rental",
            "Must play at least 4 cards"
        }
    },
    -- art by pangaea
    atlas = "bli",
    pos = {y = 0, x = 0},
    boss = {min = 9, max = 0},
    boss_colour = HEX("EB7632"),
    dollars = 0,
    mult = 10,
    calculate = function(self, blind, context)
		if context.after then
            for i,c in ipairs(G.play.cards) do
			    c:set_perishable(true)
            end
		end

        if context.before then
            for i,c in ipairs(G.hand.cards) do
                c:set_rental(true)
            end
        end
	end,
    debuff_hand = function(self, cards, hand, handname, check)
        return (#cards < 4)
    end,
}

SMODS.Blind {
    key = "thechud",
    loc_txt = {
        name = "The Chud",
        text = {
            "Hands containing {C:attention}Feminine{}",
            "cards are not allowed"
        }
    },
    boss_colour = HEX("6E3D15"),
    dollars = 6,
    mult = 1,
    debuff_hand = function(self, cards, hand, handname, check)
        for i,card in ipairs(cards) do
            if CardPronouns.has("feminine", card) then
                return true
            end
        end
        return false
    end,
    dependencies = {"cardpronouns"},
    boss = {min = 2, max = 0}
}

SMODS.Blind {
    key = "thesimp",
    loc_txt = {
        name = "The Simp",
        text = {
            "Hands containing {C:attention}Masculine{}",
            "cards are not allowed"
        }
    },
    boss_colour = HEX("DB67BE"),
    dollars = 6,
    mult = 1,
    debuff_hand = function(self, cards, hand, handname, check)
        for i,card in ipairs(cards) do
            if CardPronouns.has("masculine", card) then
                return true
            end
        end
        return false
    end,
    dependencies = {"cardpronouns"},
    boss = {min = 2, max = 0}
}

SMODS.Blind {
    key = "the_y",
    loc_txt = {
        name = "The Y",
        text = {
            "Hands must contain at least one",
            "card with {C:attention}They/Them{} pronouns",
        }
    },
    boss_colour = HEX("FFFD8F"),
    dollars = 6,
    mult = 2,
    debuff_hand = function(self, cards, hand, handname, check)
        for i,card in ipairs(cards) do
            if CardPronouns.is("they_them", card) then
                return true
            end
        end
        return false
    end,
    dependencies = {"cardpronouns"},
    boss = {min = 2, max = 0}
}

SMODS.Blind {
    key = "fuck",
    boss_colour = HEX("344245"),
    mult = 0.0001,

    loc_txt = {
        name = "Oh no",
        text = {
            "Survive.",
            "Die if you miss"
        }
    },

    press_play = function(self)
        if not G.GAME.blind.disabled then
            Multiverse.undyne_spears = {}
            Multiverse.done_attacking = false
            Multiverse.in_undyne = true
            local num_attacks = Multiverse.start_undyne_attack(1, vallkarri.generate_arrows(1500))
            G.E_MANAGER:add_event(Event({
                trigger = "immediate",
                func = function()
                    if Multiverse.undyne_spears[num_attacks] and not Multiverse.undyne_spears[num_attacks].active and Multiverse.in_undyne then
                        G.E_MANAGER:add_event(Event({
                            trigger = "after",
                            blockable = false,
                            blocking = false,
                            delay = 0.5 * (G.SPEEDFACTOR or 1),
                            func = function()
                                Multiverse.in_undyne = false
                                return true
                            end
                        }))
                    end
                    return not Multiverse.in_undyne
                end
            }))
        end
    end,
    in_pool = function(self)
        return Multiverse.config.joke and G.GAME.round_resets.ante > 8
    end,
    dependencies = {"multiverse"},
}

function vallkarri.generate_arrows(amount)
    local arrows = {}

    for i=1,amount do
        arrows[#arrows+1] = {
            200+((i/amount)*800), 
            pseudorandom_element({"up", "down", "left", "right"}, "valk_hell_"..i),
            false,
            0.2+((1-(i/amount))*0.5),
        }
    end

    return arrows
end