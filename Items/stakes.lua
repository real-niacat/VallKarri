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
        "{C:attention}Overscoring{} is substantially harsher",
        "and starts earlier"
        }
    },
    colour = G.C.YELLOW,
    shiny = true,
    modifiers = function()
        ante_config.base_arrows = 0
        ante_config.ante_exponent = 1.1
        ante_config.arrow_inc_threshold = 3
        ante_config.base_exponent = 2
    end
}