SMODS.Joker {
    key = "suckit",
    loc_txt = {
        name = "{C:red}Suck It{}",
        text = {
            "Creates itself when removed",
            "Makes itself {C:purple}eternal{} when created",
            "{C:inactive}Suck it.{}",
        }
    },
    config = { extra = {} },
    rarity = 1,
    atlas = "main",
    pos = {x=4, y=5},
    cost = 1,

    add_to_deck = function(self, card, from_debuff)
        card:set_eternal(true)
    end,

    remove_from_deck = function(self, card, from_debuff)
        simple_create("Joker", G.jokers, "j_valk_suckit")
    end
}

SMODS.Joker {
    key = "whereclick",
    loc_txt = {
        name = "{C:red}Where do I click?{}",
        text = {
            "Gains {X:mult,C:white}X#1#{} Mult when mouse clicked",
            "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult){}",
            "{C:inactive}Where do I click, Drago?{}"
        }
    },
    config = { extra = {cur = 0.99, gain = 1e-3} },
    rarity = 2,
    atlas = "main",
    pos = {x=4, y=6},
    cost = 6,

    loc_vars = function(self,info_queue, card)
        return {vars = {card.ability.extra.gain, card.ability.extra.cur}}
    end,

    calculate = function(self, card, context)
        if context.cry_press then
            card.ability.extra.cur = card.ability.extra.cur + card.ability.extra.gain
        end

        if context.joker_main then
            return {x_mult = card.ability.extra.cur}
        end
    end
}

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
    rarity = 3,
    atlas = "main",
    pos = {x=5, y=2},
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
    lvl = to_big(lvl)
    if (lvl < to_big(5)) then
        return "+"
    elseif (lvl < to_big(10)) then
        return "X"
    else
        return "^"
    end
end

local function strength(lvl)
    lvl = to_big(lvl)
    if (lvl < to_big(5)) then
        return lvl * 5
    elseif (lvl < to_big(10)) then
        return lvl
    else
        return lvl / 2
    end
end

local function level(xp)
    local start = to_big(10)
    local curlevel = to_big(0)
    while (to_big(xp) > start) do
        curlevel = curlevel + 1
        start = start:pow(to_big(1.15))
    end

    return {level = lenient_bignum(curlevel), xpreq = start}
end

SMODS.Joker {
-- disabledjoker = {
    -- this joker is not worth my time. please shoot me
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
    config = { extra = { xp = to_big(1), } },
    loc_vars = function(self, info_queue, card)

        local stats = level(card.ability.extra.xp)

        return {vars = {number_format(card.ability.extra.xp), number_format(stats.xpreq), number_format(stats.level), op(stats.level) .. number_format(strength(stats.level))}}
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
    key = "femtanyl",
    loc_txt = {
        name = "Femtanyl",
        text = {
            "Prevents death at the cost of {C:attention}#1#{} joker slot",
            "Return lost joker slot after {C:attention}#2#{} round(s)",
            "Increase round timer by {C:attention}#3#{} and earn {C:money}$#4#{} when death is prevented",
            "{C:inactive}Dying again or removing this joker while the timer is active{}",
            "{C:inactive}will result in not recovering a joker slot{}",
            "{C:inactive}Does not prevent death if you end up below 3 joker slots{}",
            
            quote("femtanyl"),
            credit("Scraptake")
        }
    },
    config = { extra = { cost = 1, increase = 1, timer = 0, timerbase = 2, money = 10 } },
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.cost, card.ability.extra.timerbase, card.ability.extra.increase, card.ability.extra.money}}
    end,
    rarity = 3,
    atlas = "main",
    pos = {x=0, y=5},
    soul_pos = {x=1, y=5},
    cost = 6,
    calculate = function(self, card, context)

        if (context.end_of_round and not context.blueprint and not context.individual) then
            card.ability.extra.timer = card.ability.extra.timer - 1

            if (card.ability.extra.timer == 0) then
                G.jokers:change_size(card.ability.extra.cost, false)
            end
        end

        if (context.end_of_round and not context.blueprint and context.game_over) then

            local slots = G.jokers.config.card_limit - card.ability.extra.cost
            G.jokers:change_size(-card.ability.extra.cost, false)
            card.ability.extra.timer = card.ability.extra.timerbase
            card.ability.extra.timerbase = card.ability.extra.timerbase + card.ability.extra.increase
            

            if (slots >= 3) then
                ease_dollars(card.ability.extra.money)
                return {saved = true}
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
            "Does nothing, it is better used {C:edition,X:dark_edition}elsewhere...{}",
        }
    },
    config = { extra = {  } },
    rarity = "valk_equip",
    atlas = "main",
    pos = {x=4,y=2},
    soul_pos = {x=2,y=2}, --halo
    cost = 66,

    in_pool = function()
        return (#SMODS.find_card("j_valk_dormantlordess") > 0)
    end
}
-- watcher does NOT always look stupid 