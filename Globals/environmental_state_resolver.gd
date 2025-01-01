extends Node

static var proc_world: ProcGenWorld

static func resolve(body: Node2D, body_rid: RID, environmentalState: EnvironmentalState) -> void:
	if body is TileMapLayer:
		var cell_coords = body.get_coords_for_body_rid(body_rid)
		if proc_world == null or !proc_world.logic_tiles.has(cell_coords):
			return
			
		var logic_tile: LogicTile = proc_world.logic_tiles[cell_coords]
		
		if environmentalState.elemental_states["burning"]:
			print("ici")
			logic_tile.environmental_state.set_elemental_state("burning", true)
			logic_tile.environmental_state.set_elemental_state("wet", false)
		
		if environmentalState.elemental_states["wet"]:
			print("la-bas")
			logic_tile.environmental_state.set_elemental_state("burning", false)
			logic_tile.environmental_state.set_elemental_state("wet", true)
		
		if logic_tile.environmental_state.elemental_states["burning"]:
			environmentalState.set_elemental_state("burning", true)
			environmentalState.set_elemental_state("wet", false)
		
		if logic_tile.environmental_state.elemental_states["wet"]:
			environmentalState.set_elemental_state("burning", false)
			environmentalState.set_elemental_state("wet", true)
		
