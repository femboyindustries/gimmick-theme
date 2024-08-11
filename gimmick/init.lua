require 'gimmick.env'
require 'gimmick.lib.util'
require 'gimmick.constants'
require 'gimmick.lib.draw'
require 'gimmick.iterfunction'
require 'gimmick.lib.color'
if not LITE then require 'gimmick.lib.easings' end

local EventHandler = require 'gimmick.lib.event235'
-- global EventHandler instance
event = EventHandler.new('Global')

inputs = require 'gimmick.lib.inputs'
save = require 'gimmick.save'

require 'gimmick.screens'
actorgen = require 'gimmick.lib.actor235'

print('Gimmick bootstrapped!!! yippee!!')

if not LITE then
  -- MESSAGEMAN does not exist in the pre-loading stage
  MESSAGEMAN:Broadcast('GimmickLoad')
end

introduceEntropyIntoUniverse()