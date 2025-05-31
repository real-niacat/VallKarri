SMODS.Atlas {
    key = "tags",
    path = "tags.png",
    px = 34,
    py = 34,
}

SMODS.ObjectType({
	object_type = "ObjectType",
	key = "Kitties",
	default = "j_valk_femtanyl",
	cards = {},
	inject = function(self)
		SMODS.ObjectType.inject(self)
	end,
})

SMODS.Tag {
    key = "catter",
    atlas = "tags",
    pos = {x=0, y=0},
    loc_txt = {
		name = "Catter Tag",
		text = {
			"Next shop will have a {C:attention}Kitty{} joker"
		}
	},
    min_ante = 12,
    
    apply = function(self, tag, context)
        if context.type == "store_joker_create" then

            local card = create_card("Kitties", context.area, nil, nil, nil, nil, nil)
			create_shop_card_ui(card, "Joker", context.area)
			card.states.visible = false
			tag:yep("+", G.C.RED, function()
				card:start_materialize()
				card:set_cost()
				return true
			end)
			tag.triggered = true
			return card

        end
    end
}