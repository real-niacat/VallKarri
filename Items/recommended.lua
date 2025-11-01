-- please stop reading this code 
-- please stop reading this code 
-- please stop reading this code 
-- please stop reading this code 
-- please stop reading this code 
-- please stop reading this code 
-- please stop reading this code 
-- please stop reading this code 
-- please stop reading this code 
-- please stop reading this code 
-- please stop reading this code 
-- please stop reading this code 
-- please stop reading this code 
-- please stop reading this code 
-- please stop reading this code 
-- please stop reading this code 

local colours = {
    talisman = G.C.GOLD,
    text = G.C.UI.TEXT_LIGHT,
    red = G.C.MULT,
    blue = G.C.CHIPS,
    spec = G.C.SECONDARY_SET.Spectral
}
local text_scale = 0.34
local scale = 0.4
function vallkarri.recomm_ui_def()
    local ui = {
        n = G.UIT.ROOT,
        config = { align = "cm", minh = G.ROOM.T.h * scale, minw = G.ROOM.T.w * scale, maxw = G.ROOM.T.w * scale * 1.6, padding = 0.0, r = 0.1, colour = G.C.GREY },
        nodes = {
            {
                n = G.UIT.C,
                config = {},
                nodes = {
                    {
                        n = G.UIT.R,
                        config = { align = "cl", minw = 3, padding = 0.1 },
                        nodes = {
                            { n = G.UIT.R, config = {}, nodes = { { n = G.UIT.T, config = { text = "Talisman", colour = colours.talisman, scale = text_scale * 2, shadow = true, align = "tm" } } } },
                            {
                                n = G.UIT.C,
                                config = {},
                                nodes = {
                                    { n = G.UIT.R, config = {}, nodes = { { n = G.UIT.T, config = { text = "Talisman is a mod which increases the number cap from e308 to practically infinite!", colour = colours.text, scale = text_scale*0.8, align = "tm" } } } },
                                    { n = G.UIT.R, config = {}, nodes = { { n = G.UIT.T, config = { text = "It is not required, but recommended for VallKarri", colour = colours.text, scale = text_scale*0.8, align = "tm" } } } },
                                }
                            },
                            { n = G.UIT.C, config = {button = "vallkarri_open_talisman_download", padding = 0.1, colour = colours.red, minw = 1.5, minh = 0.6, r = 0.05, align = "cm"}, nodes = {
                                { n = G.UIT.T, config = { text = "Download", colour = colours.text, scale = text_scale * 1.25, shadow = true, } }
                            } },

                        }
                    },
                    {
                        n = G.UIT.R,
                        config = { minh = 0.5 },
                    },
                    {
                        n = G.UIT.R,
                        config = { align = "cl", minw = 3, padding = 0.1 },
                        nodes = {
                            { n = G.UIT.R, config = {}, nodes = { { n = G.UIT.T, config = { text = "CryptLib", colour = colours.blue, scale = text_scale * 2, shadow = true, align = "tm" } } } },
                            {
                                n = G.UIT.C,
                                config = {},
                                nodes = {
                                    { n = G.UIT.R, config = {}, nodes = { { n = G.UIT.T, config = { text = "CryptLib is a library mod which provides many useful functions that VallKarri needs", colour = colours.text, scale = text_scale*0.8, align = "tm" } } } },
                                    { n = G.UIT.R, config = {}, nodes = { { n = G.UIT.T, config = { text = "It is required, but can be replaced by Cryptid", colour = colours.text, scale = text_scale*0.8, align = "tm" } } } },
                                }
                            },
                            { n = G.UIT.C, config = {button = "vallkarri_open_cryptlib_download", padding = 0.1, colour = colours.red, minw = 1.5, minh = 0.6, r = 0.05, align = "cm"}, nodes = {
                                { n = G.UIT.T, config = { text = "Download", colour = colours.text, scale = text_scale * 1.25, shadow = true, } }
                            } },

                        }
                    },
                    {
                        n = G.UIT.R,
                        config = { minh = 0.5 },
                    },
                    {
                        n = G.UIT.R,
                        config = { align = "cl", minw = 3, padding = 0.1 },
                        nodes = {
                            { n = G.UIT.R, config = {}, nodes = { { n = G.UIT.T, config = { text = "Cryptid", colour = colours.spec, scale = text_scale * 2, shadow = true, align = "tm" } } } },
                            {
                                n = G.UIT.C,
                                config = {},
                                nodes = {
                                    { n = G.UIT.R, config = {}, nodes = { { n = G.UIT.T, config = { text = "Cryptid is a content mod which expands on a large majority of the game", colour = colours.text, scale = text_scale*0.8, align = "tm" } } } },
                                    { n = G.UIT.R, config = {}, nodes = { { n = G.UIT.T, config = { text = "It is recommended you install CryptLib for VallKarri", colour = colours.text, scale = text_scale*0.8, align = "tm" } } } },
                                }
                            },
                            { n = G.UIT.C, config = {button = "vallkarri_open_cryptid_download", padding = 0.1, colour = colours.red, minw = 1.5, minh = 0.6, r = 0.05, align = "cm"}, nodes = {
                                { n = G.UIT.T, config = { text = "Download", colour = colours.text, scale = text_scale * 1.25, shadow = true, } }
                            } },

                        }
                    },
                    
                }
            }

        }
    }

    return ui
end
-- a

function G.FUNCS.vallkarri_open_talisman_download()
    love.system.openURL("https://github.com/SpectralPack/Talisman")
end

function G.FUNCS.vallkarri_open_cryptlib_download()
    love.system.openURL("https://github.com/SpectralPack/Cryptlib")
end

function G.FUNCS.vallkarri_open_cryptid_download()
    love.system.openURL("https://github.com/SpectralPack/Cryptid")
end

-- return vallkarri.recomm_ui_def()