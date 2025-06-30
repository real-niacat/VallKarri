function credit(artist)
	return ('{C:dark_edition,s:0.6,E:2}Art by : ' .. artist .. '{}')
end

function concept(creator)
	-- return ('{C:dark_edition,s:0.6,E:2}Idea by : ' .. creator .. '{}')
    return ""
end

short_sprites = {
    placeholder = {x=0,y=0},

    halo = {x=2, y=2}
}

function days_since(year, month, day)

    local now = os.date("*t")
    local then_time = os.time({year=year, month=month, day=day, hour=0})
    local diff = os.difftime(os.time(now), then_time)
    return math.floor(diff / (60 * 60 * 24))

end

function quote(character)
    -- assume character is in quotes because i'm not a fucking idiot
    local quotes = {
        lily = "thank you. that feels much better.",
        lily2 = "i'm flattered you think i'm powerful",
        illena = "i'm here to help, nothing better to do.",
        quilla = "is my wife here? ehe",
        quilla2 = "Lily, i mean Lily. is she here?",
        niko = "sorry im not wearing the twink bowtie :c",
        orivander = "Behold, the absolute force of gravity",
        raxd = "NUCLEAR BOMB!??!?!?",
        femtanyl = "we r online. we r online.",
        lilac = "A medium iced cappuccino, p-please.",
        ovilidoth = "",
        dormant = "I'm missing something.",
        dormant2 = "Help me find it and I'll make it worth your time.",
        scraptake = "good kitty",
        hornet = "silksong tommorow",
        valklua = "Thank you for playing <3",
        phicer = "Who would've known I'd be cursed to see these cards again?"
    }

    return ('{C:enhanced,s:0.7,E:1}' .. quotes[character] .. '{}')

end

function chardesc(text)

    return ('{C:inactive,s:0.7,E:1}' .. text .. '{}')

end


-- simplified code from jenlib

function basic_text_announce(txt, duration, size, col, snd, sndpitch, sndvol)
	G.E_MANAGER:add_event(Event({
		func = (function()
			if snd then play_sound(snd, sndpitch, sndvol) end
			attention_text({
				scale = size or 1.4, text = txt, hold = duration or 2, colour = col or G.C.WHITE, align = 'cm', offset = {x = 0,y = -2.7},major = G.play
			})
		return true
	end)}))
end

function quick_hand_text(name, chip, mul, lv, notif, snd, vol, pit, de)
	update_hand_text({sound = type(snd) == 'string' and snd or type(snd) == 'nil' and 'button', volume = vol or 0.7, pitch = pit or 0.8, delay = de or 0.3}, {handname=name or '????', chips = chip or '?', mult = mul or '?', level=lv or '?', StatusText = notif})
end

function simple_hand_text(hand, notify)
	if hand == 'all' or hand == 'allhands' or hand == 'all_hands' then
		quick_hand_text(localize('k_all_hands'), '...', '...', '', notify)
	elseif G.GAME.hands[hand] then
		quick_hand_text(localize(hand, 'poker_hands'), G.GAME.hands[hand].chips, G.GAME.hands[hand].mult, G.GAME.hands[hand].level, notify)
	end
end

function ratiocalc(a, b, c, d)
    local larger = math.max(a,b)
    local smaller = math.min(a,b)

    return ((smaller / larger) ^ c) * d

end

function mostplayed_name()

    local name = nil
    local timesplayed = -1

    for i,hand in pairs(G.GAME.hands) do
        if hand.played > timesplayed then
            name = i
            timesplayed = hand.played
        end
    end

    return name

end

function self_annihilate(card)
    -- this makes sense

    G.GAME.cry_banished_keys[card.config.center.key] = true
    card:quick_dissolve()
end

