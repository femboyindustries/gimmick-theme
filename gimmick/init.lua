require 'gimmick.constants'
require 'gimmick.lib.util'
require 'gimmick.lib.draw'
require 'gimmick.iterfunction'
require 'gimmick.lib.color'
if not LITE then require 'gimmick.lib.easings' end

event = require 'gimmick.lib.event235'
inputs = require 'gimmick.lib.inputs'

require 'gimmick.screens'
actorgen = require 'gimmick.lib.actor235'

print('Gimmick bootstrapped!!! yippee!!')

if not LITE then
  -- MESSAGEMAN does not exist in the pre-loading stage
  MESSAGEMAN:Broadcast('GimmickLoad')
end