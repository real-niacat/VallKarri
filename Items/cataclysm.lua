local fakestart = Game.start_run
function Game:start_run(args)
    fakestart(self, args)

    for name,center in pairs(G.P_CENTER_POOLS.Cataclysm) do
        G.P_CENTER_POOLS.Cataclysm[name].cost = 16
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
--         self_annihilate(card)


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
        self_annihilate(card)

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
            "use this card to increase all joker values by {C:attention}X#3#{}",
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
        self_annihilate(card)

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
}

SMODS.Consumable {
    no_doe = true,
    no_grc = true,
    set = "Cataclysm",
    key = "paroxysm",
    loc_txt = { 
        name = "Paroxysm",
        text = {
            "{C:red}Debuff{} all owned jokers. All future instances",
            "of those jokers will have {C:attention}X#1#{} values",
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
        self_annihilate(card)

        for i,joker in ipairs(G.jokers.cards) do
            joker:set_debuff(true)

            if not vallkarri.spawn_multipliers[joker.config.center.key] then
                vallkarri.spawn_multipliers[joker.config.center.key] = 1
            end
            vallkarri.spawn_multipliers[joker.config.center.key] = vallkarri.spawn_multipliers[joker.config.center.key] * 4
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
        self_annihilate(card)

        ease_discard(-card.ability.extra.change)
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
            "Turn all owned jokers into one random {C:attention}joker{},",
            "then apply {C:purple}eternal{} to all jokers",
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
        self_annihilate(card)

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
        self_annihilate(card)

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
        self_annihilate(card)

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
            "Randomly {C:red}Banish{} each {C:planet}planet{} card with",
            "a {C:green}1 in 2{} chance",
            "All tarot cards have {C:attention}X#1#{} values",
            credit("Pangaea"),
        }
    },
    pos = { x = 7, y = 0 },
    atlas = "cata",
    display_size = {w=83, h=103},

    config = { extra = { vm = 5 } },

    loc_vars = function(self, info_queue, card)

        return {vars = { card.ability.extra.vm }}
        
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        self_annihilate(card)


        for i,center in ipairs(G.P_CENTER_POOLS.Planet) do
            if pseudorandom("valk_coll", 1, 2) == 1 then
                G.GAME.cry_banished_keys[center.key] = true
            end
        end

        for i,center in ipairs(G.P_CENTER_POOLS.Tarot) do
            if not vallkarri.spawn_multipliers[center.key] then
                vallkarri.spawn_multipliers[center.key] = 1
            end
            vallkarri.spawn_multipliers[center.key] = vallkarri.spawn_multipliers[center.key] * card.ability.extra.vm
        end

    end
}

