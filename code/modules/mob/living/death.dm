/mob/living/carbon/death(gibbed)
	if(!gibbed)
		SetDizziness(0)
		SetJitteriness(0)
		SetStuttering(0)
	. = ..()