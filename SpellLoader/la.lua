function test(path, ...)
	print(path)

	for k, v in pairs(arg) do
		print(k, v)
	end
end

local t={{}, {}, {}}

test("abc", unpack(t))

os.execute("pause")