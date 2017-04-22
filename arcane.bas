#include once "util.bas"
#include once "event.bas"
#include once "tile.bas"
#include once "ec.bas"
#include once "map.bas"
#include once "game.bas"
#include once "actor.bas"
#include once "inventory.bas"
#include once "input.bas"
#include once "draw.bas"
#include once "entity_create.bas"

screenres 640, 480, 32
randomize timer

dim tm as TileMap
tm.insert("#", 24, 27)
tm.insert(".", 8, 28)
tm.insert("@", 4, 6)
tm.insert("+", 4, 28)
tm.insert("/", 3, 28)
tm.insert("?", 0, 23)

dim ts as Tileset
ts.loadFromFile("Nh32")
ts.tileMap = tm

dim gm as Gamestate

dim map as MapData
map.loadFromFile("test")
MapToEntitySystem(gm, map)

gm.el.add("", "") 'add a null entity for id 0
gm.playerId = player_entity_create(gm)

'InventoryPickupSystem(thingum_id, gm.playerId, gm)
'InventoryPickupSystem(thingum2_id, gm.playerId, gm)

dim camera as CameraClass
camera.w = 10
camera.h = 10
camera.lockToEntity(gm.playerId, gm.cl)

gm.ml.add("Welcome to Arcane!")

do
	KeyboardControlSystem(gm, map)
	camera.followLockedEntity()
	screenlock
	cls
	MapDrawSystem(map, ts, camera)	
	EntityDrawSystem(gm.cl, ts, camera)
	AttributeDisplaySystem(gm.cl, gm.playerId)
	MessageDisplaySystem(gm.ml)
	screenunlock
	sleep 1
loop until gm.gameover = 1


