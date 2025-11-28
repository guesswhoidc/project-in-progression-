class_name Result extends Object

enum ResultType {
	OK,
	ERROR
}

var _error: Error
var _ok
var type : ResultType

## shortcut to failing with s default error type, has the same effect as error()
func default_error(message: String) -> Result: 
	return error(Error.new(message))

## sets the result to failed and saves the error object 
func error(err: Error):
	_error = err
	type = ResultType.ERROR
	return self

## sets result to succeeded and saves the value
func ok(res):
	_ok = res
	type = ResultType.OK
	return self

## checks if failed
func failed() -> bool:
	return type == ResultType.ERROR

## checks if succeeded
func succeeded() -> bool:
	return type == ResultType.OK

## Resolves the result into one of the call ables passed as arguments, it will pass the ok result on the ok path and the error on the fail path
func resolve(ok: Callable, failed: Callable):
	if succeeded():
		ok.call(_ok)
	else:
		failed.call(_error)

## reads the error message without checking if failed, check before calling it
func error_message() -> String:
	if !_error:
		return ""
	return _error.message

## for development purposes, checks if result succeeded if  not fail the assertion and show the error
func assert_succeeded():
	assert(succeeded(),error_message())

## returns the ok result without checking , check first before using
func result():
	return _ok
