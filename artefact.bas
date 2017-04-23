type ArtefactEffectComponent extends Component
	dim displayName as string
	dim goodEffect as string
	dim badEffect as string
	dim statName as string
	dim statThresh as integer
	dim charges as integer
	declare constructor(eid as integer, dn as string, ge as string, be as string, sn as string, st as integer, charges as integer)
end type

constructor ArtefactEffectComponent(eid as integer, dn as string, ge as string, be as string, sn as string, st as integer, charges as integer)
	this.entity_id = eid
	this.name = "ArtefactEffectComponent"
	this.displayName = dn
	this.goodEffect = ge
	this.badEffect = be
	this.statName = sn
	this.statThresh = st
	this.charges = charges
end constructor

function artefact_adjective() as string
	dim t as integer = rnd() * 38
	select case t
		case 0: return "ornate"
		case 1: return "engraved"
		case 2: return "carven"
		case 3: return "polyhedral"
		case 4: return "angular"
		case 5: return "plain"
		case 6: return "inscribed"
		case 7: return "obscene"
		case 8: return "tiny"
		case 9: return "grotesque"
		case 10: return "beautiful"
		case 11: return "disconcerting"
		case 12: return "reflective"
		case 13: return "light-absorbing"
		case 14: return "shiny"
		case 15: return "matt"
		case 16: return "lumpy"
		case 17: return "severely aged"
		case 18: return "lacquered"
		case 19: return "finely-wrought"
		case 20: return "misshapen"
		case 21: return "crude"
		case 22: return "distressingly furry"
		case 23: return "hideous"
		case 24: return "ugly"
		case 25: return "nasty"
		case 26: return "cheap-looking"
		case 27: return "venerable"
		case 28: return "antique"
		case 29: return "glimmering"
		case 30: return "functional"
		case 31: return "pitted"
		case 32: return "tarnished"
		case 33: return "corroded"
		case 34: return "melted-looking"
		case 35: return "extravagant"
		case 36: return "bejewelled"
		case 37: return "grimy"
		case 38: return "filthy"
	end select
	return ""
end function

function artefact_type() as string
	dim t as integer = rnd() * 15
	select case t
		case 0: return "horn"
		case 1: return "silver bell"
		case 2: return "harp"
		case 3: return "dull bell"
		case 4: return "tambourine"
		case 5: return "green gem"
		case 6: return "red gem"
		case 7: return "black gem"
		case 8: return "ring"
		case 9: return "ivory rod"
		case 10: return "copper rod"
		case 11: return "lantern"
		case 12: return "mirror"
		case 13: return "box"
		case 14: return "amulet"
		case 15: return "dagger"
	end select
	return ""
end function

function artefact_entity_create(gm as Gamestate, x as integer, y as integer) as integer
	dim eid as integer
	'choose cosmetic information
	dim glyph as string = artefact_type()
	dim rname as string = artefact_adjective() + " " + glyph
	'if the artefact has already been generated, just don't generate anything
	for i as integer = 0 to ubound(gm.el.entities)
		if gm.el.entities(i).name = rname then
			gm.ml.add("You feel strangely disappointed.")
			return -1
		end if
	next
	'generate the artefact effects
	eid = gm.el.add(rname, "artefact")
	'choose the display name, good effect and stat threshold of the item
	dim display_name as string
	dim good_effect as string
	dim bad_effect as string
	dim stat_name as string
	dim stat_thresh as integer
	dim charges as integer
	dim effect as integer = rnd() * 7
	select case effect
		case 0: 
			display_name = "Strength"
			good_effect = "boost_strength"
			stat_thresh = rnd() * 25
			charges = d(6, 1)
		case 1: 
			display_name = "Dexterity"
			good_effect = "boost_dexterity"
			stat_thresh = rnd() * 25
			charges = d(6, 1)
		case 2: 
			display_name = "Intelligence"
			good_effect = "boost_intelligence"
			stat_thresh = rnd() * 25
			charges = d(6, 1)
		case 3: 
			display_name = "Wisdom"
			good_effect = "boost_wisdom"
			stat_thresh = rnd() * 25
			charges = d(6, 1)
		case 4: 
			display_name = "Charisma"
			good_effect = "boost_charisma"
			stat_thresh = rnd() * 25
			charges = d(6, 1)
		case 5: 
			display_name = "Maximum HP"
			good_effect = "boost_maxhp"
			stat_thresh = rnd() * 25
			charges = d(6, 1)
		case 6: 
			display_name = "Sanity"
			good_effect = "boost_sanity"
			stat_thresh = rnd() * 25
			charges = d(6, 1)
		case 7:
			display_name = "Create Artefact"
			good_effect = "create_artefact"
			stat_thresh = 25
			charges = 1
	end select
	'choose the bad effect of the item
	effect = rnd() * 8
	select case effect
		case 0: bad_effect = "suicide"
		case 1: bad_effect = "drain_strength"
		case 2: bad_effect = "drain_dexterity"
		case 3: bad_effect = "drain_intelligence"
		case 4: bad_effect = "drain_wisdom"
		case 5: bad_effect = "drain_charisma"
		case 6: bad_effect = "drain_maxhp"
		case 7: bad_effect = "drain_sanity"
		case 8: bad_effect = "wounding"
		case 9: bad_effect = "fear"
		case else: bad_effect = ""
	end select
	'choose the stat of the item
	dim stat as integer = rnd() * 4
	select case stat
		case 0: stat_name = "strength"
		case 1: stat_name = "dexterity"
		case 2: stat_name = "intelligence"
		case 3: stat_name = "wisdom"
		case 4: stat_name = "charisma"
	end select
	'create the artefact
	gm.cl.add(new ArtefactEffectComponent(eid, display_name, good_effect, bad_effect, stat_name, stat_thresh, charges))
	/'cls
	print "Artefact created:"
	print rname + " of " + display_name
	print good_effect
	print bad_effect
	print stat_name + " >= " + str(stat_thresh)
	getkey'/
	'drop the artefact
	gm.cl.add(new PositionComponent(eid, x, y, 1, glyph, 0, 1))
	return eid
