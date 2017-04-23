type ArtefactEffectComponent extends Component
	dim displayName as string
	dim goodEffect as string
	dim badEffect as string
	dim statName as string
	dim statThresh as integer
	declare constructor(eid as integer, dn as string, ge as string, be as string, sn as string, st as integer)
end type

constructor ArtefactEffectComponent(eid as integer, dn as string, ge as string, be as string, sn as string, st as integer)
	this.entity_id = eid
	this.name = "ArtefactEffectComponent"
	this.displayName = dn
	this.goodEffect = ge
	this.badEffect = be
	this.statName = sn
	this.statThresh = st
end constructor

sub artefact_effect(effect as string, user as AttributeComponent ptr, gm as Gamestate)
	select case effect
		case "suicide":
			cls
			print "Your life is snuffed out immediately."
			getkey
			gm.gameOver = 1
		case "triumph":
			cls
			print "You win!"
			getkey
			gm.gameOver = 1
	end select
end sub 

sub ArtefactEffectSystem(eid as integer, user as integer, gm as Gamestate)
	dim effect as ArtefactEffectComponent ptr = cast(ArtefactEffectComponent ptr, gm.cl.entityComponent(eid, "ArtefactEffectComponent"))
	if effect = 0 then
		gm.ml.add("Nothing happens.")
		exit sub
	end if
	'calculate effect success on user
	dim stats as AttributeComponent ptr = cast(AttributeComponent ptr, gm.cl.entityComponent(user, "AttributeComponent"))
	if stats = 0 then
		gm.ml.add("ERROR: No user!")
		exit sub
	end if
	select case effect->statName
		case "strength": 
			if stats->strength >= effect->statThresh then
				artefact_effect(effect->goodEffect, stats, gm)
			else
				artefact_effect(effect->badEffect, stats, gm)
			end if
		case "dexterity":
			if stats->dexterity >= effect->statThresh then
				artefact_effect(effect->goodEffect, stats, gm)
			else
				artefact_effect(effect->badEffect, stats, gm)
			end if
		case "wisdom":
			if stats->wisdom >= effect->statThresh then
				artefact_effect(effect->goodEffect, stats, gm)
			else
				artefact_effect(effect->badEffect, stats, gm)
			end if
		case "charisma":
			if stats->charisma >= effect->statThresh then
				artefact_effect(effect->goodEffect, stats, gm)
			else
				artefact_effect(effect->badEffect, stats, gm)
			end if
		case "intelligence":
			if stats->intelligence >= effect->statThresh then
				artefact_effect(effect->goodEffect, stats, gm)
			else
				artefact_effect(effect->badEffect, stats, gm)
			end if
	end select
end sub