function random_suit()
    local n = {"Spades", "Hearts", "Clubs", "Diamonds"}
    return n[pseudorandom("valk_random_suit", 1, #n)]
end

function random_rank()
    local n = {"2","3","4","5","6","7","8","9","10","Jack","Queen","King","Ace"}
    return n[pseudorandom("valk_random_rank", 1, #n)]
end

function random_enhancement()
    local choices = {}
    for i,e in ipairs(G.P_CENTER_POOLS.Enhanced) do
        choices[#choices+1] = e.key
    end
    return choices[pseudorandom("valk_random_enhance", 1, #choices)]
end

function random_edition()
    local choices = {}
    for i,e in ipairs(G.P_CENTER_POOLS.Edition) do
        if e.key ~= "e_negative" then
            choices[#choices+1] = e.key
        end
    end
    return choices[pseudorandom("valk_random_edition", 1, #choices)]
end

function level_ascended_hands(amount, card)
    if not amount then
        amount = 1
    end
    local sunlevel = (G.GAME.sunlevel and G.GAME.sunlevel or 0) + amount
    G.GAME.sunlevel = (G.GAME.sunlevel or 0) + amount
	delay(0.4)
	update_hand_text(
		{ sound = "button", volume = 0.7, pitch = 0.8, delay = 0.3 },
		{ handname = localize("cry_asc_hands"), chips = "...", mult = "...", level = to_big(sunlevel) }
	)
	delay(1.0)
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0.2,
		func = function()
			play_sound("tarot1")
			ease_colour(G.C.UI_CHIPS, copy_table(G.C.GOLD), 0.1)
			ease_colour(G.C.UI_MULT, copy_table(G.C.GOLD), 0.1)
			Cryptid.pulse_flame(0.01, sunlevel)
            if card then card:juice_up(0.8, 0.5) end 
			
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				blockable = false,
				blocking = false,
				delay = 1.2,
				func = function()
					ease_colour(G.C.UI_CHIPS, G.C.BLUE, 1)
					ease_colour(G.C.UI_MULT, G.C.RED, 1)
					return true
				end,
			}))
			return true
		end,
	}))
	update_hand_text({ sound = "button", volume = 0.7, pitch = 0.9, delay = 0 }, { level = to_big(sunlevel + amount) })
	delay(2.6)
	G.GAME.sunnumber = G.GAME.sunnumber ~= nil and G.GAME.sunnumber + (0.05*amount) or (0.05*amount)
	update_hand_text(
		{ sound = "button", volume = 0.7, pitch = 1.1, delay = 0 },
		{ mult = 0, chips = 0, handname = "", level = "" }
	)
end

function math.map(v, imi, ima, omi, oma)

    return (v-imi) * (oma - omi) / (ima - imi) + omi

end

function mspl(amt)
    for i, hand in pairs(G.GAME.hands) do
        G.GAME.hands[i].l_chips = G.GAME.hands[i].l_chips * amt
        G.GAME.hands[i].l_mult = G.GAME.hands[i].l_mult * amt
    end
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

function table:vcontains(table, value)
    for i,j in ipairs(table) do
        if (j == value) then return true end
    end
    return false
end

function table:superset(t_a, t_b)
    local valid = true

    for i,j in ipairs(t_b) do
        valid = valid and table:vcontains(t_a,j)
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

function quick_card_speak(card, text, wait)
    card_eval_status_text(card, 'extra', nil, nil, nil, {message = text, delay = wait})
end

function pause_event(time)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
		timer = 'REAL',
        delay = time or 1,
        func = function()
           return true
        end
    }))
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

function corrupt_text(text, amount, available_chars)

    local chars = (available_chars or "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()-_=+[];:',.<>/?|")
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
	return "{X:dark_edition,C:white}^" .. txt .. "{}"
end

function expomult(txt)
	return "{X:dark_edition,C:white}^" .. txt .. "{}"
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
    -- very unsafe, however: this does allow for live updates
end

function run_max_num_test()
    local n = to_big(2)
    local ri = 1
    while ri < 1e9 do
        n = n:arrow(math.floor(ri),n)
        ri = ri * 11
        print("Safely got to " .. ri .. "-ation, with " .. number_format(n) .. "{" .. math.floor(ri) .. "}" .. number_format(n))
    end


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

function level_all_hands(source, amount, mul)
    if amount == nil then 
        amount = 1
    end

    if mul == nil then 
        mul = 0
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
    if mul ~= 0 then 
        text = "x"..(mul+1)
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

function quick_misprintize(card, val, growth, arrows)

    Cryptid.misprintize(card, {min = val, max = val}, nil, true, growth, arrows)

end

function qdvi(val, growth, arrows)

    for i,card in ipairs(G.jokers.cards) do 
        Cryptid.misprintize(card, {min = val, max = val}, nil, true, growth, arrows)
    end

end

function find_index(card, list)

    for i,c in ipairs(list) do
        if c == card then
            return i
        end
    end
    return false

end

function draw_to_hand(cardlist) 
    for i,card in ipairs(cardlist) do
        draw_card(card.area, G.hand, nil, nil, nil, card)
    end
end

function get_handtype(handtype)

    local a, b, c, d, e = G.FUNCS.get_poker_hand_info(G.deck.cards)

    local selected_hand = handtype

    local intentional_length = 0
    
    if not (G.GAME.hands[selected_hand]) then
        return false
    end

    for _,ca in ipairs(G.GAME.hands[selected_hand].example) do

        if ca[2] then
            intentional_length = intentional_length + 1
        end

    end

    if c[selected_hand] and #c[selected_hand] > 0 then
        local valid_cards = {}
        for i,card in ipairs(c[selected_hand][1]) do
            if i > intentional_length then
                break
            end
            table.insert(valid_cards, card)
            

        end
        return valid_cards
    else
        return false
    end

end

function do_while_flipped(cards, func) --mostly borrowed from entropy, thank you ruby <3
    if not Talisman.config_file.disable_anims then
        for i, _ in ipairs(cards) do
            local card = cards[i]
            if card then
                G.E_MANAGER:add_event(
                    Event(
                        {
                            trigger = "after",
                            delay = 0.1,
                            func = function()
                                if card.flip then
                                    card:flip()
                                end
                                return true
                            end
                        }
                    )
                )
            end
        end
    end
    for i, _ in ipairs(cards) do
        local card = cards[i]
        if card then
            G.E_MANAGER:add_event(
                Event(
                    {
                        trigger = "after",
                        delay = 0.15,
                        func = function()
                            func(card, cards, i)
                            return true
                        end
                    }
                )
            )
        end
    end
    if not Talisman.config_file.disable_anims then
        for i, _ in ipairs(cards) do
            local card = cards[i]
            if card then
                G.E_MANAGER:add_event(
                    Event(
                        {
                            trigger = "after",
                            delay = 0.1,
                            func = function()
                                if card.flip then
                                    card:flip()
                                end
                                return true
                            end
                        }
                    )
                )
            end
        end
    end
end