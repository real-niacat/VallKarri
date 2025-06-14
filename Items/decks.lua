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
        G.GAME.ante_config.base_exponent = 1.4
        G.GAME.ante_config.arrow_exponent = 1.05
        G.GAME.ante_config.ante_exponent = 2
    end
}

-- SMODS.Back {
--     key = "overstuffed",
--     loc_txt = {
--         name = "Overstuffed Deck",
--         text = {
--             "When first hand drawn, draw the",
--             "{C:attention}best{} poker hand possible.",
--             "Cards drawn this way",
--             "are given the {C:attention}Light{} enhancement"
--         }
--     },
--     pos = {x=7, y=7},
--     atlas = "main",
--     calculate = function(center, back, context)

--         if context.first_hand_drawn then
            
--             local ordered = {}
--             for name,hand in pairs(G.GAME.hands) do
--                 ordered[hand.order] = hand
--                 ordered[hand.order].handname = name
--             end

--             local i = 1
--             local found = false
--             while not found do
--                 found = get_handtype(ordered[i].name)
--                 i = i + 1
--             end

--             draw_to_hand(found)

--         end

--     end
-- }