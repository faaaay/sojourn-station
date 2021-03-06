/obj/item/weapon/mine_old
	name = "old land mine"
	desc = "A small highly dangerous explosive that looks rusted and aged beyond use. Unlike the newer models, this one has a proximity sensor, no amount of fancy footwork will save you here."
	density = 0
	anchored = 1
	icon = 'icons/obj/machines/excelsior/objects.dmi'
	icon_state = "mine_old"
	item_state = "mine_old"
	var/triggerproc = "explode" //name of the proc thats called when the mine is triggered
	var/triggered = 0
	var/smoke_strength = 3
	layer = HIDE_LAYER

/obj/item/weapon/mine_old/New()
	icon_state = "mine_old"

/obj/item/weapon/mine_old/attack_hand(mob/user as mob)
	.=..()
	if(prob(80))
		user.visible_message(
				SPAN_DANGER("[user] attempts to pick up \the [src] only to hear a beep as it explodes in your hands!"),
				SPAN_DANGER("You attempt to pick up \the [src] only to hear a beep as it explodes in your hands!")
				)
		explode()
	else
		user.visible_message(
				SPAN_DANGER("[user] attempts to pick up \the [src] and somehow doesn't blow himself up doing it!"),
				SPAN_DANGER("You attempt to pick up \the [src] and somehow you don't blow yourself up doing it!")
				)

/obj/item/weapon/mine_old/proc/explode(var/mob/living/M)
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread()
	triggered = 1
	s.set_up(3, 1, src)
	s.start()
	explosion(loc, 0, 3, 3, 4) //land mines are dangerous, folks.
	visible_message("\The [src.name] detonates!")
	qdel(s)
	qdel(src)

/obj/item/weapon/mine_old/attackby(obj/item/I, mob/user)
	if(QUALITY_PULSING in I.tool_qualities)
		user.visible_message(
		SPAN_DANGER("[user] starts to carefully disarm \the [src]."),
		SPAN_DANGER("You begin to carefully disarm \the [src].")
		)
	if(I.use_tool(user, src, WORKTIME_NORMAL, QUALITY_PULSING, FAILCHANCE_NORMAL,  required_stat = STAT_COG)) //disarming a mine with a multitool should be for smarties
		user.visible_message(
			SPAN_DANGER("[user] has disarmed \the [src] and it falls apart."),
			SPAN_DANGER("You have disarmed \the [src] and it falls apart!")
			)
		new /obj/item/weapon/material/shard/shrapnel/scrap(src.loc)
		new /obj/item/weapon/grenade/explosive(src.loc)
		qdel(src)
		return
	else
		user.visible_message(
			SPAN_DANGER("[user] has set off \the [src]!"))
		explode()
		return

/obj/item/weapon/mine_old/bullet_act()
	if(prob(90))
		explode()

/obj/item/weapon/mine_old/ex_act(severity)
	if(severity <= 2 || prob(90))
		explode()
	..()

/obj/item/weapon/mine_old/Crossed(AM as mob|obj)
	Bumped(AM)

/obj/item/weapon/mine_old/Bumped(mob/M as mob|obj)

	if(triggered) return

	if(ishuman(M))
		for(var/mob/O in viewers(world.view, src.loc))
			to_chat(O, "<font color='red'>[M] triggered the \icon[src] [src]</font>")
		triggered = 1
		call(src,triggerproc)(M)

/obj/item/weapon/spider_shadow_trap
	name = "odd shadow"
	desc = "You see an odd shadow, cast by something above you hiding in a crevice. A quick glance and you see eight red eyes filled with hatred glaring at you from the dark..."
	density = 0
	anchored = 1
	icon = 'icons/mob/64x64.dmi'
	icon_state = "spider_emperor_shadow"
	item_state = "spider_emperor_shadow"
	var/triggerproc = "ambush" //name of the proc thats called when the mine is triggered
	var/triggered = 0
	layer = HIDE_LAYER

/obj/item/weapon/spider_shadow_trap/New()
	..()
	pixel_x = -16
	pixel_y = -12

/obj/item/weapon/spider_shadow_trap/Crossed(AM as mob|obj)
	Bumped(AM)

/obj/item/weapon/spider_shadow_trap/Bumped(mob/M as mob|obj)

	if(triggered) return

	if(ishuman(M))
		for(var/mob/O in viewers(world.view, src.loc))
			M.visible_message(
				SPAN_DANGER("A gutteral screeching roar is heard right before [M] is knocked down by a huge spider leaping from above!"),
				SPAN_DANGER("You hear a gutteral screeching roar right before something huge falling from above knocks you down!")
			)
		triggered = 1
		call(src,triggerproc)(M)

/obj/item/weapon/spider_shadow_trap/proc/ambush(var/mob/living/M)
	triggered = 1
	playsound(src.loc, 'sound/sanity/screech.ogg', 300, 1)
	M.Weaken(8)
	new /mob/living/carbon/superior_animal/giant_spider/tarantula/emperor(src.loc)
	qdel(src)