function superwin_game()
    if (not G.GAME.seeded and not G.GAME.challenge) or SMODS.config.seeded_unlocks then
        set_joker_win()
        set_deck_win()
        
        check_and_set_high_score('win_streak', G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt+1)
        check_and_set_high_score('current_streak', G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt+1)
        check_for_unlock({type = 'win_no_hand'})
        check_for_unlock({type = 'win_no'})
        check_for_unlock({type = 'win_custom'})
        check_for_unlock({type = 'win_deck'})
        check_for_unlock({type = 'win_stake'})
        check_for_unlock({type = 'win'})
        inc_career_stat('c_wins', 1)
    end

    set_profile_progress()

    if G.GAME.challenge then
        G.PROFILES[G.SETTINGS.profile].challenge_progress.completed[G.GAME.challenge] = true
        set_challenge_unlock()
        check_for_unlock({type = 'win_challenge'})
        G:save_settings()
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()
            for k, v in pairs(G.I.CARD) do
                v.sticker_run = nil
            end
            
            G.SETTINGS.paused = true

            G.FUNCS.overlay_menu{
                definition = create_UIBox_superwin(),
                config = {no_esc = true}
            }
            
            
            return true
        end)
    }))

    if (not G.GAME.seeded and not G.GAME.challenge) or SMODS.config.seeded_unlocks then
        G.PROFILES[G.SETTINGS.profile].stake = math.max(G.PROFILES[G.SETTINGS.profile].stake or 1, (G.GAME.stake or 1)+1)
    end
    G:save_progress()
    G.FILE_HANDLER.force = true
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()
            if not G.SETTINGS.paused then
                G.GAME.current_round.round_text = 'Endless Round '
                return true
            end
        end)
    }))
end

function create_UIBox_superwin()
  local show_lose_cta = false
  local eased_green = copy_table(G.C.GREEN)
  eased_green[4] = 0
  ease_value(eased_green, 4, 0.5, nil, nil, true)
  local t = create_UIBox_generic_options({ padding = 0, bg_colour = eased_green , colour = G.C.BLACK, outline_colour = G.C.EDITION, no_back = true, no_esc = true, contents = {
    {n=G.UIT.R, config={align = "cm"}, nodes={
      {n=G.UIT.O, config={object = DynaText({string = {"The end."}, colours = {G.C.EDITION},shadow = true, float = true, spacing = 10, rotate = true, scale = 1.5, pop_in = 0.4, maxw = 6.5})}},
    }},
    {n=G.UIT.R, config={align = "cm", padding = 0.15}, nodes={
      {n=G.UIT.C, config={align = "cm"}, nodes={
    {n=G.UIT.R, config={align = "cm", padding = 0.08}, nodes={
      create_UIBox_round_scores_row('hand'),
      create_UIBox_round_scores_row('poker_hand'),
    }},
    {n=G.UIT.R, config={align = "cm"}, nodes={
      {n=G.UIT.C, config={align = "cm", padding = 0.08}, nodes={
        create_UIBox_round_scores_row('cards_played', G.C.BLUE),
        create_UIBox_round_scores_row('cards_discarded', G.C.RED),
        create_UIBox_round_scores_row('cards_purchased', G.C.MONEY),
        create_UIBox_round_scores_row('times_rerolled', G.C.GREEN),
        -- create_UIBox_round_scores_row('new_collection', G.C.WHITE),
        create_UIBox_round_scores_row('seed', G.C.WHITE),
        UIBox_button({button = 'copy_seed', label = {localize('b_copy')}, colour = G.C.BLUE, scale = 0.3, minw = 2.3, minh = 0.4,}),
      }},
      {n=G.UIT.C, config={align = "tr", padding = 0.08}, nodes={
        -- create_UIBox_round_scores_row('furthest_ante', G.C.FILTER),
        create_UIBox_round_scores_row('furthest_round', G.C.FILTER),
        {n=G.UIT.R, config={align = "cm", minh = 0.1, minw = 0.1}, nodes={}},
        show_win_cta and UIBox_button({id = 'win_cta', button = 'show_main_cta', label = {localize('b_next')}, colour = G.C.GREEN, scale = 0.8, minw = 2.5, minh = 2.5, focus_args = {nav = 'wide', snap_to = true}}) or nil,
        not show_win_cta and UIBox_button({id = 'from_game_won', button = 'notify_then_setup_run', label = {localize('b_start_new_run')}, minw = 2.5, maxw = 2.5, minh = 1, focus_args = {nav = 'wide', snap_to = true}}) or nil,
        not show_win_cta and {n=G.UIT.R, config={align = "cm", minh = 0.1, minw = 0.1}, nodes={}} or nil,
        not show_win_cta and UIBox_button({button = 'go_to_menu', label = {localize('b_main_menu')}, minw = 2.5, maxw = 2.5, minh = 1, focus_args = {nav = 'wide'}}) or nil,
        {n=G.UIT.R, config={align = "cm", minw = rwidth}, nodes={{n=G.UIT.O, config={object = Cryptid.gameset_sprite()}}}},
      }}
    }},
    --     {n=G.UIT.R, config={align = "cm", padding = 0.08}, nodes={
    --       UIBox_button({button = 'exit_overlay_menu', label = {localize(G.GAME.TrueEndless and 'b_true_endless' or 'b_endless')}, minw = 6.5, maxw = 5, minh = 1.2, scale = 0.7, shadow = true, colour = G.C.BLUE, focus_args = {nav = 'wide', button = 'x',set_button_pip = true}}),
    -- }},
  }}
  }}
  }}) 
  t.nodes[1] = {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
      {n=G.UIT.C, config={align = "cm", padding = 2}, nodes={
        {n=G.UIT.O, config={padding = 0, id = 'jimbo_spot', object = Moveable(0,0,G.CARD_W*1.1, G.CARD_H*1.1)}},
      }},
      {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={t.nodes[1]}
    }}
  }
  --t.nodes[1].config.mid = true
  t.config.id = 'you_win_UI'
  return t
end