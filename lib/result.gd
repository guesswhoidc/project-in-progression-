class_name Result extends Object

enum ResultType {
	OK,
	ERROR
}

var _error: Error
var _ok
var type : ResultType

func default_error(message: String) -> Result: 
	return error(Error.new(message))

func error(err: Error):
	_error = err
	type = ResultType.ERROR
	return self

func ok(res):
	_ok = res
	type = ResultType.OK
	return self

func failed() -> bool:
	return type == ResultType.ERROR

func succeeded() -> bool:
	return type == ResultType.OK

func resolve(ok: Callable, failed: Callable):
	if succeeded():
		ok.call()
	else:
		failed.call(_error)
