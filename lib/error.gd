class_name Error extends Object

var message := "Default Error Message"

func _init(mes: String):
	message = mes

func as_result() -> Result:
	return Result.new().error(self)
