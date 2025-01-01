extends Node

static var proc_world: ProcGenWorld

static func resolve(body: Node2D, body_rid: RID, environmentalState: EnvironmentalState) -> void:
	if body is TileMapLayer:
		var cell_coords = body.get_coords_for_body_rid(body_rid)
		if proc_world == null or !proc_world.logic_tiles.has(cell_coords):
			return
			
		var logic_tile: LogicTile = proc_world.logic_tiles[cell_coords]
		priorizedPropagation(environmentalState, logic_tile.environmental_state)
	
static func propagate(from: EnvironmentalState, to: EnvironmentalState) -> void:
	for key in from.elemental_states:
		to.set_elemental_state(key, from.elemental_states[key])

static func priorizedPropagation(source_a: EnvironmentalState, source_b: EnvironmentalState) -> void:
	if (source_a.priority == null or source_b.priority == null):
		assert(false, "Every EnvironmentalState must have a priority set")

	if source_a.is_altered() and !source_b.is_altered():
		propagate(source_a, source_b)
	elif !source_a.is_altered() and source_b.is_altered():
		propagate(source_b, source_a)
	elif (source_a.priority <= source_b.priority):
		propagate(source_a, source_b)
	else:
		propagate(source_b, source_a)
	
