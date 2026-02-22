extends Node3D


# Called when the node enters the scene tree for the first time.
@export var enemyList:EnemyList
@export var levelData:level_data
var waveIndex=0
func _ready() -> void:
	StartNextWave()
func StartNextWave():
	for enemy in levelData.waves[waveIndex].EnemySpawns:
		var newInstance = enemyList.scenes[enemy.enemyID].instantiate()
		print(newInstance)
		add_child(newInstance)
		newInstance.global_position=enemy.spawnLocation
		newInstance.add_to_group("enemy")
