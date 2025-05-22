--- STEAMODDED HEADER
--- MOD_NAME: Vall-karri
--- MOD_ID: vallkarri
--- PREFIX: valk
--- MOD_AUTHOR: [Lily]
--- MOD_DESCRIPTION: I genuinely cannot give you a consistent description of what to expect from this mod.
--- BADGE_COLOUR: e5bf3a
--- DEPENDENCIES: [JenLib, Talisman, Cryptid]
--- VERSION: 0.0.0a
--- PRIORITY: 2147483647


--[[
    dev note:
    this mod is honestly a bit of a mess, at least it feels that way
    it is the first mod ive done actual programming for, rather than just making simple jokers
    please don't judge if it's a bit terrible
]]--

SMODS.Atlas {
    key = "main",
    path = "assets.png",
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = "phold",
    path = "placeholder.png",
    px = 71,
    py = 95,
}

maxArrow = 1e5
-- lovely patch is used if pwx is installed - as this should override since it's a larger limit anyway lol


merge_recipes = {

    {input = {"c_cry_gateway", "c_cry_pointer", "c_soul"}, output = "c_valk_lordcall"},
    {input = {"j_valk_dormantlordess", "j_valk_keystonefragment"}, output = "j_valk_lily"}   

}

local hookref_atd = Card.add_to_deck

-- load other files here

-- stop loading other files because thats how code works
function Card.add_to_deck(self, from_debuff)
    hookref_atd(self, from_debuff)
    local allow = true
    owned_keys = {}

    for i,j in ipairs(G.jokers.cards) do
        table.insert(owned_keys,j.config.center_key)
    end

    for i,j in ipairs(G.consumeables.cards) do
        table.insert(owned_keys,j.config.center_key)
    end

    table.insert(owned_keys, self.config.center_key)
    
    -- print(owned_keys)

    for i,j in ipairs(merge_recipes) do
        
        if table:superset(owned_keys, j.input) then

            for k,ingredient in ipairs(j.input) do
                destroy_first_instance(ingredient)
            end
            -- destroy all cards that are part of recipe
            if table:contains(j.input, self.config.center_key) then
                self:destroy()
            end

            local swj = j.output:find("^j_")
            local area = swj and G.jokers or G.consumeables
            local type = swj and "Joker" or "Consumable"

            local output = create_card(type, area, nil, nil, nil, nil, j.output, "valk_fusion")
            output:add_to_deck()
            area:emplace(output)

        end

    end



    
end



SMODS.Rarity {
    key = 'selfinsert',
    loc_txt = {
        name = 'The Obligatory Self-Insert Overpowered Character'
    },
    badge_colour = G.C.CRY_TWILIGHT
}

SMODS.Rarity {
    key = 'quillagod',
    loc_txt = {
        name = '???'
    },
    badge_colour = G.C.CRY_DAWN
}

SMODS.Rarity {
    key = 'unobtainable',
    loc_txt = {
        name = 'U N O B T A I N A B L E'
    },
    badge_colour = HEX("CE3EA3")
}

SMODS.Rarity {
    key = 'unsurpassed',
    loc_txt = {
        name = 'Unsurpassed'
    },
    badge_colour = HEX("B080FF")
}

SMODS.Rarity {
    key = 'equip',
    loc_txt = {
        name = 'Equippable..?'
    },
    badge_colour = HEX("EB4D4D")
}



assert(SMODS.load_file("Items/helpers.lua"))()
assert(SMODS.load_file("Items/consumables.lua"))()
assert(SMODS.load_file("Items/ante.lua"))()

assert(SMODS.load_file("Items/Jokers/subepic.lua"))()
assert(SMODS.load_file("Items/Jokers/epic.lua"))()
assert(SMODS.load_file("Items/Jokers/legendary.lua"))()
assert(SMODS.load_file("Items/Jokers/exotic.lua"))()
assert(SMODS.load_file("Items/Jokers/exoticplus.lua"))()

Cryptid.pointerblistifytype("rarity", "valk_selfinsert", nil)
Cryptid.pointerblistifytype("rarity", "valk_quillagod", nil)
Cryptid.pointerblistifytype("rarity", "valk_unsurpassed", nil)

