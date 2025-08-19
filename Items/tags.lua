SMODS.Atlas {
	key = "tags",
	path = "tags.png",
	px = 34,
	py = 34,
}

SMODS.ObjectType({
	object_type = "ObjectType",
	key = "Kitties",
	default = "j_valk_amber",
	cards = {},
	inject = function(self)
		SMODS.ObjectType.inject(self)
	end,
})

SMODS.Tag {
	key = "kitty",
	atlas = "tags",
	pos = { x = 0, y = 0 },
	loc_txt = {
		name = "Kitty Tag",
		text = {
			"Gives {C:chips}+#1#{} Chips for every",
			"{C:attention}Kitty Tag{} owned",
			credit("Scraptake")
		}
	},
	config = { chips = 2 },
	loc_vars = function(self, info_queue, tag)
		return { vars = { tag.config.chips } }
	end,
	min_ante = 1e100, --just. dont spawn.

	apply = function(self, tag, context)
		if context.type == "valk_final_scoring_step" then --functionality assisted by reading morefluff code
			SMODS.calculate_effect({ chips = vallkarri.count_kitty_tags() * tag.config.chips }, tag)
		end
	end
}

SMODS.Tag {
	key = "negativeeternal",
	atlas = "tags",
	pos = { x = 1, y = 0 },
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
