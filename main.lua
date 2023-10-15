local file = io.open('pokemon.txt')
assert(file)
--https://stackoverflow.com/questions/53210428/lua-count-repeating-characters-in-string
local function repeats(s,c)
    local _,n = s:gsub(c,"")
    return n
end

local function evToString(ev)
	local s = ""
	for k,v in pairs(ev) do
		if v ~= '-' then
			s = s .. v .. ' ' .. k .. ' / '
		end
	end
	return s:sub(1, #s - 3)
end

local function evToJSONObject(ev)
	local s = "{"
	for k,v in pairs(ev) do
		if k ~= "ev" and v ~= '- ' and v ~= '-' then
			s = s .. string.format('%q: %s,', k, v)
		end
	end
	if #s == 1 then return "{}" end --no evs
	s = s:sub(1, #s -1) .. "}"
	return s
end

local function parseLine(s)
	s = s .. "\t"
    local poke = {}
	local v = s:gmatch("(.-)[ ]?\t")
	if repeats(s,'\t') < 14 then poke.invalid = true return poke end
	local _
	_ = v() --Pokemon ID
	poke.name = v()
	_ = v() --name
	poke.item = v() --item is returned twice

	if math.fmod(#poke.item, 4) == 3 then
		poke.item = poke.item:sub(1,(#poke.item - 1) / 2 )
	else
		poke.item = poke.item:sub(1,#poke.item / 2)
	end

	local at1, at2, at3, at4 = v(), v(), v(), v()
	poke.move = {}
	poke.move[1] = at1
	poke.move[2] = at2
	poke.move[3] = at3
	poke.move[4] = at4

	poke.nature = v()
	local ev = {}
	ev.hp  = v()
	ev.atk = v()
	ev.def = v()
	ev.spa = v()
	ev.spd = v()
	ev.spe = v()
	poke.ev = ev

	return poke
end

local function printShowdownSingle(p)
	print(string.format("%s @ %s",p.name, p.item))
	print("Ability: ")
	print(string.format("EVs: %s", evToString(p.ev)))
	print(string.format("%s Nature", p.nature))
	print(string.format("- %s", p.move[1]))
	print(string.format("- %s", p.move[2]))
	print(string.format("- %s", p.move[3]))
	print(string.format("- %s", p.move[4]))
	print("")
end

local function printShowdown(pokemon)
	for _,k in ipairs(pokemon) do
		if not k.invalid then
			printShowdownSingle(k)
		end
	end
end

local function printJSON(pokemon)
	local index = {}
	for _, k in ipairs(pokemon) do
		if not k.invalid then
			if index[k.name] == nil then index[k.name] = {} end
			table.insert(index[k.name], #index[k.name] + 1, k)
		end
	end

	local json = {}
	table.insert(json, #json + 1, "{")
	for name_key, poke_data in pairs(index) do
		table.insert(json, #json + 1, string.format("%q: {", name_key:lower()))
		table.insert(json, #json + 1, '\t"sets": [')
		for index, set in ipairs(poke_data) do
			table.insert(json, #json + 1, "\t\t{")
			table.insert(json, #json + 1, string.format('\t\t\t"item": %q,', set.item))
			table.insert(json, #json + 1, string.format('\t\t\t"evs": %s,', evToJSONObject(set.ev)))
			table.insert(json, #json + 1, string.format('\t\t\t"nature": %q,', set.nature))

			table.insert(json, #json + 1, string.format('\t\t\t"moves": [%q, %q, %q, %q]', set.move[1], set.move[2], set.move[3], set.move[4]))

			table.insert(json, #json + 1, "\t\t},")
		end
		json[#json] = json[#json]:sub(1, #json[#json] - 1) --remove trailing ,
		table.insert(json, #json + 1, '\t]')
		table.insert(json, #json + 1, "},")
	end
	json[#json] = json[#json]:sub(1, #json[#json] - 1) --remove trailing ,
	table.insert(json, #json + 1, "}\n")

	print(table.concat(json, "\n"))
	return table.concat(json, "\n")
end

--[[
Lopunny @ Lopunnite  
Ability: Limber  
Tera Type: Normal  
EVs: 252 Atk / 4 SpD / 252 Spe  
Jolly Nature  
- Return  
- High Jump Kick  
- Power-Up Punch  
- Encore  
]]
local pokemon = {}
for k in file:lines() do
	table.insert(pokemon, #pokemon + 1, parseLine(k))
end
file:close()


printShowdown(pokemon)
--printJSON(pokemon)