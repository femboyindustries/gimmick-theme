return {
  Delay = 2,

  Init = function(self) end,
  overlay = gimmick.ActorScreen(function(self, ctx, scope)
    local doorAnim = gimmick.common.doors(ctx, scope,true,1)


    local batman = ctx:Quad()
    batman:stretchto(0,0,sw,sh)
    batman:diffuse(0,0,0,1)

    setDrawFunctionWithDT(self,function (dt)
      batman:Draw()
      doorAnim()
    end)

    --fucking christ please give us screen messages -jade
    --im also here -mayflower
    scope:offCommand()
  end),
  underlay = gimmick.ActorScreen(function(self, ctx)
  end),
  header = gimmick.ActorScreen(function(self, ctx)
  end),
  footer = gimmick.ActorScreen(function(self, ctx)
  end),
}