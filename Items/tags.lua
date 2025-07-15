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
			"Next shop will have a {C:attention}Kitty Joker{}",
			credit("Scraptake")
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

SMODS.Tag {
    key = "negativeeternal",
    atlas = "tags",
    pos = {x=1, y=0},
    loc_txt = {
		name = "Negative Eternal Tag",
		text = {
			"Next base edition shop Joker",
			"will be {C:attention}free, {C:dark_edition}Negative{}",
			"and {C:purple}eternal{}",
			credit("Pangaea")
		}
	},
    min_ante = 0,
    
    apply = function(self, tag, context)
        if context.type == "store_joker_modify" then
			local _applied = nil
			if Cryptid.forced_edition() then
				tag:nope()
			end
			if not context.card.edition and not context.card.temp_edition and context.card.ability.set == "Joker" then
				local lock = tag.ID
				G.CONTROLLER.locks[lock] = true
				context.card.temp_edition = true
				tag:yep("+", G.C.DARK_EDITION, function()
					context.card:set_edition("e_negative", true)
					context.card.ability.eternal = true
					context.card.ability.couponed = true
					context.card:set_cost()
					context.card.temp_edition = nil
					G.CONTROLLER.locks[lock] = nil
					return true
				end)
				_applied = true
				tag.triggered = true
			end

		end
    end
}