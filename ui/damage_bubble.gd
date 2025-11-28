extends CanvasLayer

var combat_result : Combat.CombatResolution

func prepare(res : Combat.CombatResolution):
	combat_result = res
	var text : String
	#match type:
	#	Type.CRITICAL:
	#		$Control/Panel.draw_center = true
	match combat_result.type:
		Combat.ResolutionType.HIT:
			text = "%d" %(floor(combat_result.damage * 10))
		Combat.ResolutionType.DODGE:
			text = "DODGE"
		Combat.ResolutionType.MISS:
			text = "MISS"
	
	$Control/Panel/Label.text = text
	
	
