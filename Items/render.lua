SMODS.draw_ignore_keys["halo"] = true

SMODS.DrawStep {
    key = "lordly",
    func = function(card, layer)
        local draw_halo = (card.edition and card.edition.key == "e_valk_lordly") or card.draw_halo or
        (card.config and card.config.center and card.config.center.has_halo)
        local allowed = layer == "both" or layer == "card"
        if draw_halo and allowed then
            if not card.children.halo then
                card.children.halo = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS['valk_main'],
                    { x = 2, y = 2 })
                card.children.halo.role.draw_major = card
                card.children.halo.states.hover.can = false
                card.children.halo.states.click.can = false
            end

            local scale_mod = 0.07 + 0.02 * math.sin(1.8 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL)) * math.pi * 14) *
                (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 3

            local etimer = G.TIMERS.REAL * 2
            local rotate_mod = 0.05 * math.sin(1.219 * etimer) +
                0.00 * math.sin((etimer) * math.pi * 5) * (1 - (etimer - math.floor(etimer))) ^ 2

            scale_mod = scale_mod * 1.15


            card.children.halo:draw_shader('dissolve', 0, nil, nil, card.children.center, scale_mod, rotate_mod, nil,
                0.1 + 0.03 * math.sin(1.8 * G.TIMERS.REAL), nil, 0.6)
            card.children.halo:draw_shader('dissolve', nil, nil, nil, card.children.center, scale_mod, rotate_mod)
        else
            card.children.halo = nil
        end
    end,
    order = 992999, --lily's favourite number!
}

SMODS.draw_ignore_keys["censor"] = true

SMODS.DrawStep {
    key = "censorship",
    func = function(card, layer)
        local censor = card.valk_censor or card.config.center.valk_censor
        local allowed = layer == "both" or layer == "card"
        if censor and allowed then
            if not card.children.censor then
                card.children.censor = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS['valk_atlas2'],
                    { x = 3, y = 0 })
                card.children.censor.role.draw_major = card
                card.children.censor.states.hover.can = false
                card.children.censor.states.click.can = false
            end
            card.children.censor:draw_shader('dissolve', nil, nil, true, card.config.center, card.config.center.valk_censor_scale or 0, 0)
        else
            card.children.censor = nil
        end
    end,
    order = 99
}
