SMODS.Atlas {
    key = "tau",
    path = "tauic_jokers.png",
    px = 71,
    py = 95,
}

function tauic_check()
    for i,joker in ipairs(G.jokers.cards) do
        if joker.config.center.tau then
            return true
        end
    end

    return false
end

function tauic_owned()

    for i,joker in ipairs(G.jokers.cards) do

        if joker.config.center.rarity == "valk_tauic" then
            return true 
        end 

    end

    return false
end

SMODS.Joker {
    key = "tauist",
    loc_txt = {
        name = "Tauist",
        text = {
            "{C:valk_fire}Tauic{} Joker variants have their spawn",
            "chances increased whenever their roll fails",
            "{C:inactive}(Currently a {C:green}#1#%{C:inactive} chance to replace)",
        }
    },
    valk_artist = "Scraptake",
    config = { extra = { } },
    loc_vars = function(self, info_queue, card)
        local c = 0
        if G.GAME and G.GAME.tau_replace then
            c = 100 * (1 / G.GAME.tau_replace)
        end
        return { vars = { c } }
    end,
    rarity = 3,
    atlas = "main",
    pos = {x=8, y=4},
    soul_pos = {x=8, y=8, extra = {x=9, y=4}},
    cost = 12,
    add_to_deck = function(self, card, from_debuff)
        G.GAME.tau_increase = G.GAME.tau_increase + 2
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.tau_increase = G.GAME.tau_increase - 2
    end
}

SMODS.Consumable {
    set = "Spectral",
    key = "absolutetau",

    cost = 150,
    atlas = "main",
    pos = {x=3, y=5},
    -- is_soul = true,
    soul_rate = 0.01,

    loc_txt = { 
        name = "Absolute Tau",
        text = {
            "Create a random {C:valk_fire}Tauic{} {C:legendary}Legendary{} Joker",
        }
    },
    valk_artist = "mailingway",

    can_use = function(self, card)
        return true
    end,

    in_pool = function()
        return false 
    end,

    use = function(self, card, area, copier) 
        local allowed = {}
        for i,joker in pairs(G.P_CENTER_POOLS.Joker) do
            if joker.rarity == 4 and joker.tau then
                allowed[#allowed+1] = joker.tau
            end
        end
        
        simple_create("Joker", G.jokers, allowed[pseudorandom("valk_absolute_tau",1,#allowed)])

    end,
    dependencies = {"Talisman"},
}







