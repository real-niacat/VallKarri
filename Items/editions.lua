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
    config = {echips = 1.05},
    loc_vars = function(self, info_queue, card)
        return {vars = {card and card.edition and card.edition.echips or self.config.echips}}
    end,
    weight = 1,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    calculate = function(self, card, context)
        if (context.edition and context.cardarea == G.jokers and card.config.trigger ) 
        or (context.main_scoring and context.cardarea == G.play) then
            SMODS.calculate_effect({echips = card.edition.echips}, card)
        end
    end,
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
    config = {mult = 5, xmult = 1.2, chips = 5, xchips = 1.2},
    loc_vars = function(self, info_queue, card)
        -- print(self)
        return {vars = { 
            card and card.edition and card.edition.mult or self.config.mult,
            card and card.edition and card.edition.xmult or self.config.xmult
         }}
    end,
    weight = 4,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    calculate = function(self, card, context)
        if (context.edition and context.cardarea == G.jokers and card.config.trigger ) 
        or (context.main_scoring and context.cardarea == G.play) then
            SMODS.calculate_effect({mult = card.edition.mult, chips = card.edition.mult, xmult = card.edition.xmult, xchips = card.edition.xchips}, card)
        end
    end,
}

SMODS.Shader {
    key = "lowqual",
    path = "lowqual.fs"
}

SMODS.Edition {
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
    config = {mult = 5, xmult = 1.2, chips = 5, xchips = 1.2},
    loc_vars = function(self, info_queue, card)
        -- print(self)
        return {vars = { 
            card and card.edition and card.edition.mult or self.config.mult,
            card and card.edition and card.edition.xmult or self.config.xmult
         }}
    end,
    weight = 4,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
    calculate = function(self, card, context)
        if (context.edition and context.cardarea == G.jokers and card.config.trigger ) 
        or (context.main_scoring and context.cardarea == G.play) then
            SMODS.calculate_effect({mult = card.edition.mult, chips = card.edition.mult, xmult = card.edition.xmult, xchips = card.edition.xchips}, card)
        end
    end,
}