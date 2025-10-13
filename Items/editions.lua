-- don't expect any of these to come, unless someone wants to make some shaders for me

-- thhey here!

SMODS.Shader {
    key = "cosmic",
    path = "cosmic.fs"
}

SMODS.Edition {
    key = "cosmic",
    shader = "cosmic",
    loc_txt = {
        name = "Cosmic",
        label = "Cosmic",
        text = {
            "{X:dark_edition,C:white}^#1#{} Chips",
            shadercredit("Lily Felli")
        }
    },
    config = { echips = 1.05 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card and card.edition and card.edition.echips or self.config.echips } }
    end,
    weight = 1,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    calculate = function(self, card, context)
        if (context.edition and context.cardarea == G.jokers and card.config.trigger) or
            (context.main_scoring and context.cardarea == G.play)
        then
            SMODS.calculate_effect({ echips = card.edition and card.edition.echips or 1.05 }, card)
        end

        if context.joker_main then
            card.config.trigger = true
        end

        if context.after then
            card.config.trigger = nil
        end
    end,
    in_pool = function(self, args)
        return true
    end
}

SMODS.Shader {
    key = "glow",
    path = "glow.fs"
}

SMODS.Edition {
    key = "glow",
    shader = "glow",
    loc_txt = {
        name = "Glow-in-the-Dark",
        label = "Glow-in-the-Dark",
        text = {
            "Creates a {C:dark_edition}Negative{}",
            "{C:attention}Consumable{} when triggered",
            shadercredit("Lily Felli")
        }
    },
    config = { extra = {} },
    calculate = function(self, card, context)
        if (context.edition and context.cardarea == G.jokers and card.config.trigger) or
            (context.main_scoring and context.cardarea == G.play)
        then
            SMODS.add_card({set = "Consumeables", area = G.consumeables, edition = "e_negative"})
        end

        if context.joker_main then
            card.config.trigger = true
        end

        if context.after then
            card.config.trigger = nil
        end
    end,
    weight = 1,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    in_pool = function(self, args)
        return true
    end,
    in_shop = true,
}

SMODS.Shader {
    key = "rgb",
    path = "rgb.fs"
}

SMODS.Edition {
    key = "rgb",
    shader = "rgb",
    loc_txt = {
        name = "R.G.B.",
        label = "R.G.B.",
        text = {
            "{C:mult}+#1#{} Mult and {X:mult,C:white}X#2#{} Mult",
            "{C:chips}+#1#{} Chips and {X:chips,C:white}X#2#{} Chips",
            shadercredit("Lily Felli")
        }
    },
    config = { mult = 5, xmult = 1.2, chips = 5, xchips = 1.2 },
    loc_vars = function(self, info_queue, card)
        -- print(self)
        return {
            vars = {
                card and card.edition and card.edition.mult or self.config.mult,
                card and card.edition and card.edition.xmult or self.config.xmult
            }
        }
    end,
    weight = 4,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    calculate = function(self, card, context)
        if (context.edition and context.cardarea == G.jokers and card.config.trigger) or
            (context.main_scoring and context.cardarea == G.play)
        then
            SMODS.calculate_effect(
                {
                    mult = card.edition.mult,
                    chips = card.edition.mult,
                    xmult = card.edition.xmult,
                    xchips = card.edition.xchips
                }, card)
        end

        if context.joker_main then
            card.config.trigger = true
        end

        if context.after then
            card.config.trigger = nil
        end
    end,
    in_pool = function(self, args)
        return true
    end,
    in_shop = true,
}

SMODS.Shader {
    key = "lowqual",
    path = "lowqual.fs"
}

-- SMODS.Edition {
local low_quality = {
    key = "lowqual",
    shader = "lowqual",
    loc_txt = {
        name = "Low Quality",
        label = "Low Quality",
        text = {
            "",
            shadercredit("Lily Felli")
        }
    },
    config = {},
    loc_vars = function(self, info_queue, card)
        -- print(self)
        return {
            vars = {

            }
        }
    end,
    weight = 4,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    calculate = function(self, card, context)

    end,
}
SMODS.draw_ignore_keys["halo"] = true
SMODS.Edition {
    key = "lordly",
    shader = false,
    loc_txt = {
        name = "Lordly",
        label = "Lordly",
        text = {
            "{X:dark_edition,C:white}^#1#{} Mult",
            "Increase by {X:dark_edition,C:white}^#2#{} for each Joker owned",
            shadercredit("Lily Felli")
        }
    },
    config = { emult = 0.05, },
    calculate = function(self, card, context)
        if (context.edition and context.cardarea == G.jokers and card.config.trigger) or
            (context.main_scoring and context.cardarea == G.play)
        then
            SMODS.calculate_effect(
                {
                    emult = 1 + (card.edition.emult * #G.jokers.cards)
                }, card)
        end

        if context.joker_main then
            card.config.trigger = true
        end

        if context.after then
            card.config.trigger = nil
        end
    end,
    weight = 1,
    get_weight = function(self)
        local found = SMODS.find_card("j_valk_lily")
        local n = next(found) and found[1].ability.extra.rate or 1
        return G.GAME.edition_rate * self.weight * (n ^ #SMODS.find_card("j_valk_lily"))
    end,
    loc_vars = function(self, info_queue, card)
        local em = card and card.edition and card.edition.emult or self.config.emult
        return {
            vars = {
                1 + (em * (G.jokers and #G.jokers.cards or 0)),
                em
            }
        }
    end,
    in_pool = function(self, args)
        return true
    end,
    in_shop = true,
}

SMODS.DrawStep {
    key = "lordly",
    func = function(card, layer)
        local draw_halo = (card.edition and card.edition.key == "e_valk_lordly") or card.draw_halo or
        (card.config and card.config.center and card.config.center.has_halo)
        local allowed = layer == "both" or layer == "card"
        if draw_halo and allowed then
            if not card.children.halo then
                card.children.halo = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS['valk_main'],
                    { x = 2, y = 2 })
                card.children.halo.role.draw_major = card
                card.children.halo.states.hover.can = false
                card.children.halo.states.click.can = false
            end

            local scale_mod = 0.07 + 0.02 * math.sin(1.8 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL)) * math.pi * 14) *
                (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 3
            local rotate_mod = 0.05 * math.sin(1.219 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL) * math.pi * 5) * (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 2


            card.children.halo:draw_shader('dissolve', 0, nil, nil, card.children.center, scale_mod, rotate_mod, nil,
                0.1 + 0.03 * math.sin(1.8 * G.TIMERS.REAL), nil, 0.6)
            card.children.halo:draw_shader('dissolve', nil, nil, nil, card.children.center, scale_mod, rotate_mod)
        else
            card.children.halo = nil
        end
    end,
    order = 992999, --lily's favourite number!
}
