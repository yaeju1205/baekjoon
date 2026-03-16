local n = io.read("*n")

local function mul_for(x, y, r)
    for _=1, r do
        x = x * y
    end
    return x
end

local function floor_div(x, y)
    return math.floor(x / y)
end

local function get_scale(num)
    local scale = 0
    repeat
        scale = scale + 1
    until mul_for(1, 10, scale) > num
    return scale
end

local number_list = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }

local max_scale = get_scale(n)
local standard_scale = n
local usage_list = {}

for scale=max_scale - 1, 0, -1 do
    local unit = mul_for(1, 10, scale)
    local number = floor_div(standard_scale, unit)

    local all_value = scale == 0 and 0 or mul_for(1, 10, scale-1) * number
    
    -- 0xx(100) + 00x(10) + 000(1)
    -- 300 - 120 = 180 != 189

    for j=1, 10, 1 do
        number_list[j] = number_list[j] + all_value * scale
    end

    for j=1, number, 1 do
        number_list[j] = number_list[j] + unit
    end

    number_list[number + 1] = number_list[number + 1] + 1

    for j=1, #usage_list do
        number_list[usage_list[j] + 1] = number_list[usage_list[j] + 1] + number * unit
    end

    --- 3504
    --- 3xxx -> 300, 300, 300 << all value 1~2:1000, 3(self):1
    --- x5xx -> 50, 50 << all value 0~4:100, 5(self):1, 3:500(self)
    --- xx0x -> 0, 0 << all value 0:1
    --- xxx4 -> 0~3:1, 4(self):1, 3:4(self), 5:4(self), 2:4(self)

    standard_scale = standard_scale - number * unit
    table.insert(usage_list, number)
end

for i=1, max_scale do
    number_list[1] = number_list[1] - mul_for(1, 10, i-1)
end

print(table.concat(number_list, " "))
