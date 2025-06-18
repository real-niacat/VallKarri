function create_UIBox_metaprog()
    return {
        n = G.UIT.ROOT,
        config = { align = "cm", padding = 0.03, colour = G.C.UI.TRANSPARENT_DARK },
        nodes = {
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.05, colour = { 0.215, 0.258, 0.267, 1 }, r = 0.1 },
                nodes = {
                    {
                        n = G.UIT.R,
                        config = { align = "cm", colour = G.C.DYN_UI.BOSS_DARK, r = 0.1, minh = 0.25, padding = 0.08 },
                        nodes = {
                            { n = G.UIT.R, config = { align = "cm", minh = 0.3 }, nodes = {} },
                            {
                                n = G.UIT.R,
                                config = { align = "cm", id = 'row_xp', minw = 10, minh = 0.25 },
                                nodes = {
                                    {
                                        n = G.UIT.R,
                                        config = { w = 3.65, h = 0, id = 'row_xp_bottom' },
                                        nodes = {
                                            {n=G.UIT.C, config={align = "cm", padding = 0.05, r = 0.1, minw = 8}, nodes={}}
                                        },
                                        progress_bar = {
                                            max = G.PROFILES[G.SETTINGS.profile].valk_max_xp,
                                            ref_table = G.PROFILES[G.SETTINGS.profile],
                                            ref_value = 'valk_cur_xp',
                                            empty_col = G.C.BLACK,
                                            filled_col = G.C.BLUE
                                        }
                                    },
                                }
                            },
                        }
                    }
                }
            }
        }
    }
end
local fakestart = Game.start_run
function Game:start_run(args)
    fakestart(self, args)

    if not G.PROFILES[G.SETTINGS.profile].valk_max_xp then
        G.PROFILES[G.SETTINGS.profile].valk_max_xp = 100
    end

    if not G.PROFILES[G.SETTINGS.profile].valk_cur_xp then
        G.PROFILES[G.SETTINGS.profile].valk_cur_xp = 0
    end

    if not G.PROFILES[G.SETTINGS.profile].valk_cur_lvl then
        G.PROFILES[G.SETTINGS.profile].valk_cur_lvl = 1
    end

    self.HUD_META = UIBox {
        definition = create_UIBox_metaprog(),
        config = { align = ('cli'), offset = { x = 4.55, y = -6 }, major = G.ROOM_ATTACH }
    }
end