end function

sub artefact_effect(effect as string, user as AttributeComponent ptr, gm as Gamestate)
	select case effect
		case "suicide":
			cls
			print "Your life is snuffed out immediately."
			getkey
			gm.gameOver = 1
		case "boost_strength":
			gm.ml.add("You feel powerful!")
			user->strength += d(6, 1)
		case "boost_dexterity":
			gm.ml.add("You feel nimble!")
			user->dexterity += d(6, 1)
		case "boost_intelligence":
			gm.ml.add("You feel sharp!")
			user->intelligence += d(6, 1)
		case "boost_wisdom":
			gm.ml.add("You feel experienced!")
			user->wisdom += d(6, 1)
		case "boost_charisma":
			gm.ml.add("You feel sociable!")
			user->charisma += d(6, 1)
		case "boost_maxhp":
			gm.ml.add("You feel healthy!")
			user->maxHp += d(6, 1)
		case "boost_sanity":
			gm.ml.add("You feel in control!")
			user->maxSanity += d(6, 1)
		case "drain_strength":
			gm.ml.add("You feel puny!")
			user->strength -= d(6, 1)
		case "drain_dexterity":
			gm.ml.add("You feel clumsy!")
			user->dexterity -= d(6, 1)
		case "drain_intelligence":
			gm.ml.add("You feel stupid!")
			user->intelligence -= d(6, 1)
		case "drain_wisdom":
			gm.ml.add("You feel rash!")
			user->wisdom -= d(6, 1)
		case "drain_charisma":
			gm.ml.add("You feel awkward!")
			user->charisma -= d(6, 1)
		case "drain_maxhp":
			gm.ml.add("You feel frail!")
			user->maxHp -= d(6, 1)
			user->hp = user->maxHP
		case "drain_sanity":
			gm.ml.add("You feel disturbed!")
			user->maxSanity -= d(6, 1)
			user->sanity = user->maxSanity
		case "create_artefact":
			gm.ml.add("Something falls at your feet!")
			dim p as PositionComponent ptr = cast(PositionComponent ptr, gm.cl.entityComponent(user->entity_id, "PositionComponent"))
			artefact_entity_create(gm, p->x, p->y)
		case "wounding":
			gm.ml.add("Painful wounds open up all over your body!")
			user->hp -= d(4, 2)
		case "fear":
			gm.ml.add("You feel a terrible presence wrenching at your mind!")
			user->sanity -= d(4, 2)
		case else:
			gm.ml.add("Nothing happens.")
	end select
end sub 

sub ArtefactEffectSystem(eid as integer, user as integer, gm as Gamestate)
	dim effect as ArtefactEffectComponent ptr = cast(ArtefactEffectComponent ptr, gm.cl.entityComponent(eid, "ArtefactEffectComponent"))
	if effect = 0 then
		gm.ml.add("Nothing happens.")
		exit sub
	end if
	'if there's no charges left, it doesn't work
	if effect->charges <= 0 then
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
	'remove a charge from the artefact
	effect->charges -= 1
end sub


