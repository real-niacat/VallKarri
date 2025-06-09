local vanilla_decks = {
    "Red Deck",
    "Blue Deck",
    "Yellow Deck",
    "Green Deck",
    "Black Deck",
    "Magic Deck",
    "Nebula Deck",
    "Ghost Deck",
    "Abandoned Deck",
    "Checkered Deck",
    "Zodiac Deck",
    "Painted Deck",
    "Anaglyph Deck",
    "Plasma Deck",
    "Erratic Deck",
}

SMODS.Voucher {

    key = "quantumparticle",
    atlas = "main",
    pos = {x=7, y=4},
    loc_txt = {
        name = "{C:cry_azure}Quantum Particle{}",
        text = {
            "Severely {C:attention,E:1}enhances{} your deck",
            "{C:inactive,s:0.85}(Does nothing on non-vanilla decks){}"
        }
    },

    loc_vars = function(self, info_queue, card)

    end,

    in_pool = function()
        local v = table:contains(vanilla_decks, G.GAME.selected_back.name)
        return v

    end,

    redeem = function(self, card)

    end


}