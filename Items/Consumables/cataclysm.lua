local fakestart = Game.start_run
function Game:start_run(args)
    fakestart(self, args)

    for name,center in pairs(G.P_CENTER_POOLS.Cataclysm) do
        G.P_CENTER_POOLS.Cataclysm[name].cost = 16
        G.P_CENTER_POOLS.Cataclysm[name].in_pool = function(self, args)
            return not (G.GAME.consumeable_usage[self.key] and G.GAME.consumeable_usage[self.key].count)
        end
    end

end

local lc = loc_colour
function loc_colour(_c, _default)
	if not G.ARGS.LOC_COLOURS then
		lc()
	end
	G.ARGS.LOC_COLOURS.valk_cataclysm = HEX("50202A")
	return lc(_c, _default)
end

G.C.VALK_CATACLYSM = HEX("50202A")

SMODS.Atlas {
    key = "cata",
    path = "cataclysm.png",
    px = 83,
    py = 103,
}

SMODS.ConsumableType {
    key = "Cataclysm",
    collection_rows = {6, 6},
    primary_colour = HEX("3D2228"),
    secondary_colour = HEX("69454D"),
    shop_rate = 0,

    loc_txt = {
        collection = "Cataclysm Cards",
        label = "cataclysm",
        name = "Cataclysm Cards",
        undiscovered = {
            name = "go turn on unlock all",
            text = {
                "this mod is intended to be used",
                "with unlock all enabled"
            }
        }
    },
}

-- SMODS.Consumable {
--     set = "Cataclysm",
--     key = "",
--     loc_txt = { 
--         name = "",
--         text = {
--             "",
--             credit("Pangaea"),
--         }
--     },
--     pos = { x = 0, y = 0 },
--     atlas = "cata",
--     display_size = {w=83, h=103},

--     config = { extra = { } },

--     loc_vars = function(self, info_queue, card)

--         return {vars = { }}
        
--     end,
--     can_use = function(self, card)
--         return true
--     end,
--     use = function(self, card, area, copier)
--         


--     end
-- }

SMODS.Consumable {
    no_doe = true,
    no_grc = true,
    set = "Cataclysm",
    key = "deluge",
    loc_txt = { 
        name = "Deluge",
        text = {
            "{C:planet}-#1#{} levels on all hands",
            "{X:planet,C:white}X#2#{} hand level scaling on all hands",
            credit("Pangaea"),
        }
    },
    pos = { x = 0, y = 0 },
    atlas = "cata",
    display_size = {w=83, h=103},

    config = { extra = { loss = 20, scaling = 10} },

    loc_vars = function(self, info_queue, card)

        return {vars = { card.ability.extra.loss, card.ability.extra.scaling }}
        
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        

        level_all_hands(card, -card.ability.extra.loss)
        for name,_ in pairs(G.GAME.hands) do
            G.GAME.hands[name].l_chips = G.GAME.hands[name].l_chips * card.ability.extra.scaling
            G.GAME.hands[name].l_mult = G.GAME.hands[name].l_mult * card.ability.extra.scaling
        end

    end
}

