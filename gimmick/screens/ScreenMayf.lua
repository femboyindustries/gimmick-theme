return {
    Init = function(self) Trace('Hi guys') end,
    overlay = gimmick.ActorScreen(function(self, ctx)
        local logo = ctx:Sprite('Graphics/NotITG')
        logo:xy(scx, scy - 50)

        self:SetDrawFunction(function() logo:Draw() end)
    end)
}
