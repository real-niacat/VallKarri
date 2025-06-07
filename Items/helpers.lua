function credit(artist)
	return ('{C:dark_edition,s:0.6,E:2}Art by : ' .. artist .. '{}')
end

function concept(creator)
	return ('{C:dark_edition,s:0.6,E:2}Idea by : ' .. creator .. '{}')
end

short_sprites = {
    placeholder = {x=0,y=0},

    halo = {x=2, y=2}
}

function days_since(year, month, day)

    local now = os.date("*t")
    local then_time = os.time{year=year, month=month, day=day, hour=0}
    local diff = os.difftime(os.time(now), then_time)
    return math.floor(diff / (60 * 60 * 24))

end



external_joker_data = {
    
}

function quote(character)
    -- assume character is in quotes because i'm not a fucking idiot
    local quotes = {
        lily = "thank you. that feels much better.",
        lily2 = "i'm flattered you think i'm powerful",
        illena = "i'm here to help, nothing better to do.",
        quilla = "sorry i can't help you directly, i don't want to hurt anything.",
        quilla2 = "and no, lily isn't lying.",
        niko = "sorry im not wearing the twink bowtie :c",
        orivander = "Behold, the absolute force of gravity",
        raxd = "NUCLEAR BOMB!??!?!?",
        femtanyl = "we r online. we r online.",
        lilac = "A medium iced cappuccino, p-please.",
        ovilidoth = "NO QUOTE RIGHT NOW PLEASE",
        dormant = "I'm missing something.",
        dormant2 = "Help me find it and I'll make it worth your time.",
        scraptake = "good kitty",
        hornet = "silksong tommorow",
        valklua = "Thank you for playing <3",
    }


    if (SMODS.find_mod("entr")) then
        quotes.lily2 = "ah, i feel stronger here"
    end

    return ('{C:enhanced,s:0.7,E:1}' .. quotes[character] .. '{}')

end
 
function table:remove_by_function(t, func)
    for i = #t, 1, -1 do
        if func(t[i]) then
            table.remove(t, i)
        end
    end
end

function table:merge(t_a, t_b)
    
    -- add everything from t_b to t_a
    for i, v in ipairs(t_b) do
        table.insert(t_a, v)
    end
    return t_a

end

function table:contains(table, value)
    for i,j in ipairs(table) do
        if (j == value) then return true end
    end
    return false
end

function table:superset(t_a, t_b)
    local valid = true

    for i,j in ipairs(t_b) do
        valid = valid and table:contains(t_a,j)
    end
    return valid
end

