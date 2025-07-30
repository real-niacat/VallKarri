SMODS.Joker {
    key = "vallkarrilua",
    loc_txt = {
        name = "{C:valk_blue}Vall-Karri.lua",
        text = {
            "{X:dark_edition,C:white}^^#1#{} Mult for every piece of content that {B:1,E:2,C:white}Vall-karri{} adds",
            "{C:inactive}(Currently {X:dark_edition,C:white}^^#2#{C:inactive} Mult){}",
            quote("valklua"),
            credit("Grahkon"),
        }
    },
    config = { extra = { mult = 1 } },
    loc_vars = function(self, info_queue, card)
        local total = valk_additions()

        

        return {vars = {card.ability.extra.mult, total*card.ability.extra.mult, colours = {HEX("e5bf3a")}}  }
    end,
    rarity = "valk_prestigious",
    atlas = "main",
    pos = {x = 8, y = 11},
    soul_pos = {extra = {x=9, y=11}, x=10, y=11},
    cost = 500,
    immutable = true,
    demicoloncompat = true,
    calculate = function(self, card, context)
        
        if context.joker_main or context.forcetrigger then

            return {
                ee_mult = valk_additions()*card.ability.extra.mult
            }
        end
    end,
    dependencies = {"Talisman"},
}

SMODS.Joker {
    key = "phicer",
    loc_txt = {
        name = "Phicer Rekiniov",
        text = {
            "Create a random {C:attention}perishable{} ",
            "{C:cry_exotic}Exotic{} Joker at end of round",
            quote("phicer"),
            credit("Nerxiana"),
        }
    },
    config = { extra = { nchips = 2 } },
    loc_vars = function(self, info_queue, card)

        
        local op = 1+(#SMODS.find_card("j_valk_phicer"))
        return {vars = {"{"..op.."}", card.ability.extra.nchips}}
    end,
    rarity = "valk_prestigious",
    atlas = "main",
    pos = {x = 2, y = 13},
    soul_pos = {x = 3, y = 13},
    cost = 500,
    immutable = true,
    demicoloncompat = true,
    blueprint_compat = true,
    calculate = function(self, card, context)
        
        if context.end_of_round and context.main_eval then

            local exotic = create_card("Joker", G.jokers, nil, "cry_exotic", nil, nil, nil, "valk_phicer")
            exotic:set_perishable(true)
            exotic:add_to_deck()
            G.jokers:emplace(exotic)

        end

    end,

    lore = {
        "Phicer Rekiniov is a magical casino owner, who's",
        "garnered a somewhat cult-like following over time.",
        "",
        "She is capable of doing highly-complex magic, but prefers to",
        "use simpler magic for things like summoning workers.",
        "",
        "Though, if needed she can summon weaker versions of",
        "monsters like dragons, wyrms or angel-like entities."
    }
}

if MoreFluff then
    SMODS.Atlas {
        key = "triangle",
        path = "triangle_walk_lowered.png",
        px = 71,
        py = 95,
    }

    SMODS.Joker {
        key = "triangle",
        loc_txt = {
            name = "Triangle",
            text = {
                "When {C:attention}Blind{} selected, create {C:attention}#1#{} {C:dark_edition}Negative{} {C:colourcard}Colour{} cards",
                "All {C:colourcard}Colour{} cards gain {C:attention}+#2#{} rounds when {C:attention}3{} scored",
                credit("notmario"),
            }
        },
        config = { extra = { rounds = 3, cards = 3 }, immutable = {buffer = 0} },
        loc_vars = function(self, info_queue, card)

            

            return {vars = {card.ability.extra.cards, card.ability.extra.rounds}}
        end,
        rarity = "valk_prestigious",
        atlas = "triangle",
        pos = {x = 12, y = 4},
        soul_pos = {x = 0, y = 0},
        cost = 500,
        immutable = true,
        demicoloncompat = true,
        calculate = function(self, card, context)
            if context.setting_blind then
                for i=1,card.ability.extra.cards do
                    local colour = create_card("Colour", G.consumeables, nil, nil, nil, nil, nil, "valk_triangle")
                    colour:add_to_deck()
                    colour:set_edition("e_negative")
                    G.consumeables:emplace(colour)
                end
            end

            if context.individual and context.cardarea == G.play and context.other_card:get_id() == 3 then

                for i=1,card.ability.extra.rounds do
                    colour_end_of_round_effects()
                    
                end

            end

        end,

        update = function(self, card, front)
            card.ability.immutable.buffer = card.ability.immutable.buffer + 1
            if card.ability.immutable.buffer >= 2 then 
                card.ability.immutable.buffer = 0
                local pos = card.children.floating_sprite.sprite_pos
                local new = {x=pos.x+1, y=pos.y}
                if new.x > 12 then
                    new.x = 0
                    new.y = new.y + 1
                end
                if new.x >= 12 and new.y >= 4 then
                    new.x = 0
                    new.y = 0
                end
                -- print(new)

                card.children.floating_sprite:set_sprite_pos(new)

            end
        end,
    }
end