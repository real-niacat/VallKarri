eval dp.hovered.click = function(self)
    do_while_flipped({self}, function(c)
        if self.config.center.tau then
            self.ability.base = self.config.center_key
            self:set_ability(self.config.center.tau)
        else
            self:set_ability(self.ability.base)
        end
    end)
end