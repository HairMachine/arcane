#include once "util.bas"
#include once "event.bas"
#include once "tile.bas"
#include once "ec.bas"
#include once "map.bas"
#include once "game.bas"
#include once "actor.bas"
#include once "essence.bas"
#include once "elixir.bas"
#include once "book.bas"
#include once "artefact.bas"
#include once "distiller.bas"
#include once "ritual.bas"
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
tm.insert("ivory rod", 16, 25)
tm.insert("copper rod", 12, 25)
tm.insert("green gem", 14, 26)
tm.insert("ring", 0, 19)
tm.insert("amulet", 4, 19)
tm.insert("horn", 20, 20)
tm.insert("lamp", 29, 19)
tm.insert("dagger", 5, 13)
tm.insert("mirror", 1, 20)
tm.insert("silver bell", 4, 21)
tm.insert("harp", 25, 20)
tm.insert("dull bell", 26, 20)
tm.insert("tambourine", 28, 20)
tm.insert("red gem", 1, 27)
tm.insert("black gem", 5, 27)
tm.insert("lantern", 27, 19)
tm.insert("box", 15, 19)
tm.insert("essence", 8, 16)
tm.insert("book", 0, 24)
tm.insert("|", 5, 29)
tm.insert("I", 14, 29)
tm.insert("$", 15, 29)
tm.insert("elixir", 4, 22)
tm.insert("ritual_switch", 16, 29)

dim ts as Tileset
ts.loadFromFile("Nh32")
ts.tileMap = tm

dim gm as Gamestate
essence_init(gm)

dim map as MapData
map.loadFromFile("test")
MapToEntitySystem(gm, map)

gm.el.add("", "") 'add a null entity for id 0
gm.playerId = player_entity_create(gm)

dim camera as CameraClass
camera.w = 14
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
	ActorDeathSystem(gm)
	sleep 1
loop until gm.gameover = 1