function table:random_element(table)
    local keys = {}
    for key in pairs(table) do
        table.insert(keys, key)
    end
    local random_key = keys[math.random(#keys)]
    return table[random_key]
end

function destroy_first_instance(key)
    local found = SMODS.find_card(key)
    if #found > 0 then
        (select(2, next(found))):quick_dissolve()
    end
end

function joker_owned(key) 

    if (G.jokers and G.jokers.cards) then

        for i,card in ipairs(G.jokers.cards) do
        
            if (card.config.center.key == key) then return true end

        end

    end

    return false

end

function get_first_instance(key)
    local found = SMODS.find_card(key)
    if #found > 0 then
        return select(2, next(found))
    end
    return nil
end

function Card:quick_dissolve()
	self.ability.eternal = nil
	self.ignore_incantation_consumable_in_use = true
	self.true_dissolve = true
	self:start_dissolve(nil, nil, nil, nil)
end

function simple_create(type, area, key)
    local card = create_card(type, area, nil, nil, nil, nil, key, "simple_create")
    card:add_to_deck()
    area:emplace(card)
end

function debug_print_antes()

    local ante = 1
    local i = 1
    local i2 = 1
    while ante < 1e300 do
        local blind_amount = tostring(get_blind_amount(ante) or "nil")
        print("Ante " .. ante .. ": " .. blind_amount)
        
        if (ante > 15) then
            ante = ante * 1e10
        else
            ante = ante + i
        end
    end

end

function corrupt_text(text, amount)

    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+[];:',.<>/?|"
    -- amount is a 0-1 being a chance to replace each character with a rnd one

    for i = 1, #text do
        if math.random() < amount then
            local rand_index = math.random(1, #chars)
            local random_char = chars:sub(rand_index, rand_index)
            text = text:sub(1, i-1) .. random_char .. text:sub(i+1)
        end
    end
    return text
end

function jokercount()
    if (G.jokers) then
        return #G.jokers.cards
    else
        return 0
    end
end

-- i take no credit for these functions, theyre just slightly modified
-- versions of jenlib functions, as i don't like the text color which jenlib uses
function expochips(txt)
	return "{X:chips,C:white}^" .. txt .. "{}"
end

function expomult(txt)
	return "{X:mult,C:white}^" .. txt .. "{}"
end

-- chips and mult are identical since it uses x:dark
function tetrvalue(txt)
	return "{X:dark_edition,C:white}^^" .. txt .. "{}"
end

function totaljokervalues()
    local total = to_big(0)
    if (G.jokers) then
        for i,card in ipairs(G.jokers.cards) do

            if (card.ability.extra and type(card.ability.extra) == "table") then 
                for j,entry in pairs(card.ability.extra) do
                
                    if type(entry) == "number" or (type(entry) == "table" and entry.tetrate) then
                        total = total + entry
                    end

                end 
            end

        end
    end


    return total
end

function reptlog(base, lim, num)

    for i = 1, lim do
        num = math.log(num, base)
    end

    return num

end

function get_first(area) 
    return select(2,next(area))
end

function run_debug()
    assert(SMODS.load_file("debug.lua", "vallkarri"))()
end

function hotswap()
    assert(SMODS.load_file("loadfiles.lua", "vallkarri"))()
end

function valk_additions()
    local total = 0
    for _, entry in pairs(G.P_CENTERS) do
        if string.find(entry.key, "valk") then
            total = total + 1
        end
    end

    return total
end

function get_a_somewhat_large_number()
    local largenumber = to_big(10):arrow(10,10)
    return largenumber:arrow(10000,largenumber)
end

function scraptake_calculation()
    local calced, b = 0, 0

    if (not G.jokers or not G.playing_cards) then
        return 0
    end


    for i,jok in ipairs(G.jokers.cards) do
        if (string.find(jok.config.center_key, "valk")) then
            calced = calced + 1
        end
    end

    for _, playing_card in pairs(G.playing_cards) do
        if next(SMODS.get_enhancements(playing_card)) then
            b = b + 1
        end
    end

    calced = calced ^ b
    return calced
end

if (vallkarri.config.risky_stuff) then

    local gcpov = get_current_pool
    function get_current_pool(_type, _rarity, _legendary, _append, override_equilibrium_effect)
        if _type == "Joker" and joker_owned("j_valk_jokerofequality") then
            -- print("success")
            local ret = {}

            local generated = 1

            local rarities = {1, 2, 3, "cry_epic", 4, "cry_exotic"}
            local roll = pseudorandom("jokerofequality", 1, 100)

            if _legendary then
                _rarity = 4
            end

            if (roll <= 74) then
                generated = 1
            elseif (roll <= 94) then
                generated = 2
            elseif (roll <= 99) then
                generated = 3 
            else
                generated = "cry_epic"
            end

            for i,inst in pairs(G.P_CENTERS) do

                if (inst.rarity == (_rarity or generated) ) then
                    table.insert(ret, inst.key)
                end

            end


            -- print(tostring() .. " vs " .. tostring(table:contains(gcpov(_type, _rarity, _legendary, _append, override_equilibrium_effect), "j_joker")) )
            --done to test if base joker is in vanilla pool vs my pool

            if (table:contains(ret, "j_joker") and not table:contains(gcpov(_type, _rarity, _legendary, _append, override_equilibrium_effect), "j_joker")) then

                -- print("removing j_joker from pool")
                for i,inst in ipairs(ret) do
                    if (inst == "j_joker") then
                        table.remove(ret, i)
                        break
                    end
                end
            end

            return ret, "Joker"..(_rarity or '')
            -- if i ever kill myself i want you to consider this hook of 'get_current_pool' as a potential reason

        end
        local p, pk = gcpov(_type, _rarity, _legendary, _append, override_equilibrium_effect)
        return p, pk

    end

end

function level_all_hands(source, amount, mul)
    if amount == nil then 
        amount = 1
    end

    if mul == nil then 
        mul = 1
    end

    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_all_hands'),chips = '...', mult = '...', level=''})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
        play_sound('tarot1')
        if source then source:juice_up(0.8, 0.5) end
        G.TAROT_INTERRUPT_PULSE = true
        return true end 
    }))

    update_hand_text({delay = 0}, {mult = '+', StatusText = true})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
        play_sound('tarot1')
        if source then source:juice_up(0.8, 0.5) end
        return true end
    }))
    update_hand_text({delay = 0}, {chips = '+', StatusText = true})
    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
        play_sound('tarot1')
        if source then source:juice_up(0.8, 0.5) end
        G.TAROT_INTERRUPT_PULSE = nil
        return true end
    }))
    local text = amount > 0 and "+"..amount or amount
    if mul ~= 1 then 
        text = "(" .. text .. ")X"..mul
    end

    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level=text})

    delay(1.3)
    for k, v in pairs(G.GAME.hands) do
        level_up_hand(source, k, true, amount + (v.level * mul))
    end
    update_hand_text({delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
end

function dvi(value)
    for i,joker in ipairs(G.jokers.cards) do
        Cryptid.misprintize(joker, {min=value, max=value}, false, true)
    end
end

function disable_mult_ui() 

    G.GAME.mult_disabled = true
    G.HUD:get_UIE_by_ID("chipmult_op").UIT = 0
    G.HUD:get_UIE_by_ID("hand_mult_area").UIT = 0
    G.HUD:get_UIE_by_ID("hand_mult").UIT = 0
    G.HUD:get_UIE_by_ID("flame_mult").UIT = 0
    G.HUD:get_UIE_by_ID("hand_chip_area").config.minw = 4
    G.HUD:get_UIE_by_ID("hand_mult_area").config.minw = 0
    G.HUD:get_UIE_by_ID("hand_mult_area").config.minh = 0
    G.HUD:get_UIE_by_ID("chipmult_op").scale = 0

    G.HUD:recalculate()

end