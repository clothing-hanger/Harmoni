local transitions = {
    slideLeft = "states/transitions/slideLeft/slideLeft.lua",
    slideRight = "states/transitions/slideRight/slideRight.lua",
    slideUp = "states/transitions/slideUp/slideUp.lua",
    slideDown = "states/transitions/slideDown/slideDown.lua",
    fade = "states/transitions/fade/fade.lua",
    curtains = "states/transitions/curtains/curtains.lua",
    circleWipe = "states/transitions/circleWipe/circleWipe.lua",
    checkerboardFade = "states/transitions/checkerboardFade/checkerboardFade.lua",
    waveDissolve = "states/transitions/waveDissolve/waveDissolve.lua"
}

for name, path in pairs(transitions) do
    State.addTransition(name, path)
end