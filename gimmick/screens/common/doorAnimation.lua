---@param ctx Context
---@param scope Scope
---@param invertease boolean|nil
---@param screenType number|nil
function gimmick.common.doors(ctx, scope, invertease, screenType,OptionsPrompt)
    if not invertease then invertease = false end
    if not screenType then screenType = -1 end

    local isScreenPlayerOptions = (screenType == 0)
    local isScreenStage = (screenType == 1)

    --controls the "doors" that slide in when you enter a song
    local outActorsEase = nil
    if invertease then
        outActorsEase = scope.tick:aux(0)
    else
        outActorsEase = scope.tick:aux(1)
    end

    --moves the text on the doors
    local outTextEase = scope.tick:aux(0)
    local outTextEase2 = scope.tick:aux(0)

    --moves the stripes because texcoordvelocity doesnt work
    local stripeEase = scope.tick:aux(0)
    local shouldDoor = true

    local openAux = scope.tick:aux(0)
    openAux:ease(0, 0.5, outExpo, 1)
    scope.event:on('off', function()
        if not shouldDoor then
            return
        end
        openAux:ease(0, 0.6, inBack, 0)

        if invertease then
            outActorsEase:ease(0, 1, outQuart, 1)
        else
            outActorsEase:ease(0, 0.6, outQuart, 0)
        end

        outTextEase:ease(0, 2, outQuart, 0.5)
        outTextEase2:ease(0, 2, function(t)
            if t < 0.5 then
                return 0
            else
                return inExpo(t * 2 - 1)
            end
        end, 1)
        stripeEase:ease(0, 2, outQuart, 32)
    end)

    scope.event:on('press', function(pn, btn)
        if btn == 'Back' then
            shouldDoor = false
        end
    end)

    if isScreenPlayerOptions then
        _QUIPS_INDEX = 1
    end

    ---Actors for the out animation, how woke!
    local outActors = ctx:ActorFrame()
    ---outTop
    local outT = ctx:ActorFrame()
    ---outBottom
    local outB = ctx:ActorFrame()
    ctx:addChild(outActors, outT)
    ctx:addChild(outActors, outB)

    local outTbg = ctx:Quad()
    ctx:addChild(outT, outTbg)

    local outBbg = ctx:Quad()
    ctx:addChild(outB, outBbg)

    local outTline = ctx:Quad()
    ctx:addChild(outT, outTline)

    local outBline = ctx:Quad()
    ctx:addChild(outB, outBline)

    local outTtext = ctx:BitmapText(FONTS.sans_serif)
    if _QUIPS_INDEX ~= 1 and not isScreenStage then
        outTtext:settext("PRESS START")
    else
        outTtext:settext(_QUIPS[_QUIPS_INDEX][1])
    end
    ctx:addChild(outT, outTtext)

    local outQuip1 = ctx:BitmapText(FONTS.sans_serif)
    outQuip1:settext(_QUIPS[_QUIPS_INDEX][1])
    ctx:addChild(outT, outQuip1)

    local outQuip2 = ctx:BitmapText(FONTS.sans_serif)
    outQuip2:settext(_QUIPS[_QUIPS_INDEX][2])
    ctx:addChild(outB, outQuip2)

    local outBtext = ctx:BitmapText(FONTS.sans_serif)
    if _QUIPS_INDEX ~= 1 and not isScreenStage then
        outBtext:settext("FOR OPTIONS")
    else
        outBtext:settext(_QUIPS[_QUIPS_INDEX][2])
    end
    ctx:addChild(outB, outBtext)

    local outTstripes = ctx:Sprite('Graphics/stripes.png')
    ctx:addChild(outT, outTstripes)

    local outBstripes = ctx:Sprite('Graphics/stripes.png')
    ctx:addChild(outB, outBstripes)

    local stripes_color = hex('#FFF')

    setDrawFunctionWithDT(outT, function(dt)
        local cur_steps = GAMESTATE:GetCurrentSteps(0)
        if cur_steps and cur_steps:GetDifficulty() then
            stripes_color = DIFFICULTIES[cur_steps:GetDifficulty()].color
        end
        outTbg:diffuse(hex("#262626"):unpack())
        outTbg:stretchto(0, 0, sw * 2, sh)
        outTbg:Draw()

        outTline:stretchto(0, sh - 2, sw * 2, sh)
        outTline:diffuse(hex("#6e6e6e"):unpack())
        outTline:Draw()

        outTstripes:diffuse(stripes_color:unpack())
        outTstripes:stretchto(0, 0, sw * 2, 16)
        outTstripes:valign(1)
        outTstripes:x(stripeEase.value + sw)
        outTstripes:y(sh - 6)
        outTstripes:customtexturerect(0, 0, 32, 1)
        outTstripes:skewto(2)
        outTstripes:Draw()

        outTtext:zoom(1.5)
        outTtext:shadowlength(0)
        outTtext:xy((scx * 1.2) + (scx * 0.1 * outTextEase.value), sh - 55)
        outTtext:x2(outTextEase2.value * sw)
        outTtext:Draw()

        outQuip1:zoom(1.5)
        outQuip1:shadowlength(0)
        outQuip1:xy((scx * 1.2) + (scx * 0.1 * outTextEase.value), sh - 55)
        outQuip1:x2((outTextEase2.value * sw) - sw)
        outQuip1:Draw()
    end)
    setDrawFunctionWithDT(outB, function(dt)
        outBbg:diffuse(hex("#262626"):unpack())
        outBbg:stretchto(0, 0, sw * 2, sh)
        outBbg:Draw()

        outBline:stretchto(0, 0, sw * 2, 2)
        outBline:diffuse(hex("#6e6e6e"):unpack())
        outBline:Draw()

        outBstripes:diffuse(stripes_color:unpack())
        outBstripes:stretchto(0, 0, sw * 2, 16)
        outBstripes:valign(0)
        outBstripes:y(6)
        outBstripes:x((stripeEase.value * -1) + sw)
        outBstripes:customtexturerect(0, 0, 32, 1)
        outBstripes:skewto(2)
        outBstripes:fadebottom(0)
        outBstripes:Draw()

        outBtext:zoom(1.5)
        outBtext:shadowlength(0)
        outBtext:xy(sw - (scx * 0.1 * outTextEase.value), 60)
        outBtext:x2(-outTextEase2.value * sw)
        outBtext:Draw()

        outQuip2:zoom(1.5)
        outQuip2:shadowlength(0)
        outQuip2:xy(sw - (scx * 0.1 * outTextEase.value), 60)
        outQuip2:x2((-outTextEase2.value * sw) + sw)
        outQuip2:Draw()
    end)

    setDrawFunctionWithDT(outActors, function(dt)
        outT:rotationz(-20)
        outT:xy(-scx * 0.6 - sw * outActorsEase.value, -sh * outActorsEase.value)
        outT:Draw()

        outB:rotationz(-20)
        outB:xy(-scx * 0.7 + sw * outActorsEase.value, scy * 2.193 + sh * outActorsEase.value)
        outB:Draw()
    end)

    return function()
        outActors:Draw()
    end,function (str,str2)
        outTtext:settext(str)
        outQuip1:settext(str2)
    end,function (str,str2)
        outBtext:settext(str)
        outQuip2:settext(str2)
    end
end