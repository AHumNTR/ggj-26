@tool
extends EditorPlugin
class_name wave_editor
var SavedLevels: Array[level_data]
var CurrentLevel: level_data
#hardcoded for now will find a better solution later
var preview_scenes: Array[PackedScene] = [
preload("res://Enemies/enemy_basic.tscn"),
preload("res://Enemies/enemy_dash.tscn"),
preload("res://Enemies/enemy_floating.tscn"),
preload("res://Enemies/enemy_ranged.tscn"),
preload("res://Enemies/enemy_fries.tscn"),
]
var MapNamePopup:ConfirmationDialog
var MapNameInput:LineEdit
var MapSelectButton:MenuButton
var WaveSpinBox: SpinBox
var preview_instance: Node3D
var selectedWave:int=1:
	set(value):
		selectedWave=value
		WaveSpinBox.value=value


var dock_ui: Control
var EnemyItemList: ItemList
func _enable_plugin() -> void:
	pass	

 
func _disable_plugin() -> void:
	if is_instance_valid(preview_instance):
		preview_instance.free() 
	pass

 
func _enter_tree() -> void:
	GetLevels()
	ReloadGui()

func _exit_tree() -> void:
	if dock_ui:
		remove_control_from_docks(dock_ui)
		dock_ui.queue_free()
	pass

var enemyTypeId:int#value of -1 means no enemy is selected halting previews
func enemy_selected(id:int):
	if is_instance_valid(preview_instance):
		preview_instance.queue_free()
	if(id==enemyTypeId):
		enemyTypeId=-1
		EnemyItemList.deselect_all()
		return
	var root = EditorInterface.get_edited_scene_root()
	enemyTypeId=EnemyItemList.get_selected_items()[0]
	preview_instance = preview_scenes[enemyTypeId].instantiate()
	root.add_child(preview_instance)

func _handles(object):
	return true
func ReloadGui():
	if(is_instance_valid(dock_ui)):
	#delete the dock_ui if it exists
		remove_control_from_docks(dock_ui)
		dock_ui.queue_free()
	#create a new dock_ui and add it to docks
	dock_ui = preload("res://addons/wave_editor/Wave_Editor_UI.tscn").instantiate()
	add_control_to_dock(DOCK_SLOT_RIGHT_BL, dock_ui)
	#set up the connections of ui elements
	EnemyItemList=dock_ui.get_node("GridContainer/Enemy_Item_List")
	WaveSpinBox=dock_ui.get_node("GridContainer/WaveSpinBox")
	EnemyItemList.item_selected.connect(enemy_selected)
	WaveSpinBox.value_changed.connect(ChangeWave)
	#buttons 
	(dock_ui.get_node("GridContainer/ReloadButton")as Button).pressed.connect(ReloadGui)
	(dock_ui.get_node("GridContainer/SaveButton")as Button).pressed.connect(SaveLevels)
	(dock_ui.get_node("GridContainer/AddNewLevelButton")as Button).pressed.connect(StartAddNewLevel)
	(dock_ui.get_node("GridContainer/WaveButtons/AddButton")as Button).pressed.connect(AddWave)
	(dock_ui.get_node("GridContainer/WaveButtons/DeleteButton")as Button).pressed.connect(DeleteWave)
	MapSelectButton=(dock_ui.get_node("GridContainer/MapButton")as MenuButton)
	var MapPopup:=MapSelectButton.get_popup()
	MapPopup.clear()
	MapPopup.index_pressed.connect(LoadLevel)
	for mapID in SavedLevels.size():
		MapPopup.add_item(SavedLevels[mapID].levelName,mapID)
	MapNamePopup=dock_ui.get_node("MapNamePopup")
	MapNamePopup.confirmed.connect(AddNewLevel)
	MapNameInput=MapNamePopup.get_node("LineEdit")
	
	if(SavedLevels.is_empty()):
		MapNameInput.text="EmptyLevel"
		AddNewLevel()
	else: LoadLevel(0)