SMODS.Consumable {
    no_doe = true,
    no_grc = true,
    set = "Cataclysm",
    key = "takeover",
    loc_txt = { 
        name = "Takeover",
        text = {
            "Future {C:code}code{} cards gain {C:attention}+#1#{} multiuses",
            "{C:attention}De-level{} all hands when {C:code}code{} card used",
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
        self_annihilate(card)

        G.GAME.punish_code_usage = true
        if not G.GAME.code_multiuses then
            G.GAME.code_multiuses = card.ability.extra.uses
        else
            G.GAME.code_multiuses = G.GAME.code_multiuses + card.ability.extra.uses
        end
    end
}

SMODS.Consumable {
    no_doe = true,
    no_grc = true,
    set = "Cataclysm",
    key = "maleficence",
    loc_txt = { 
        name = "Maleficence",
        text = {
            "Destroy all {C:attention}M Jokers{}, then",
            "apply {C:attention}Jolly{} to all jokers",
            credit("Pangaea"),
        }
    },
    pos = { x = 0, y = 1 },
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
        self_annihilate(card)

        for i,joker in ipairs(G.jokers.cards) do

            
            joker:set_edition("e_cry_m",true)
            if joker.config.center.pools and joker.config.center.pools.M then
                joker:start_dissolve({G.C.BLACK}, 8)
            end

        end
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
        self_annihilate(card)
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
            "{C:attention}X#1#{} to all future tarot values",
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
        self_annihilate(card)
        local to_banish = {"p_tarot_jumbo_1","p_tarot_jumbo_2","p_tarot_mega_1","p_tarot_mega_2",}

        for i,banish in ipairs(to_banish) do
            G.GAME.cry_banished_keys[banish] = true
        end

        for i,center in ipairs(G.P_CENTER_POOLS.Tarot) do
            if not vallkarri.spawn_multipliers[center.key] then
                vallkarri.spawn_multipliers[center.key] = 1
            end
            vallkarri.spawn_multipliers[center.key] = vallkarri.spawn_multipliers[center.key] * card.ability.extra.mult
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
            "{C:attention}Hidden{} spectrals have a flat {C:green}5%{}",
            "chance to replace {C:attention}non-hidden{} spectral cards",
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
        self_annihilate(card)
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
            "{C:red}Banish{} all owned {C:attention}jokers{}, then create",
            "a {C:rare}rare{} {C:attention}joker{} for each banished {C:attention}joker{}",
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
        self_annihilate(card)
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
            "All future {C:spectral}spectral{} cards have {C:attention}X#1#{} values",
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
        self_annihilate(card)
        local to_make = 0

        G.GAME.ban_tags = true

        for i,center in ipairs(G.P_CENTER_POOLS.Spectral) do
            if not vallkarri.spawn_multipliers[center.key] then
                vallkarri.spawn_multipliers[center.key] = 1
            end
            vallkarri.spawn_multipliers[center.key] = vallkarri.spawn_multipliers[center.key] * card.ability.extra.mult
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
            "Randomly {C:red}Banish{} each {C:tarot}tarot{} card with",
            "a {C:green}1 in 2{} chance,",
            "{C:spectral}Spectral{} cards can be found in shop",
            credit("Pangaea"),
        }
    },
    pos = { x = 6, y = 1 },
    atlas = "cata",
    display_size = {w=83, h=103},

    config = { extra = { } },

    loc_vars = function(self, info_queue, card)

        return {vars = { card.ability.extra.mult }}
        
    end,
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area, copier)
        self_annihilate(card)
        local to_make = 0

        for i,center in ipairs(G.P_CENTER_POOLS.Planet) do
            if pseudorandom("valk_coll", 1, 2) == 1 then
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
            "All owned jokers are made {C:purple}eternal{}",
            "Jokers have a {C:green}5%{} chance to be",
            "replaced by an {C:cry_exotic}exotic{} joker",
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
        self_annihilate(card)

        for i,joker in ipairs(G.jokers.cards) do
            joker.ability.eternal = true 
        end

        G.GAME.exotic_replace = 5 --no stacking :)

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
--         self_annihilate(card)

        
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
        self_annihilate(card)

        local capable = {}

        for name,center in pairs(G.GAME.cry_banished_keys) do
            if G.P_CENTERS[name].set == "Cataclysm" then
                capable[#capable+1] = name
            end
        end

        G.GAME.cry_banished_keys[capable[pseudorandom("valk_unbanish",1,#capable)]] = false
    end
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
            "to use immedietely"
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
            "All hands gain {X:dark_edition,C:white}^^^^#1#{} Chips & Mult for",
            "each {C:red}banished{} {C:valk_cataclysm}cataclysm{} card",
            credit("Pangaea"),
        }
    },

    no_doe = true,

    config = { extra = { eechips = 1.1 } },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.eechips}}
    end,

    can_use = function(self, card)
        -- currently only returns true need to make it only work when u have the joker.
        return true
    end,

    use = function(self, card, area, copier)
        local levels = 0
        for name,center in pairs(G.GAME.cry_banished_keys) do
            if G.P_CENTERS[name].set == "Cataclysm" then
                levels = levels + 1
            end
        end

        
        -- i know the math here is incorrect but
        -- who's going to correct me on it?
        local value = to_big(card.ability.extra.eechips):pow(to_big(card.ability.extra.eechips):pow(levels))
        local str = "^^^^" .. tostring(value)
        simple_hand_text("all")
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1, delay = 1}, {chips = str})

        for i,hand in pairs(G.GAME.hands) do
            if (G.GAME.hands[i].chips) then
                G.GAME.hands[i].chips = G.GAME.hands[i].chips:arrow(4,value)
            end
        end
    end,

        
    atlas = "csm",
    pos = {x=9, y=2},
    no_grc = true,
    no_doe = true,
}

SMODS.Voucher {
    key = "seventrumpets",
    atlas = "main",
    pos = {x=2, y=8},
    loc_txt = {
        name = "Seven Trumpets",
        text = {
            "The {C:valk_cataclysm}Pack of Revelations{} can now appear in the shop",
        }
    },

    in_pool = function()
        return G.GAME.round_resets.ante > 8
    end,

    


}