local ranks = {'Jack', 'Queen', "King", "Ace", "10", "9", "8", "7", "6", "5", "4", "3", "2"}

local description = {
    hearts = "Lily (By gudusername)",
    clubs = "Lily (By gudusername)",
    diamonds = "Lily (By gudusername)",
    spades = "Lily (By gudusername)",
}

SMODS.Atlas{  
    key = "lily_cards",
    px = 71,
    py = 95,
    path = "lily_cards.png",
}

for _, suit in ipairs({"hearts", "clubs", "diamonds", "spades"}) do
    SMODS.DeckSkin{
        key = suit.."_skin",
        suit = suit:gsub("^%l", string.upper),
        ranks = ranks,
		display_ranks = {"Ace", "King", "Queen", "Jack"},
        lc_atlas = "valk_lily_cards",
        loc_txt = {["en-us"] = description[suit]},
        posStyle = 'deck'
    }
end