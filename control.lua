require("utils")
function getEntities(position,name,surface) return surface.find_entity(name,{position.x+0.5,position.y+0.5}) end
function boundingBox(startingPoint,sealingEntity,surface)
	local toLookAt={startingPoint}
	lookedAt={}
	while not ((#toLookAt)==0) do
		local looking=table.remove(toLookAt)
		if lookedAt[positionHash(looking)]==nil then
			lookedAt[positionHash(looking)]=true
			if not (getEntities({x=looking.x,y=looking.y+1},sealingEntity,surface)==nil) then table.insert(toLookAt,{x=looking.x,y=looking.y+1}) end-- use .find_entity
			if not (getEntities({x=looking.x,y=looking.y-1},sealingEntity,surface)==nil) then table.insert(toLookAt,{x=looking.x,y=looking.y-1})  end
			if not (getEntities({x=looking.x+1,y=looking.y},sealingEntity,surface)==nil) then table.insert(toLookAt,{x=looking.x+1,y=looking.y})end
			if not (getEntities({x=looking.x-1,y=looking.y},sealingEntity,surface)==nil) then table.insert(toLookAt,{x=looking.x-1,y=looking.y}) end
		end
	end
	--for val,_ in pairs(lookedAt) do game.print(val) end
	return lookedAt
end


DEBUG=false


function positionHash(position) return position.x*10000000+position.y end--return position.x..","..position.y end
function normPos(pos) return {x=math.floor(pos.x),y=math.floor(pos.y)} end
function mearge(tableA,tableB) for _,val in pairs(tableA) do tableB[_]=val end end -- mearges tableA into tableB

function checkForSeal(startingPoint,sealingEntities,surface)
	local blocks={}
	for _,sealingEntity in pairs(sealingEntities) do for _,sealer in pairs(surface.find_entities_filtered{name=sealingEntity}) do blocks[positionHash(normPos(sealer.position))] = true end end--ADD CACHING
	
	if DEBUG then local tmp=0 for _,_ in pairs(blocks) do tmp=tmp+1 end game.print("There are "..tmp.." sealent tiles") end
	
	local toLookAt={startingPoint}
	airTiles={}
	while not (#toLookAt==0) and #toLookAt<10000 do --and 
		local looking=table.remove(toLookAt)
		if blocks[positionHash(looking)]==nil then
			blocks[positionHash(looking)]=true
			airTiles[positionHash(looking)]=true
			table.insert(toLookAt,{x=looking.x,y=looking.y+1})
			table.insert(toLookAt,{x=looking.x,y=looking.y-1})
			table.insert(toLookAt,{x=looking.x+1,y=looking.y})
			table.insert(toLookAt,{x=looking.x-1,y=looking.y})
		end
	end
	
	if DEBUG then local tmp=0 for _,_ in pairs(airTiles) do tmp=tmp+1 end game.print(tmp.." toatal air tiles in area") end
	if #toLookAt>9999 then if DEBUG then game.print("unsealed") end return {false,airTiles} end
	
	return {true,airTiles}
end

remote.add_interface("oni",{ignorSurface=function(surface) table.insert(global.ignorSurfaces,surface)end})

--commands.add_command("testIt","none",function() checkForSeal(normPos(game.players[1].position),{"stone-wall","gate"},game.surfaces[1]) end)
AirTiles={}
script.on_event({defines.events.on_tick},
	function ()
		if game.tick%120==0 then
			for c,surface in pairs(game.surfaces) do
				
				AirTiles[surface.name]={}
				for _,dispenser in pairs(surface.find_entities_filtered{name="oxygen-dispenser"}) do
					if dispenser.fluidbox[1]~=nil then
						if dispenser.fluidbox[1].name=="oxygen" and  dispenser.fluidbox[1].amount>5 then
							result=checkForSeal(normPos(dispenser.position),{"stone-wall","gate"},surface)
							if result[1] then mearge(result[2],AirTiles[surface.name]) end
							--local tmp=0 for _,_ in pairs(result[2]) do tmp=tmp+1 end
							
							local fb=dispenser.fluidbox[1]
							fb.amount=fb.amount-5
							dispenser.fluidbox[1]=fb--tmp
							
						end
					end	
				end
			end
		end
		for _,player in pairs(game.players) do 
			if AirTiles[player.surface.name]~=nil and player.character~=nil then 
				if AirTiles[player.surface.name][positionHash(normPos(player.position))]==nil then 
					player.character.damage(0.05,player.force) 
				end
			end 
		end
	end
)

function initStructure()
	tiles={}
	for x=-10,10 do 
		for y=-10,10 do 
			table.insert(tiles, {name="concrete", position={x, y}, hidden_tile="dirt-1"})
		end
	end
	game.surfaces[1].set_tiles(tiles)
	y = -10 for x=-10,10 do	game.surfaces[1].create_entity({name="stone-wall",position={x,y},force=game.forces.player}) end
	y = 10 for x=-10,10 do	game.surfaces[1].create_entity({name="stone-wall",position={x,y},force=game.forces.player}) end
	x = -10 for y=-10,10 do	game.surfaces[1].create_entity({name="stone-wall",position={x,y},force=game.forces.player}) end
	x = 10 for y=-10,10 do	game.surfaces[1].create_entity({name="stone-wall",position={x,y},force=game.forces.player}) end
	game.surfaces[1].create_entity({name="oxygen-dispenser",position={0,0},force=game.forces.player}).direction=4
	game.surfaces[1].create_entity({name="chemical-plant",position={2.5,0},force=game.forces.player})
	tank=game.surfaces[1].create_entity({name="storage-tank",position={-0.5,2.5},force=game.forces.player})
	tank.direction=2
	local fb={}
	fb.name="oxygen"
	fb.amount=100000
	tank.fluidbox[1]=fb
	
end

script.on_init(
	function ()
		global.ignorSurfaces={}
		initStructure()
		
		--game.players[1].insert({name="stone-wall",count=1000})
	end)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
function Debug()
	game.players[1].character=nil
		for name,technology in pairs(game.players[1].force.technologies) do technology.researched=technology.enabled end
		game.players[1].cheat_mode=true
end










function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end