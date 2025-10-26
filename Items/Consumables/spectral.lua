SMODS.Consumable {
    set = "Spectral",
    loc_txt = {
        name = "Freeway",
        text = {
            "Create a random {C:valk_exquisite}Exquisite{} Joker",
            "{X:dark_edition,C:white}^#1#{} Effective Ante",
        }
    },
    valk_artist = "Pangaea",
    key = "freeway",
    atlas = "main",
    pos = { x = 9, y = 3, },
    soul_pos = { x = 7, y = 3, extra = { x = 8, y = 3 } },
    soul_rate = 0.01,
    hidden = true,
    cost = 10,
    config = { extra = { eeante = 1.25 } },
    can_use = function(self, card)
        return true
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.eeante,
            }
        }
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.4,
            func = function()
                play_sound("timpani")
                local c = create_card("Joker", G.jokers, nil, "valk_exquisite", nil, nil, nil, "valk_freeway")
                c:add_to_deck()
                G.jokers:emplace(c)
                c:juice_up(0.3, 0.5)
                vallkarri.add_effective_ante_mod(card.ability.extra.eeante, "^")
                return true
            end,
        }))
        delay(0.6)
    end
}

SMODS.Consumable {
    set = "Spectral",
    loc_txt = {
        name = "Luck",
        text = {
            "Select up to {C:attention}#1#{} Jokers and either",
            "{C:attention}Double{} or {C:attention}Halve{} each Jokers values",
        }
    },
    valk_artist = "mailingway",
    key = "luck",
    pos = { x = 4, y = 4 },
    atlas = "main",
    soul_rate = 0.07,
    -- is_soul = true,

    config = { extra = { jokers = 3,} },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.jokers } }
    end,

    can_use = function(self, card)
        return #G.jokers.highlighted <= card.ability.extra.jokers and #G.jokers.highlighted > 0
    end,



    use = function(self, card, area, copier)
        for i, c in ipairs(G.jokers.highlighted) do
            local chosen = (pseudorandom("valk_luck", 1, 2) * 1.5) - 1
            Cryptid.manipulate(c, {value = chosen})
        end
    end
}


SMODS.Consumable {
    set = "Spectral",
    loc_txt = {
        name = "Faker",
        text = {
            "Select {C:attention}#1#{} Joker, create a {C:dark_edition}Negative{}",
            "and {C:attention}Perishable{} copy.",
        }
    },
    valk_artist = "mailingway",
    key = "faker",
    pos = { x = 5, y = 10 },
    atlas = "main",
    -- is_soul = true,

    config = { extra = { jokers = 1 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.jokers } }
    end,

    can_use = function(self, card)
        return #G.jokers.highlighted <= card.ability.extra.jokers and #G.jokers.highlighted > 0
    end,



    use = function(self, card, area, copier)
        for i, c in ipairs(G.jokers.highlighted) do
            local copy = copy_card(c)
            copy:set_edition("e_negative", true)
            copy:add_sticker("perishable", true)
            G.jokers:emplace(copy)
        end
    end
}

