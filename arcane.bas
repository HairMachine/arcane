#include once "util.bas"
#include once "event.bas"
#include once "map.bas"
#include once "tile.bas"
#include once "ec.bas"
#include once "game.bas"
#include once "inventory.bas"
#include once "actor.bas"
#include once "input.bas"
#include once "draw.bas"

function player_entity_create(el as EntityList, cl as ComponentList) as integer
	dim eid as integer = el.add("Player", "player")
	cl.add(new ControllableComponent(eid))
	cl.add(new PositionComponent(eid, 10, 10, 1, "@"))
	return eid
end function

function thingum_entity_create(el as EntityList, cl as ComponentList) as integer
	dim eid as integer = el.add("A Strange Thingum", "thingum")
	return eid
end function

screenres 800, 600, 32


dim tm as TileMap
tm.insert("#", 0, 0)
tm.insert(".", 3, 6)

dim ts as Tileset
ts.loadFromFile("dungeon")
ts.tileMap = tm

dim actors_tm as TileMap
actors_tm.insert("@", 0, 0)

dim actors_ts as Tileset
actors_ts.loadFromFile("people")
actors_ts.tileMap = actors_tm

dim map as MapData
map.loadFromFile("test")

dim gm as Gamestate
dim el as EntityList
dim cl as ComponentList

el.add("", "") 'add a null entity for id 0
gm.playerId = player_entity_create(el, cl)
dim thingum_id as integer = thingum_entity_create(el, cl)
dim thingum2_id as integer = thingum_entity_create(el, cl)

InventoryPickupSystem(thingum_id, gm.playerId, cl)
InventoryPickupSystem(thingum2_id, gm.playerId, cl)

dim camera as CameraClass
camera.w = 10
camera.h = 10
camera.lockToEntity(gm.playerId, cl)

do
	KeyboardControlSystem(cl, el, gm, map)
	camera.followLockedEntity()
	screenlock
	cls
	MapDrawSystem(map, ts, camera)	
	EntityDrawSystem(cl, actors_ts, camera)
	screenunlock
	sleep 1
loop until gm.gameover = 1