func _forward_3d_gui_input(viewport_camera: Camera3D, event: InputEvent):
	if event is InputEventMouseMotion:#this still needs to run to update the raycast for deletion
		_update_preview(viewport_camera, event.position)
		return EditorPlugin.AFTER_GUI_INPUT_PASS 

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and enemyTypeId!=-1:
		if event.pressed:
			if is_instance_valid(preview_instance):
				var uid=ResourceUID.create_id()
				SpawnEnemy(enemyTypeId,preview_instance.global_position,uid)
				#add the enemy to the spawn data
				var enemy_data:= enemy_spawn_data.new()
				enemy_data.enemyID=enemyTypeId
				enemy_data.spawnLocation=preview_instance.global_position
				enemy_data.uid=uid
				CurrentLevel.waves[selectedWave].EnemySpawns.append(enemy_data)
			
			return EditorPlugin.AFTER_GUI_INPUT_STOP
			
	if event is InputEventKey and (event as InputEventKey).key_label==Key.KEY_X:
		if(hit.collider and hit.collider is CollisionObject3D):
			var collider: CollisionObject3D= hit.collider
			var uid =collider.get_meta("uid")
			for i in CurrentLevel.waves[selectedWave].EnemySpawns.size():
				if(CurrentLevel.waves[selectedWave].EnemySpawns[i].uid==uid):
					CurrentLevel.waves[selectedWave].EnemySpawns.remove_at(i)
					break
			collider.queue_free()
			return EditorPlugin.AFTER_GUI_INPUT_STOP
	return EditorPlugin.AFTER_GUI_INPUT_PASS
var hit:Dictionary
func _update_preview(camera: Camera3D, mouse_pos: Vector2):
	var root = EditorInterface.get_edited_scene_root()
	if not root:
		return 
		
		
	
	var ray_origin = camera.project_ray_origin(mouse_pos)
	var ray_dir = camera.project_ray_normal(mouse_pos)
	var ray_end = ray_origin + ray_dir * 1000.0
	var space_state = camera.get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_origin, ray_end)
	hit = space_state.intersect_ray(query)
	
	if enemyTypeId==-1:return
	if not is_instance_valid(preview_instance):
		preview_instance = preview_scenes[enemyTypeId].instantiate()
		root.add_child(preview_instance,false,InternalMode.INTERNAL_MODE_FRONT)
	if hit:
		if(hit.collider.is_in_group("preview")):
			preview_instance.visible=false
		else:
			preview_instance.visible=true
		preview_instance.global_position = hit.position
	else:
		preview_instance.position = ray_origin + ray_dir * 10.0
func SaveLevels():
	ResourceSaver.save(CurrentLevel,"res://addons/wave_editor/Levels/"+CurrentLevel.levelName+".res")

func GetLevels():
	var dir := DirAccess.open("res://addons/wave_editor/Levels")
	if dir == null: printerr("Could not open folder"); return
	dir.list_dir_begin()
	for file: String in dir.get_files():
		var level:level_data=ResourceLoader.load("res://addons/wave_editor/Levels/"+file) as level_data
		SavedLevels.append(level)
	dir.list_dir_end()
func AddNewLevel():
	var NewLevel:=level_data.new()
	NewLevel.levelName=MapNameInput.text
	MapSelectButton.get_popup().add_item(MapNameInput.text)
	MapSelectButton.text=MapNameInput.text
	CurrentLevel=NewLevel
	AddWave()

func StartAddNewLevel():
	MapNamePopup.popup_centered_clamped()
	pass
func LoadLevel(index):
	MapSelectButton.text=SavedLevels[index].levelName
	CurrentLevel=SavedLevels[index]
	WaveSpinBox.max_value=CurrentLevel.waves.size()-1

func AddWave():
	#add wave to the current level
	var wavedata=wave_data.new()
	CurrentLevel.waves.append(wavedata)
	#there is a setter to update the spinbox o selectedWave
	WaveSpinBox.max_value=CurrentLevel.waves.size()-1
	selectedWave=CurrentLevel.waves.size()-1
	LoadWave()
	pass
func DeleteWave():
	CurrentLevel.waves.remove_at(selectedWave)
	if(CurrentLevel.waves.size()==0):
		AddWave()
	selectedWave=CurrentLevel.waves.size()-1
	pass

func LoadWave():
	CleanOldWave()

	for enemy in CurrentLevel.waves[selectedWave].EnemySpawns:
		SpawnEnemy(enemy.enemyID,enemy.spawnLocation,enemy.uid)
func CleanOldWave():
	var root = EditorInterface.get_edited_scene_root()
	if not root:
		return
	var items_to_delete = root.get_tree().get_nodes_in_group("preview")
	for item in items_to_delete:
		item.queue_free()
func ChangeWave(value):
	#is called when spinbox value changes
	#might create a loop (it doesnt on this version of godot at least)
	selectedWave=value
	LoadWave()
func SpawnEnemy(enemyID:int,position:Vector3,uid:int):
	var root=EditorInterface.get_edited_scene_root()
	var newInstance = preview_scenes[enemyID].instantiate()
	newInstance.position=position
	newInstance.add_to_group("preview")
	newInstance.set_meta("uid",uid)
	root.add_child(newInstance,false,Node.INTERNAL_MODE_FRONT)
