#include once "util.bas"
#include once "event.bas"
#include once "tile.bas"
#include once "ec.bas"
#include once "map.bas"
#include once "game.bas"
#include once "inventory.bas"
#include once "actor.bas"
#include once "input.bas"
#include once "draw.bas"
#include once "entity_create.bas"


screenres 800, 600, 32
randomize timer

dim tm as TileMap
tm.insert("#", 0, 0)
tm.insert(".", 3, 6)

dim ts as Tileset
ts.loadFromFile("dungeon")
ts.tileMap = tm

dim actors_tm as TileMap
actors_tm.insert("@", 0, 0)
actors_tm.insert("+", 1, 1)
actors_tm.insert("/", 1, 2)

dim actors_ts as Tileset
actors_ts.loadFromFile("people")
actors_ts.tileMap = actors_tm

dim gm as Gamestate
dim el as EntityList
dim cl as ComponentList

dim map as MapData
map.loadFromFile("test")
MapToEntitySystem(el, cl, map)

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
	AttributeDisplaySystem(cl, gm.playerId)
	screenunlock
	sleep 1
loop until gm.gameover = 1


