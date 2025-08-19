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
    config = {extra = {echips = 1.05}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.echips}}
    end,
    weight = 1,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
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
    config = {extra = {}},
    calculate = function(self, card, context)
        if (context.edition and context.cardarea == G.jokers and card.config.trigger ) 
        or (context.main_scoring and context.cardarea == G.play) then
            local c = SMODS.create_card({set = "Consumeables", edition = "e_negative", area = G.consumeables})
            c:add_to_deck()
            G.consumeables:emplace(c)
        end
    end,
    weight = 1,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end
}