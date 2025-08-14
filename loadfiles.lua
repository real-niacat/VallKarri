assert(SMODS.load_file("Items/postload.lua", "vallkarri"))()

assert(SMODS.load_file("Items/helpers.lua", "vallkarri"))()
assert(SMODS.load_file("Items/overrides.lua", "vallkarri"))()
assert(SMODS.load_file("Items/rarity_definitions.lua", "vallkarri"))()
assert(SMODS.load_file("Items/colour_definitions.lua", "vallkarri"))()
assert(SMODS.load_file("Items/badges.lua", "vallkarri"))()
assert(SMODS.load_file("Items/hand_buffs.lua", "vallkarri"))()


if vallkarri.config.overscoring then
    assert(SMODS.load_file("Items/ante.lua", "vallkarri"))()
end

if vallkarri.config.metaprogression then
    assert(SMODS.load_file("Items/metaprogression.lua", "vallkarri"))()
end

assert(SMODS.load_file("Items/hands.lua", "vallkarri"))()

assert(SMODS.load_file("Items/Jokers/tau.lua", "vallkarri"))()
assert(SMODS.load_file("Items/Jokers/tau/tau_common.lua", "vallkarri"))()
assert(SMODS.load_file("Items/Jokers/tau/tau_uncommon.lua", "vallkarri"))()
assert(SMODS.load_file("Items/Jokers/tau/tau_rare.lua", "vallkarri"))()
assert(SMODS.load_file("Items/Jokers/tau/tau_legendary.lua", "vallkarri"))()

assert(SMODS.load_file("Items/Consumables/code.lua", "vallkarri"))()
assert(SMODS.load_file("Items/Consumables/spectral.lua", "vallkarri"))()
assert(SMODS.load_file("Items/Consumables/special.lua", "vallkarri"))()
assert(SMODS.load_file("Items/Consumables/tarot.lua", "vallkarri"))()
assert(SMODS.load_file("Items/Consumables/planetoids.lua", "vallkarri"))()
assert(SMODS.load_file("Items/Consumables/superplanets.lua", "vallkarri"))()
assert(SMODS.load_file("Items/Consumables/cataclysm.lua", "vallkarri"))()
assert(SMODS.load_file("Items/Consumables/aesthetic.lua", "vallkarri"))()
assert(SMODS.load_file("Items/boosters.lua", "vallkarri"))()
assert(SMODS.load_file("Items/crossmod.lua", "vallkarri"))()


assert(SMODS.load_file("Items/Jokers/cursed.lua", "vallkarri"))()
assert(SMODS.load_file("Items/Jokers/animation.lua", "vallkarri"))()
assert(SMODS.load_file("Items/Jokers/scp.lua", "vallkarri"))()
assert(SMODS.load_file("Items/Jokers/subepic.lua", "vallkarri"))()
assert(SMODS.load_file("Items/Jokers/epic.lua", "vallkarri"))()
assert(SMODS.load_file("Items/Jokers/legendary.lua", "vallkarri"))()
assert(SMODS.load_file("Items/Jokers/exotic.lua", "vallkarri"))()
assert(SMODS.load_file("Items/Jokers/exoticplus.lua", "vallkarri"))()

assert(SMODS.load_file("Items/blinds.lua", "vallkarri"))()
assert(SMODS.load_file("Items/tags.lua", "vallkarri"))()
assert(SMODS.load_file("Items/decks.lua", "vallkarri"))()
assert(SMODS.load_file("Items/vouchers.lua", "vallkarri"))()
assert(SMODS.load_file("Items/configui.lua", "vallkarri"))()
assert(SMODS.load_file("Items/enhancements.lua", "vallkarri"))()
assert(SMODS.load_file("Items/globalcalc.lua", "vallkarri"))()

assert(SMODS.load_file("Items/quips.lua", "vallkarri"))()