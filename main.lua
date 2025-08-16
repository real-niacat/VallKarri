to_big = to_big or function(x) return x end
to_number = to_number or function(x) return x end
-- no more talisman requirement!

if (not vallkarri) then
    vallkarri = {}
end

vallkarri = {
    show_options_button = true,
}

SMODS.current_mod.optional_features = {
    retrigger_joker = true,
}

vallkarri = SMODS.current_mod
vallkarri_config = vallkarri.config
vallkarri.enabled = copy_table(vallkarri_config)

vallkarri.path = "" .. SMODS.current_mod.path

vallkarri.librat_vals = {red = 62, blue = 61}
vallkarri.last_message = "Dear player. Please make sure to drink water and get eight hours of sleep, its really important to me that you guys stay healthy and strong, - love vagabond"

SMODS.Atlas {
    key = "main",
    path = "assets.png",
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = "atlas2",
    path = "atlas_two.png",
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = "phold",
    path = "placeholder.png",
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = "modicon",
    path = "valk_icon.png",
    px = 34,
    py = 34,
}:register()

merge_recipes = {

}

assert(SMODS.load_file("loadfiles.lua", "vallkarri"))()

Cryptid.pointerblistifytype("rarity", "valk_selfinsert", nil)
Cryptid.pointerblistifytype("rarity", "valk_quillagod", nil)
Cryptid.pointerblistifytype("rarity", "valk_unsurpassed", nil)
Cryptid.pointerblistifytype("rarity", "valk_prestigious", nil)
Cryptid.pointerblistifytype("rarity", "valk_tauic", nil)
Cryptid.pointerblistifytype("rarity", "valk_equip", nil)
Cryptid.pointerblistify( "v_valk_alphaboosterator", nil)
Cryptid.pointerblistify( "v_valk_betaboosterator", nil)
Cryptid.pointerblistify( "v_valk_gammaboosterator", nil)
Cryptid.pointerblistify( "c_valk_freeway", nil)

Cryptid.mod_whitelist["Vall-karri"] = true


-- for lily(me)

-- to-do

-- greedy bastard
-- rare joker
-- when a cat tag is created, destroy it and gain 0.2x mult

-- cat costume
-- legendary joker
-- +1 to adjacent joker values at end of round, increase by 0.1x for each level on every cat tag owned

-- pawprints
-- rare
-- create a cat tag for every kitty joker owned when a blind is skipped

-- assassin kitty
-- epic
-- when a cat tag is levelled to level 5 or beyond, destroy it and gain +^0.1 mult

-- jonh meowk
-- rare
-- x1 mult
-- +0.1x for each cat tag owned
-- increase by +0.05x for every sly joker sold this run

-- the :3
-- rare
-- x3 mult if last chat message contains :3
-- (hidden effect, gives x9 if message contains :3c)

-- crabus
-- legendary joker - entr crossmod
-- unscoring cards become dark cards
-- dark cards scale when scored
-- gains x0.05 chips when a card becomes a dark card

-- roundabout
-- uncommon joker
-- prevent the next source of ante gain
-- when ante gain prevented, lose 1 hand and self destructs

-- chipless cookie
-- uncommon joker
-- +2 joker slots
-- if played poker hand is not the same as the previously played poker hand, self destruct

-- .
-- uncommon joker
-- x0.3 mult for each scoring rankless card

-- callie
-- epic joker
-- ^0.05 for each scoring wild card