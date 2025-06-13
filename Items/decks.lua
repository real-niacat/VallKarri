SMODS.Back {
    key = "inertia",
    loc_txt = {
        name = "Inertia Deck",
        text = {
            "Normal ante gain is {C:red,E:1}disabled{}",
            "{C:attention}Overscoring{} is substantially harsher"
        }
    },
    pos = {x=7, y=7},
    atlas = "main",
    apply = function()
        config_reset()
        G.GAME.disable_ante_gain = true
        G.GAME.ante_config.base_exponent = 1.2
        G.GAME.ante_config.arrow_exponent = 1.05
        G.GAME.ante_config.ante_exponent = 2
    end
}