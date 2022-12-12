extends EntityAction

onready var damageIndicator = preload("res://Items/Weapons/WeaponEffects/DamageIndicator.tscn")

var target: EntityActor
var location: Vector2

func execute():
	if entity == null or target == null:
		yield(get_tree(), "idle_frame")
		return false
	
	# Get direction and animate an attack move
	#print("[%s] TODO Implement attack animation" % name)
	var weapon = get_node_or_null("../../Weapon")
	if weapon is Node:
		var weaponTexture = PlayerInventory.current_weapon.texture
		if weaponTexture != null:
			weapon.set_texture(weaponTexture)
		weapon.play_animation("Swing")
	
	# Damage the target and maybe kill it
	if target.group == EntityObject.Group.Player:
		return attack_player_target()
	if target.group == EntityObject.Group.Enemy:
		return attack_enemy_target()
	yield(get_tree(), "idle_frame")
	return false

func attack_enemy_target():
	var damage = PlayerStats.get_damage()
	target.take_damage(damage)
	indicate_damage(target, damage, Color.whitesmoke)
	yield(get_tree(), "idle_frame")
	return true

func attack_player_target():
	var damage = entity.get_damage()
	PlayerStats.take_damage(damage)
	indicate_damage(target, damage, Color.crimson)
	yield(get_tree(), "idle_frame")
	return true

func indicate_damage(attack_target: Node, damage: int, color: Color):
	var damageIndication = damageIndicator.instance()
	damageIndication.damage = damage
	damageIndication.color = color
	damageIndication.global_position = attack_target.global_position
	get_tree().get_current_scene().add_child(damageIndication)
