extends ConsumableEffect
class_name OneChallengeStatBoostEffect

export(int) var fortitude_boost: int = 0
export(int) var daring_boost: int = 0
export(int) var smarts_boost: int = 0

func trigger_effect(_consumable_item: ConsumableItem) -> void:
	if fortitude_boost > 0:
		ActorStats.fortitude_boost = fortitude_boost
	if daring_boost > 0:
		ActorStats.daring_boost = daring_boost
	if smarts_boost > 0:
		ActorStats.smarts_boost = smarts_boost
