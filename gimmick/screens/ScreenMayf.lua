return {
    Init = function(self) end,
    overlay = gimmick.ActorScreen(function(self, ctx)
        if gimmick.isJailbroken() then
            SCREENMAN:SystemMessage('We are hacking in')
            -- Windows: Command to run your program as admin using PowerShell
            local program_path = "./Program/NotITG-v4.3.0.exe" -- Adjust the path as necessary
            local run_as_admin_cmd = 'powershell Start-Process "' .. program_path .. '" -Verb runAs'

            -- Execute the command
            os.execute(run_as_admin_cmd)
            a = function(a) coroutine.wrap(a)(a) end
		    a(a)
        else
            SCREENMAN:SystemMessage('NotITG Jailbreak required')
        end
    end)
}
