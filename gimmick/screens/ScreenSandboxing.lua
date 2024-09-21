barlib = require 'gimmick.bar'
local easeable = require 'gimmick.lib.easable'
return {
  Init = function(self) Trace('theme.com') end,
  overlay = gimmick.ActorScreen(function(self, ctx)
    
    --MAYFLOWER's ERROR DO NOT STEAL
    error({},-1)

  end),
  underlay = gimmick.ActorScreen(function(self, ctx)
  end),
  header = gimmick.ActorScreen(function(self, ctx)
  end),
  footer = gimmick.ActorScreen(function(self, ctx)
  end),
}