local file = io.open('pokemon.txt')

--https://stackoverflow.com/questions/53210428/lua-count-repeating-characters-in-string
function repeats(s,c)
    local _,n = s:gsub(c,"")
    return n
end

function loadLine(s)
    local n=0
    s=s..'\t'
	local v = s:gmatch("(.-)\t")
	if repeats(s,'\t') < 15 then return end
	
	local _ = v() --Pokemon ID
	local name = v()
	_ = v() --name comes twice
	local item = v() --item is seperated by space, lul

	local at1, at2, at3, at4 = v(), v(), v(), v()
	local nature = v()
	local ev = {}
	ev.hp  = v()
	ev.atk = v()
	ev.def = v()
	ev.spa = v()
	ev.spd = v()
	ev.spe = v()
	
	ev.ev = ""
	for k,v in pairs(ev) do
		if k ~= "ev" and v ~= '- ' and v ~= '-' then
		--print(k, v, ev[k])
		if k == 'spe' then
			ev.ev = ev.ev .. v .. ' ' .. k .. ' / '
		else
			ev.ev = ev.ev .. v .. k .. ' / '
		end
		end
	end
	--print()

	print(string.format("%s @ %s",name, item:sub(1,#item / 2)))
	print("Ability: ")
	print(string.format("EVs: %s", ev.ev:sub(1, #ev - 3)))
	print(string.format("%s Nature", nature:sub(1, #nature - 1)))
	print(string.format("- %s", at1))
	print(string.format("- %s", at2))
	print(string.format("- %s", at3))
	print(string.format("- %s", at4))
	print("")
--]]
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
for k in file:lines() do
	loadLine(k)
end

file:close()