SMODS.Consumable {
    set = "Spectral",
    loc_txt = {
        name = "://HIM",
        text = {
            "Randomize enhancement of all cards {C:attention}held-in-hand{}",
            "{C:inactive}(Vanilla enhancements only){}",
        }
    },
    valk_artist = "Lil Mr. Slipstream",
    key = "gaster",
    pos = { x = 8, y = 9 },
    atlas = "main",

    config = { extra = {} },

    loc_vars = function(self, info_queue, card)

    end,

    can_use = function(self, card)
        return (#G.hand.cards > 0)
    end,

    use = function(self, card, area, copier)
        do_while_flipped(G.hand.cards, function(c)
            local valid = { "m_bonus", "m_mult", "m_wild", "m_glass", "m_steel", "m_gold", "m_lucky" }
            c:set_ability(valid[pseudorandom("valk_missingno", 1, #valid)])
        end)
    end
}

SMODS.Consumable {
    set = "Spectral",
    loc_txt = {
        name = "://MISSINGNO",
        text = {
            "Randomize edition of all cards {C:attention}held-in-hand{}",
            "{C:inactive}(Vanilla editions only){}",
        }
    },
    valk_artist = "Scraptake",
    key = "missingno",
    pos = { x = 1, y = 9 },
    atlas = "main",

    config = { extra = {} },

    loc_vars = function(self, info_queue, card)

    end,

    can_use = function(self, card)
        return (#G.hand.cards > 0)
    end,

    update = function(self, card)
        card.children.center:set_sprite_pos({ x = math.random(1, 2), y = 9 })
    end,

    use = function(self, card, area, copier)
        do_while_flipped(G.hand.cards, function(c)
            local valid = { "e_foil", "e_holo", "e_polychrome", "e_negative" }
            c:set_edition(valid[pseudorandom("valk_missingno", 1, #valid)], true)
        end)
    end
}

SMODS.Consumable {
    set = "Spectral",
    loc_txt = {
        name = "Succor",
        text = {
            "{C:attention}+#1#{} Card Selection Limit",
            "{C:attention}#2#{} Hand Size",
        }
    },
    valk_artist = "mailingway",
    key = "succor",
    pos = { x = 0, y = 5 },
    atlas = "atlas2",

    config = { extra = { limit = 2, hand_size = -1 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.limit,
                card.ability.extra.hand_size
            }
        }
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        SMODS.change_play_limit(card.ability.extra.limit)
        SMODS.change_discard_limit(card.ability.extra.limit)
        G.hand:change_size(card.ability.extra.hand_size)
    end,
}

SMODS.Consumable {
    set = "Spectral",
    loc_txt = {
        name = "Testosterone (C{s:0.5}19{})",
        text = {
            "Convert up to {C:attention}#1#{} selected cards to {C:attention}Polychrome Kings{}",
            "Destroy {C:attention}#2#{} random cards in deck",
        }
    },
    valk_artist = "mailingway",
    key = "testosterone",
    pos = { x = 1, y = 6 },
    atlas = "atlas2",

    config = { extra = { convert = 3, destroy = 3 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.convert,
                card.ability.extra.destroy
            }
        }
    end,

    can_use = function(self, card)
        return #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.convert
    end,

    use = function(self, card, area, copier)
        do_while_flipped(vallkarri.get_ordered_highlighted(G.hand), function(c)
            SMODS.change_base(c, nil, "King")
            c:set_edition("e_polychrome", true)
        end)

        for i = 1, card.ability.extra.destroy do
            local thou_shall_fucking_die = pseudorandom_element(G.playing_cards, "valk_testosterone")
            thou_shall_fucking_die:start_dissolve({ G.C.RED })
        end
    end,
}

SMODS.Consumable {
    set = "Spectral",
    loc_txt = {
        name = "Estrogen (C{s:0.5}18{})",
        text = {
            "Convert up to {C:attention}#1#{} selected cards to {C:attention}Polychrome Queens{}",
            "Destroy {C:attention}#2#{} random cards in deck",
        }
    },
    valk_artist = "mailingway",
    key = "estrogen",
    pos = { x = 0, y = 6 },
    atlas = "atlas2",

    config = { extra = { convert = 3, destroy = 3 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.convert,
                card.ability.extra.destroy
            }
        }
    end,

    can_use = function(self, card)
        return #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.extra.convert
    end,

    use = function(self, card, area, copier)
        do_while_flipped(vallkarri.get_ordered_highlighted(G.hand), function(c)
            SMODS.change_base(c, nil, "Queen")
            c:set_edition("e_polychrome", true)
        end)

        for i = 1, card.ability.extra.destroy do
            local thou_shall_fucking_die = pseudorandom_element(G.playing_cards, "valk_estrogen")
            thou_shall_fucking_die:start_dissolve({ G.C.RED })
        end
    end,
}

SMODS.Consumable {
    set = "Spectral",
    loc_txt = {
        name = "Void Potential",
        text = {
            "Choose {C:attention}#1#{} of up to {C:attention}#2#{} random Jokers",
            "then {C:attention}Double{} their values",
        }
    },
    key = "void_potential",
    pos = { x = 2, y = 0 },
    atlas = "phold",

    config = { extra = { choices = 1, max = 3 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.choices,
                card.ability.extra.max
            }
        }
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(_self, card, area, copier)
        local cards = {}
        for i=1,card.ability.extra.max do
            table.insert(cards, G.P_CENTERS[vallkarri.random_key_from_pool("Joker")])
        end
        G.FUNCS.open_void_potential(cards, card.ability.extra.choices)
        local card_table = G.your_collection[1].cards
        

        for _,c in pairs(card_table) do
            c.click = function(self)
                if G.GAME.void_potential_choices_left > 0 then
                    local created_card = SMODS.add_card({key = self.config.center_key, area = G.jokers})
                    Cryptid.manipulate(created_card, {value = 2})
                    G.GAME.void_potential_choices_left = G.GAME.void_potential_choices_left - 1
                    self:start_dissolve({G.C.RED}, G.SETTINGS.GAMESPEED*0.5)
                end  

                if G.GAME.void_potential_choices_left <= 0 then
                    for _,to_destroy in pairs(self.area.cards) do
                        to_destroy:start_dissolve({G.C.RED}, G.SETTINGS.GAMESPEED*0.5)
                    end
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.FUNCS.exit_overlay_menu()
                            return true
                        end
                    }))
                end
            end
        end
    end,
}

G.FUNCS.open_void_potential = function(centers, choices)
    -- G.SETTINGS.paused = true
    G.GAME.void_potential_choices_left = choices
    G.FUNCS.overlay_menu {
        definition = SMODS.card_collection_UIBox(centers, {#centers}, {back_func = "exit_overlay_menu"}),
    }
end

-- vallkarri
-- freakarri
