type Gamestate
	gameover as integer = 0
	playerId as integer
	el as EntityList
	cl as ComponentList
	ml as MessageLog
	essences as StringToStringMap
end type
