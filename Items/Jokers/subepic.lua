SMODS.Joker {
    key = "bags",
    loc_txt = {
        name = "Bags",
        text = {
            "{C:chips}+#1#{} chips",
            "Increases by {C:attention}#2#{} at end of round",
            "Increases the increase by {C:attention}#3#{} at end of round."
        }
    },
    config = { extra = { curchips = 1, inc = 1, incsq = 1} },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.curchips, card.ability.extra.inc, card.ability.extra.incsq } }
    end,
    rarity = 2,
    atlas = "main",
    pos = {x=0, y=9},
    soul_pos = {x=6, y=2},
    cost = 4,
    calculate = function(self, card, context)
        if (context.joker_main) then
            return {chips = card.ability.extra.curchips}
        end

        if (context.end_of_round and not context.blueprint and not context.individual) then
            -- thank you smg9000..... :sob: i might be geeked
            -- i was really tired when i made this

            card.ability.extra.curchips = card.ability.extra.curchips + card.ability.extra.inc
            card.ability.extra.inc = card.ability.extra.inc + card.ability.extra.incsq
        end
    end
}

local function op(lvl)
    if (lvl < 5) then
        return "+"
    elseif (lvl < 10) then
        return "X"
    else
        return "^"
    end
end

local function strength(lvl)
    if (lvl < 5) then
        return lvl * 5
    elseif (lvl < 10) then
        return lvl
    else
        return lvl / 2
    end
end

local function level(xp, exponent)
    local start = 10
    local curlevel = 0
    while (xp > start) do
        curlevel = curlevel + 1
        start = math.pow(start, (exponent or 1.2))
    end

    return {level = curlevel, xpreq = start}
end

SMODS.Joker {
-- disabledjoker = {
    -- I FUCKING HATE OIL LAMP
    key = "ovilidoth",
    loc_txt = {
        name = "Ovilidoth",
        text = {
            "{C:attention}#1# {C:inactive}/{C:attention} #2# {}XP",
            "{C:inactive,s:0.6}Hint: value manipulation!{}",
            "Level : {C:attention}#3#{}",
            "Currently does: {X:mult,C:white}#4#{} Mult",
            quote("ovilidoth"),
            credit("Scraptake")

        }
    },
    -- config = { extra = { xp = to_big(1), }, external_data = {level = 1, req = to_big(10), scale_exp = 2} },
    config = { extra = { xp = 1, } },
    -- config = { extra = { xp = 1, }, level = 1, req = 10, scale_exp = 2},
    loc_vars = function(self, info_queue, card)

        local stats = level(card.ability.extra.xp)

        return {vars = {(card.ability.extra.xp), stats.xpreq, stats.level, op(stats.level) .. strength(stats.level)}}
    end,
    rarity = 3,
    atlas = "main",
    pos = {x=5, y=9},
    soul_pos = {x=6,y=9},
    cost = 8,

    calculate = function(self, card, context)
        -- please fucking kill me
        if (context.joker_main) then
            local lvl = level(card.ability.extra.xp).level

            local operator = op(lvl)
            local str = strength(lvl)

            if (operator == "+") then
                return {mult = str}
            elseif (operator == "X") then
                return {x_mult = str}
            else
                return {e_mult = math.pow(str,lvl/5)}
            end


        end

    end
}

SMODS.Joker {
    key = "keystonefragment",
    loc_txt = {
        name = "{C:money}Key{C:red}stone {C:money}Frag{C:red}ment",
        text = {
            "Channels the power from the {C:edition,X:dark_edition}Infinite{}",
            "Slightly reduces blind size, but it is better used {C:edition,X:dark_edition}elsewhere...{}",
        }
    },
    config = { extra = {  } },
    rarity = 3,
    atlas = "phold",
    pos = placeholder(),
    soul_pos = placeholder(),
    cost = 66,

    calculate = function(self, card, context)

        if (context.setting_blind and not context.individual) then
            G.GAME.blind.chips = G.GAME.blind.chips * 0.76 
        end

    end
}
-- watcher does NOT always look stupid 