SMODS.Atlas {
    key = "stakes",
    path = "stakes.png",
    px = 29,
    py = 29,
}

SMODS.Stake {
    key = "glowing",
    applied_stakes = { "cry_ascendant" },
    above_stake = "cry_ascendant",
    prefix_config = { applied_stakes = {mod = false}, above_stake = {mod = false} },
    pos = { x = 0, y = 0 },
    atlas = "stakes",
    loc_txt = {
        name = "Glowing Stake",
        -- colour = "Yellow",
        text = {
        "{C:attention}Overscoring{} is substantially more harsh",
        "and starts earlier"
        }
    },
    colour = G.C.YELLOW,
    shiny = true,
    modifiers = function()
        config_reset()
        G.GAME.ante_config.base_arrows = 1
        G.GAME.ante_config.ante_exponent = 1.1
        G.GAME.ante_config.base_exponent = 2
    end
}

SMODS.Stake {
    key = "corrupted",
    applied_stakes = { "valk_glowing" },
    above_stake = "valk_glowing",
    prefix_config = { applied_stakes = {mod = false}, above_stake = {mod = false} },
    pos = { x = 1, y = 0 },
    atlas = "stakes",
    loc_txt = {
        name = "Corrupted Stake",
        -- colour = "Yellow",
        text = {
        "{C:attention}Overscoring{} is {C:red}extremely{} harsh",
        }
    },
    colour = G.C.red,
    shiny = false,
    modifiers = function()
        config_reset()
        G.GAME.ante_config.base_arrows = 1
        G.GAME.ante_config.ante_exponent = 3
        G.GAME.ante_config.base_exponent = 1
        G.GAME.ante_config.arrow_exponent = 1.05
    end
}