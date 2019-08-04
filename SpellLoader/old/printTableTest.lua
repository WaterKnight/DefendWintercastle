require "tableLib"

local t = {}

t[1] = 123
t[2] = {}
t[2][1] = "abc"
t[2][2] = "def"
t[2][3] = {}
t[2][3][1] = true
t[2][3][2] = false
t[3] = 234

printTable(t)