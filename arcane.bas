#include once "util.bas"
#include once "event.bas"
#include once "tile.bas"
#include once "ec.bas"
#include once "map.bas"
#include once "game.bas"
#include once "actor.bas"
#include once "artefact.bas"
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
tm.insert("scroll", 0, 23)
tm.insert("rod", 15, 25)
tm.insert("gem", 14, 26)
tm.insert("ring", 0, 19)
tm.insert("amulet", 4, 19)
tm.insert("instrument", 20, 20)
tm.insert("lamp", 29, 19)
tm.insert("dagger", 5, 13)
tm.insert("mirror", 1, 20)

dim ts as Tileset
ts.loadFromFile("Nh32")
ts.tileMap = tm

dim gm as Gamestate

dim map as MapData
map.loadFromFile("test")
MapToEntitySystem(gm, map)

gm.el.add("", "") 'add a null entity for id 0
gm.playerId = player_entity_create(gm)

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


