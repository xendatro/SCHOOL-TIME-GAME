local _math = math
local math = {}
setmetatable(math, {
	__index = _math
})

function math.nround(n, e)
		local temp = n / math.pow(10, e)
		temp = math.round(temp)
		local l = tostring(temp):len()
		temp = temp * math.pow(10, e)
		return tonumber(tostring(temp):sub(1, l))
end


return math