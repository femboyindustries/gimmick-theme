function drawBorders(actor, amp, passes)
  amp = amp or 1
  passes = passes or 1

  for x = -passes, passes do
    for y = -passes, passes do
      actor:xy2(x * amp, y * amp)
      actor:Draw()
    end
  end

  actor:xy2(0, 0)
end