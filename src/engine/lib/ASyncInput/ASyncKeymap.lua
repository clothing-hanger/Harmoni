local keymap = {}

keymap[0x20] = "space"
keymap[0x25] = "left"
keymap[0x26] = "up"
keymap[0x27] = "right"
keymap[0x28] = "down"

keymap[0x0D] = "return"

for i = 0x41, 0x5A do
    keymap[i] = string.char(i + 32)
end

for i = 0x30, 0x39 do
    keymap[i] = string.char(i)
end

for i = 0x60, 0x69 do
    keymap[i] = "kp" .. (i - 0x60)
end

keymap[0xA0] = "lshift"
keymap[0xA1] = "rshift"
keymap[0xA2] = "lctrl"
keymap[0xA3] = "rctrl"

keymap[0xBA] = ";"
keymap[0xBB] = "="
keymap[0xBC] = ","
keymap[0xBD] = "-"
keymap[0xBE] = "."
keymap[0xBF] = "/"
keymap[0xC0] = "`"
keymap[0xDB] = "["
keymap[0xDC] = "\\"
keymap[0xDD] = "]"
keymap[0xDE] = "'"

return keymap