SMODS.Consumable {
    no_doe = true,
    no_grc = true,
    set = "Cataclysm",
    key = "doomsday",
    loc_txt = { 
        name = "Doomsday",
        text = {
            "{C:attention}X#1#{} Joker values at end of round for the next {C:attention}#2#{} rounds",
            "Once this has hit {C:attention}0{} rounds,",
            "use this card to increase all Joker values by {C:attention}X#3#{}",
            credit("Pangaea"),
        }
    },
    pos = { x = 1, y = 0 },
    atlas = "cata",
    display_size = {w=83, h=103},

    config = { extra = { startrounds = 8, rounds = 8, negativemult = 0.95, bonus = 3 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { card.ability.extra.negativemult, card.ability.extra.rounds, card.ability.extra.bonus/(card.ability.extra.negativemult ^ card.ability.extra.startrounds) }}
        
    end,
    can_use = function(self, card)
        return card.ability.extra.rounds <= 0
    end,
    use = function(self, card, area, copier)
        if card.area ~= G.consumeables then
            G.consumeables:emplace(card)
            return
        end 

        for i,joker in ipairs(G.jokers.cards) do
            Cryptid.manipulate(joker, {value = card.ability.extra.bonus/(card.ability.extra.negativemult ^ card.ability.extra.startrounds)})
        end
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            card.ability.extra.rounds = card.ability.extra.rounds - 1
            for i,joker in ipairs(G.jokers.cards) do
                Cryptid.manipulate(joker, {value = card.ability.extra.negativemult})
            end

        end
    end,

    keep_on_use = function(self, card)
        if card.area ~= G.consumeables then
            return true
        end
        return false
    end
}

SMODS.Consumable {
    no_doe = true,
    no_grc = true,
    set = "Cataclysm",
    key = "paroxysm",
    loc_txt = { 
        name = "Paroxysm",
        text = {
            "{C:red}Debuff{} all owned Jokers. All future instances",
            "of those Jokers will have {C:attention}X#1#{} values",
            credit("Pangaea"),
        }
    },
    pos = { x = 2, y = 0 },
    atlas = "cata",
    display_size = {w=83, h=103},

    config = { extra = { valuemult = 4 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { card.ability.extra.valuemult }}
        
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        

        for i,joker in ipairs(G.jokers.cards) do
            joker:set_debuff(true)

            if not G.GAME.vallkarri.spawn_multipliers then
                G.GAME.vallkarri.spawn_multipliers = {}
            end

            if not G.GAME.vallkarri.spawn_multipliers[joker.config.center.key] then
                G.GAME.vallkarri.spawn_multipliers[joker.config.center.key] = 1
            end
            G.GAME.vallkarri.spawn_multipliers[joker.config.center.key] = G.GAME.vallkarri.spawn_multipliers[joker.config.center.key] * 4
        end
    end
}

SMODS.Consumable {
    no_doe = true,
    no_grc = true,
    set = "Cataclysm",
    key = "invasion",
    loc_txt = { 
        name = "Invasion",
        text = {
            "{C:red}-#1#{} discards",
            "{C:attention}+#1#{} consumable slots",
            credit("Pangaea"),
        }
    },
    pos = { x = 3, y = 0 },
    atlas = "cata",
    display_size = {w=83, h=103},

    config = { extra = { change = 20 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { card.ability.extra.change }}
        
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        

        ease_discard(-card.ability.extra.change)
        G.GAME.round_resets.discards = G.GAME.round_resets.discards - 20 
        G.consumeables:change_size(card.ability.extra.change)
    end
}

SMODS.Consumable {
    no_doe = true,
    no_grc = true,
    set = "Cataclysm",
    key = "absolution",
    loc_txt = { 
        name = "Absolution",
        text = {
            "Turn all owned Jokers into one random {C:attention}Joker{},",
            "then apply {C:purple}Eternal{} to all Jokers",
            credit("Pangaea"),
        }
    },
    pos = { x = 4, y = 0 },
    atlas = "cata",
    display_size = {w=83, h=103},

    config = { extra = { } },

    loc_vars = function(self, info_queue, card)

        return {vars = { }}
        
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        

        local chosen_joker = G.jokers.cards[pseudorandom("cata_abso", 1, #G.jokers.cards)]
        for i,joker in ipairs(G.jokers.cards) do
            joker:set_ability(chosen_joker.config.center.key)
            joker.ability.eternal = true
        end
    end
}

SMODS.Consumable {
    no_doe = true,
    no_grc = true,
    set = "Cataclysm",
    key = "plague",
    loc_txt = { 
        name = "Plague",
        text = {
            "{C:attention}Duplicate{} all cards in deck, then {C:attention}randomize{}",
            "all {C:attention}duplicated{} cards",
            credit("Pangaea"),
        }
    },
    pos = { x = 5, y = 0 },
    atlas = "cata",
    display_size = {w=83, h=103},

    config = { extra = { } },

    loc_vars = function(self, info_queue, card)

        return {vars = { }}
        
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        

        local copies = {}
        for i,to_copy in ipairs(G.deck.cards) do 
            copies[#copies+1] = copy_card(to_copy)
            
        end

        for i,copy in ipairs(copies) do
            SMODS.change_base(copy, random_suit(), random_rank())
            copy:set_ability(random_enhancement())
            copy:set_edition(random_edition(), true)
            copy:add_to_deck()
            G.deck:emplace(copy)
            table.insert(G.playing_cards, copy)
        end
    end
}

SMODS.Consumable {
    no_doe = true,
    no_grc = true,
    set = "Cataclysm",
    key = "disaster",
    loc_txt = { 
        name = "Disaster",
        text = {
            "{C:attention}-#1#{} Hand Size",
            "{C:attention}X#1#{} all Joker values",
            credit("Pangaea"),
        }
    },
    pos = { x = 6, y = 0 },
    atlas = "cata",
    display_size = {w=83, h=103},

    config = { extra = { change = 3} },

    loc_vars = function(self, info_queue, card)

        return {vars = { card.ability.extra.change }}
        
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        

        G.hand:change_size(-card.ability.extra.change)
        for i,joker in ipairs(G.jokers.cards) do
            Cryptid.manipulate(joker, {value = card.ability.extra.change})
        end
    end
}

SMODS.Consumable {
    no_doe = true,
    no_grc = true,
    set = "Cataclysm",
    key = "collision",
    loc_txt = { 
        name = "Collision",
        text = {
            "Randomly {C:red}Banish{} each {C:planet}Planet{} card with",
            "a {C:green}#2# in #3#{} chance",
            "All tarot cards have {C:attention}X#1#{} values",
            credit("Pangaea"),
        }
    },
    pos = { x = 7, y = 0 },
    atlas = "cata",
    display_size = {w=83, h=103},

    config = { extra = { vm = 5, num = 1, den = 2} },

    loc_vars = function(self, info_queue, card)

        local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, 'valk_collision')
        return {vars = { card.ability.extra.vm, num, den }}
        
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        


        for i,center in ipairs(G.P_CENTER_POOLS.Planet) do
            if SMODS.pseudorandom_probability(card, 'collision', card.ability.extra.num, card.ability.extra.den, 'collision') then
                G.GAME.cry_banished_keys[center.key] = true
            end
        end

        for i,center in ipairs(G.P_CENTER_POOLS.Tarot) do
            if not G.GAME.vallkarri.spawn_multipliers then
                G.GAME.vallkarri.spawn_multipliers = {}
            end
            if not G.GAME.vallkarri.spawn_multipliers[center.key] then
                G.GAME.vallkarri.spawn_multipliers[center.key] = 1
            end
            G.GAME.vallkarri.spawn_multipliers[center.key] = G.GAME.vallkarri.spawn_multipliers[center.key] * card.ability.extra.vm
        end

    end
}

-- SMODS.Consumable {
local DISABLED_ONE = {
    no_doe = true,
    no_grc = true,
    set = "Cataclysm",
    key = "takeover",
    loc_txt = { 
        name = "Takeover",
        text = {
            "TO REWORK",
            credit("Pangaea"),
        }
    },
    pos = { x = 8, y = 0 },
    atlas = "cata",
    display_size = {w=83, h=103},

    config = { extra = { uses = 2 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { card.ability.extra.uses }}
        
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        
    end
}

-- SMODS.Consumable {
local DISABLED_TWO = {
    no_doe = true,
    no_grc = true,
    set = "Cataclysm",
    key = "maleficence",
    loc_txt = { 
        name = "Maleficence",
        text = {
            "TO REWORK",
            credit("Pangaea"),
        }
    },
    pos = { x = 0, y = 1 },
    atlas = "cata",
    display_size = {w=83, h=103},

    config = { extra = { } },

    loc_vars = function(self, info_queue, card)
        -- info_queue[#info_queue+1] = G.P_CENTERS.j_jolly
        info_queue[#info_queue + 1] = G.P_CENTERS.e_cry_m
        return {vars = { }}
        
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        

    end
}

SMODS.Consumable {
    no_doe = true,
    no_grc = true,
    set = "Cataclysm",
    key = "bigrip",
    loc_txt = { 
        name = "Big Rip",
        text = {
            "{C:red}Banish{} {C:attention}Jumbo{} and {C:attention}Mega{} {C:planet}Planet{} packs",
            "{C:attention}X#1#{} Chips and mult per level on all hands",
            credit("Pangaea"),
        }
    },
    pos = { x = 1, y = 1 },
    atlas = "cata",
    display_size = {w=83, h=103},

    config = { extra = { mult = 3 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { card.ability.extra.mult }}
        
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        
        local to_banish = {"p_celestial_jumbo_1","p_celestial_jumbo_2","p_celestial_mega_1","p_celestial_mega_2",}

        for i,banish in ipairs(to_banish) do
            G.GAME.cry_banished_keys[banish] = true
        end

        mspl(card.ability.extra.mult)

    end
}

SMODS.Consumable {
    no_doe = true,
    no_grc = true,
    set = "Cataclysm",
    key = "bigcrunch",
    loc_txt = { 
        name = "Big Crunch",
        text = {
            "{C:red}Banish{} {C:attention}Jumbo{} and {C:attention}Mega{} {C:tarot}Tarot{} packs",
            "{C:attention}X#1#{} to all future {C:tarot}Tarot{} values",
            credit("Pangaea"),
        }
    },
    pos = { x = 2, y = 1 },
    atlas = "cata",
    display_size = {w=83, h=103},

    config = { extra = { mult = 3 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { card.ability.extra.mult }}
        
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        
        local to_banish = {"p_tarot_jumbo_1","p_tarot_jumbo_2","p_tarot_mega_1","p_tarot_mega_2",}

        for i,banish in ipairs(to_banish) do
            G.GAME.cry_banished_keys[banish] = true
        end

        for i,center in ipairs(G.P_CENTER_POOLS.Tarot) do
            if not G.GAME.vallkarri.spawn_multipliers then
                G.GAME.vallkarri.spawn_multipliers = {}
            end
            if not G.GAME.vallkarri.spawn_multipliers[center.key] then
                G.GAME.vallkarri.spawn_multipliers[center.key] = 1
            end
            G.GAME.vallkarri.spawn_multipliers[center.key] = G.GAME.vallkarri.spawn_multipliers[center.key] * card.ability.extra.mult
        end

    end
}

SMODS.Consumable {
    no_doe = true,
    no_grc = true,
    set = "Cataclysm",
    key = "bigchill",
    loc_txt = { 
        name = "Big Chill",
        text = {
            "{C:red}Banish{} {C:attention}Jumbo{} and {C:attention}Mega{} {C:spectral}Spectral{} packs",
            "{C:attention}Hidden{} {C:spectral}Spectrals{} have a flat {C:green}5%{}",
            "chance to replace {C:attention}non-hidden{} {C:spectral}Spectral{} cards",
            credit("Pangaea"),
        }
    },
    pos = { x = 3, y = 1 },
    atlas = "cata",
    display_size = {w=83, h=103},

    config = { extra = {  } },

    loc_vars = function(self, info_queue, card)

        return {vars = {  }}
        
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        
        local to_banish = {"p_spectral_jumbo_1","p_spectral_mega_1",}

        for i,banish in ipairs(to_banish) do
            G.GAME.cry_banished_keys[banish] = true
        end

        if not G.GAME.hidden_override then
            G.GAME.hidden_override = 5
        else 
            G.GAME.hidden_override = G.GAME.hidden_override + 5
        end

    end
}

SMODS.Consumable {
    no_doe = true,
    no_grc = true,
    set = "Cataclysm",
    key = "bigslurp",
    loc_txt = { 
        name = "Big Slurp",
        text = {
            "{C:red}Banish{} all owned {C:attention}Jokers{}, then create",
            "a {C:rare}Rare{} {C:attention}Joker{} for each banished {C:attention}Joker{}",
            credit("Pangaea"),
        }
    },
    pos = { x = 4, y = 1 },
    atlas = "cata",
    display_size = {w=83, h=103},

    config = { extra = {  } },

    loc_vars = function(self, info_queue, card)

        return {vars = {  }}
        
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        
        local to_make = 0

        for i,joker in ipairs(G.jokers.cards) do
            G.GAME.cry_banished_keys[joker.config.center.key] = true
            to_make = to_make + 1
            joker:quick_dissolve()
        end
        for i=1,to_make do
            local c = create_card("Joker", G.jokers, nil, 3, nil, nil, nil, "valk_cata_slurp")
            c:add_to_deck()
            G.jokers:emplace(c)
        end

    end
}

SMODS.Consumable {
    no_doe = true,
    no_grc = true,
    set = "Cataclysm",
    key = "occulture",
    loc_txt = { 
        name = "Occulture",
        text = {
            "{C:attention}Tags{} are no longer obtainable,",
            "All future {C:spectral}Spectral{} cards have {C:attention}X#1#{} values",
            credit("Pangaea"),
        }
    },
    pos = { x = 5, y = 1 },
    atlas = "cata",
    display_size = {w=83, h=103},

    config = { extra = { mult = 2 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { card.ability.extra.mult }}
        
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        
        local to_make = 0

        G.GAME.ban_tags = true

        for i,center in ipairs(G.P_CENTER_POOLS.Spectral) do
            if not G.GAME.vallkarri.spawn_multipliers then
                G.GAME.vallkarri.spawn_multipliers = {}
            end
            if not G.GAME.vallkarri.spawn_multipliers[center.key] then
                G.GAME.vallkarri.spawn_multipliers[center.key] = 1
            end
            G.GAME.vallkarri.spawn_multipliers[center.key] = G.GAME.vallkarri.spawn_multipliers[center.key] * card.ability.extra.mult
        end

    end
}

SMODS.Consumable {
    no_doe = true,
    no_grc = true,
    set = "Cataclysm",
    key = "postexistence",
    loc_txt = { 
        name = "Post-Existence",
        text = {
            "Randomly {C:red}Banish{} each {C:tarot}Tarot{} card with",
            "a {C:green}#1# in #2#{} chance,",
            "{C:spectral}Spectral{} cards can be found in shop",
            credit("Pangaea"),
        }
    },
    pos = { x = 6, y = 1 },
    atlas = "cata",
    display_size = {w=83, h=103},

    config = { extra = { num = 1, den = 2} },

    loc_vars = function(self, info_queue, card)

        local num, den = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, 'postexistence')
        return {vars = { num, den }}
        
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        
        local to_make = 0

        for i,center in ipairs(G.P_CENTER_POOLS.Planet) do
            if SMODS.pseudorandom_probability(card, 'postexistence', card.ability.extra.num, card.ability.extra.den, 'postexistence') then
                G.GAME.cry_banished_keys[center.key] = true
            end
        end

        G.GAME.spectral_rate = G.GAME.spectral_rate + 5

    end
}

SMODS.Consumable {
    no_doe = true,
    no_grc = true,
    set = "Cataclysm",
    key = "stagnancy",
    loc_txt = { 
        name = "Stagnancy",
        text = {
            "All owned Jokers are made {C:purple}Eternal{}",
            "Jokers have a {C:green}5%{} chance to be",
            "replaced by an {C:valk_exquisite}Exquisite{} Joker",
            credit("Pangaea"),
        }
    },
    pos = { x = 7, y = 1 },
    atlas = "cata",
    display_size = {w=83, h=103},

    config = { extra = { } },

    loc_vars = function(self, info_queue, card)

        return {vars = { }}
        
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        

        for i,joker in ipairs(G.jokers.cards) do
            joker.ability.eternal = true 
        end

        G.GAME.exquisite_replace = 5 --no stacking :)

    end
}

-- SMODS.Consumable {
--     set = "Cataclysm",
--     key = "torrentuous",
--     loc_txt = { 
--         name = "Torrentuous",
--         text = {
--             "",
--             credit("Pangaea"),
--         }
--     },
--     pos = { x = 8, y = 1 },
--     atlas = "cata",
--     display_size = {w=83, h=103},

--     config = { extra = { } },

--     loc_vars = function(self, info_queue, card)

--         return {vars = {  }}
        
--     end,
--     can_use = function(self, card)
--         return true
--     end,
--     use = function(self, card, area, copier)
--         

        
--     end
-- }

SMODS.Consumable {
    no_doe = true,
    no_grc = true,
    set = "Cataclysm",
    key = "phoenix",
    loc_txt = { 
        name = "Phoenix",
        text = {
            "{C:red}Unbanish{} a random used {C:red}Cataclysm{} card",
            credit("Pangaea"),
        }
    },
    pos = { x = 4, y = 2 },
    atlas = "cata",
    display_size = {w=83, h=103},

    config = { extra = { } },

    loc_vars = function(self, info_queue, card)

        return {vars = {  }}
        
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        

        local capable = {}

        for name,center in pairs(G.GAME.cry_banished_keys) do
            if G.P_CENTERS[name] and G.P_CENTERS[name].set == "Cataclysm" then
                capable[#capable+1] = name
            end
        end

        G.GAME.cry_banished_keys[capable[pseudorandom("valk_unbanish",1,#capable)]] = false
    end,
    in_pool = function()
        for name,center in pairs(G.GAME.cry_banished_keys) do
            if G.P_CENTERS[name] and G.P_CENTERS[name].set == "Cataclysm" then
                return true
            end
        end
        return false
    end,
}
SMODS.Booster {
    key = "revelations",
    atlas = "cata",
    pos = {x=0, y=3},
    display_size = {w=83, h=103},
    discovered = true,
    loc_txt = {
        name = "Pack of Revelations",
        text = {
            "Pick {C:attention}#1#{} of up to {C:attention}#2#{} {C:valk_cataclysm}Cataclysm{} cards",
            "to use immediately",
            credit("Pangaea")
        },
        group_name = "Pack of Revelations"
    },

    draw_hand = false,
    config = {choose = 1, extra = 3},

    loc_vars = function(self, info_queue, card) 
        return {vars = {card.ability.choose, card.ability.extra}}
    end,

    weight = 0.999,
    cost = 18,

    create_card = function(self, card, i)
        ease_background_colour(G.C.VALK_CATACLYSM)
        return create_card("Cataclysm", G.pack_cards, nil, nil, true, nil, nil, "valk_pack_of_revelations")

        
    end,

    in_pool = function()
        return #SMODS.find_card("v_valk_seventrumpets") > 0
    end
}

SMODS.Consumable {
    set = "Superplanet",
    key = "nevada",
    loc_txt = {
        name = "Nevada",
        text = {
            "All hands gain {X:dark_edition,C:white}^^#1#{} Chips & Mult for",
            "each used {C:valk_cataclysm}cataclysm{} card",
            credit("Pangaea"),
        }
    },

    no_doe = true,

    config = { extra = {increase = 1.1} },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.increase}}
    end,

    can_use = function(self, card)
        -- currently only returns true need to make it only work when u have the joker.
        return true
    end,

    use = function(self, card, area, copier)
        local levels = 0
        for name,center in pairs(G.GAME.consumeable_usage) do
            if G.P_CENTERS[name].set == "Cataclysm" then
                levels = levels + center.count
            end
        end

        local value = card.ability.extra.increase ^ levels
        local str = "^^" .. tostring(value)
        vallkarri.simple_hand_text("all")
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1, delay = 1}, {chips = str,mult = str})

        for i,hand in pairs(G.GAME.hands) do
            if (G.GAME.hands[i].chips) and (G.GAME.hands[i].mult) then
                G.GAME.hands[i].chips = G.GAME.hands[i].chips:tetrate(value)
                G.GAME.hands[i].mult = G.GAME.hands[i].mult:tetrate(value)
            end
        end
    end,
    in_pool = function()
        for name,center in pairs(G.GAME.consumeable_usage) do
            if G.P_CENTERS[name].set == "Cataclysm" then
                return true 
            end
        end
        return false
    end,

        
    atlas = "csm",
    pos = {x=9, y=2},
    no_grc = true,
    no_doe = true,
    dependencies = {"Talisman"},
}

SMODS.Voucher {
    key = "seventrumpets",
    atlas = "main",
    pos = {x=2, y=8},
    loc_txt = {
        name = "Seven Trumpets",
        text = {
            "The {C:valk_cataclysm}Pack of Revelations{} can now appear in the shop",
            credit("Pangaea")
        }
    },

    in_pool = function()
        return G.GAME.round_resets.ante > 2
    end,

    


}