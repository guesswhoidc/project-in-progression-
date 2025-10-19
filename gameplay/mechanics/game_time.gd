class_name GameTime extends Object

const MORNING_TIME = 60 * 7
const NOON_TIME = 60 * 12
const NIGHT_TIME = 60 * 19
const MIDNIGHT_TIME = 60 * 24

var time := 0.0

func minutes() -> float:
	return fmod(time, 60.0)

func hours() -> float:
	return floorf(time / 60)
