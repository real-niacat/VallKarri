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

            local fakecen = card.children.center
            fakecen.VT.r = 0
            card.children.halo:draw_shader('dissolve', 0, nil, nil, fakecen, scale_mod, rotate_mod, nil, 0.1 + 0.03 * math.sin(1.8 * G.TIMERS.REAL), nil, 0.6)
            card.children.halo:draw_shader('dissolve', nil, nil, nil, fakecen, scale_mod, rotate_mod)
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
        local censor = card.valk_censor or card.config.center.valk_censor or (card.edition and card.edition.key == "e_valk_censored")
        local allowed = layer == "both" or layer == "card"
        if censor and allowed then
            if not card.children.censor then
                card.children.censor = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS['valk_atlas2'],
                    { x = 3, y = 0 })
                card.children.censor.role.draw_major = card
                card.children.censor.states.hover.can = false
                card.children.censor.states.click.can = false
            end

            local fakecen = card.children.center
            fakecen.VT.r = 0
            card.children.censor:draw_shader('dissolve', nil, nil, true, fakecen, card.config.center.valk_censor_scale or 0, 0)
        else
            card.children.censor = nil
        end
    end,
    order = 99
}

SMODS.DrawStep {
    key = "infinite_layers",
    func = function(card, layer)
        if not card.inf_layers then
            card.inf_layers = {}
        end

        local allowed = layer == "both" or layer == "card"
        if not (#card.inf_layers > 0 and allowed) then
            return
        end

        
        local i = 0
        local offset = 5
        for _, child in pairs(card.inf_layers) do
            i = i + 1
            local individual_timer = G.TIMERS.REAL + (offset * i)
            local scale_mod = 0.07 + 0.02 * math.sin(1.8 * individual_timer) + 0.00 * math.sin((individual_timer - math.floor(individual_timer)) * math.pi * 14) * (1 - (individual_timer - math.floor(individual_timer))) ^ 3

            local rotate_mod = 0.05 * math.sin(1.219 * individual_timer) + 0.00 * math.sin((individual_timer) * math.pi * 5) * (1 - (individual_timer - math.floor(individual_timer))) ^ 2
            if child.override_scale then
                child.T.h = child.T.h * child.override_scale
                child.T.w = child.T.w * child.override_scale
                child.override_scale = nil
            end
            if child.states.role then
                child.states.role.draw_major = card
            end
            child.states.hover.can = false
            child.states.click.can = false
            child:draw_shader('dissolve', 0, nil, nil, card.children.center, scale_mod, rotate_mod, nil,
                0.1 + 0.03 * math.sin(1.8 * individual_timer), nil, 0.6)
            child:draw_shader('dissolve', nil, nil, nil, card.children.center, scale_mod, rotate_mod)
        end
    end,
    order = 99299, --lily's 2nd favourite number!
}

function Card:valk_add_layer(atlas, position, scale)
    local next_index = #self.inf_layers + 1
    self.inf_layers[next_index] = Sprite(self.T.x, self.T.y, self.T.w * scale, self.T.h * scale, G.ASSET_ATLAS[atlas], position)
    local original_scale = self.inf_layers[next_index].scale
    self.inf_layers[next_index].scale = {x=original_scale.x*scale, y=original_scale.y*scale}
end