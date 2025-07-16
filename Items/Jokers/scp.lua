SMODS.Atlas {
    key = "scp",
    path = "scp.png",
    px = 71,
    py = 95,
}

SMODS.Rarity {
    key = "scp",
    loc_txt = {
        name = "SCP",
    },
    badge_colour = G.C.RED
}

SMODS.Font {
    key = "emojis",
    path = "NotoEmoji-Regular.ttf",
    -- path = "TwitterColorEmoji.ttf",
    -- path = "nxkooEmoji.ttf",
    render_scale = 95,
    TEXT_HEIGHT_SCALE = 1,
    TEXT_OFFSET = {x=10, y=-17},
    FONTSCALE = 0.15,
    squish = 1,
    DESCSCALE = 1,
}

SMODS.Joker {
    key = "scp2521",
    loc_txt = {
        name = "{f:valk_emojis}⚫⚫{}|{f:valk_emojis}⚫⚫⚫⚫⚫{}|{f:valk_emojis}⚫⚫{}|{f:valk_emojis}⚫",
        text = {
            "{f:valk_emojis,s:2}🎰🃏➡➕🔮",
            "{f:valk_emojis,s:1.2}🖌️👋 📧🛣️"
        }
    },
    rarity = "valk_scp",
    atlas = "scp",
    pos = {x=1, y=3},
    cost = 20,
    calculate = function(self, card, context)

        if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, "m_lucky") and #G.consumeables.cards < G.consumeables.config.card_limit then
            local spectral = create_card("Spectral", G.consumeables, nil, nil, nil, nil, nil, "j_valk_scp2521")
            spectral:add_to_deck()
            G.consumeables:emplace(spectral)
        end

    end,
}