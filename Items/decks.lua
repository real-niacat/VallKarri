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
        G.GAME.disable_ante_gain = true
        ante_config.base_exponent = 1
        ante_config.arrow_exponent = 1.1
    end
}