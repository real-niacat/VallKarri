local self = get_first(G.deck.cards)

update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize('k_all_hands'),chips = '...', mult = '...', level=''})
G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
    play_sound('tarot1')
    self:juice_up(0.8, 0.5)
    G.TAROT_INTERRUPT_PULSE = true
    return true end 
}))

update_hand_text({delay = 0}, {mult = '+', StatusText = true})
G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
    play_sound('tarot1')
    self:juice_up(0.8, 0.5)
    return true end
}))
update_hand_text({delay = 0}, {chips = '+', StatusText = true})
G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
    play_sound('tarot1')
    self:juice_up(0.8, 0.5)
    G.TAROT_INTERRUPT_PULSE = nil
    return true end
}))
update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level='+1'})
delay(1.3)
for k, v in pairs(G.GAME.hands) do
    level_up_hand(self, k, true)
end
update_hand_text({delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})