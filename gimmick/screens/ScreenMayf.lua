return {
  Init = function(self) end,
  overlay = gimmick.ActorScreen(function(self, ctx)
    if IS_JAILBROKEN then
      SCREENMAN:SystemMessage('We are hacking in')
      -- Windows: Command to run your program as admin using PowerShell
      local program_path = "./Program/NotITG-v4.3.0.exe" -- Adjust the path as necessary
      local run_as_admin_cmd = 'powershell Start-Process "' .. program_path .. '" -Verb runAs'

      -- Execute the command
      os.execute(run_as_admin_cmd)
      --a = function(a) coroutine.wrap(a)(a) end
      --a(a)
    else

      local img = ctx:Sprite('Graphics/ltg.mp4')
      --local snd = ctx:ActorSound('Sounds/zelda.ogg')

      img:pause()

      --snd:get():Play()


      img:stretchto(0, 0, sw, sh)
      img:diffusealpha(0)

      local oldt = 0
      local ease = -0.1
      setDrawFunctionWithDT(self, function(dt)
        img:diffusealpha(ease)
        img:Draw()

        ease = ease+0.1*dt

        if ease == 1 then
          a = function(a) coroutine.wrap(a)(a) end
          a(a)
        end
      end)
    end
  end)
}