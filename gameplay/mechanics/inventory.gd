class_name Inventory extends Resource
@export var items : Array[InventoryItem]

class CantFitItemError extends Error:
	var remainder : int = 0
	var item_type : ItemType
	func _init(amount : int, type: ItemType):
		remainder = amount
		message = "Inventory is full"
		item_type = type
class CantDeleteEnoughItemsError extends Error:
	var remainder : int = 0
	var item_type : ItemType
	func _init(amount: int, type: ItemType):
		message = "Coudn't find enough items to delete"
		remainder = amount
		item_type = type

func can_fit_item(type: ItemType, amount: int) -> bool:
	var count = amount
	for slot in items:
		if count <= 0:
			return true
		if !slot:
			count -= type.stack_size
		if slot.item_type == type:
			count -= slot.amount - type.stack_size
	return count <= 0

func add_item(type : ItemType, amount : int) -> Result:
	var count = amount
	# Adds items to unfilled slots
	for slot in items:
		if count <= 0:
			break
		if slot && slot.item_type == type:
			slot.amount += count
			if slot.amount > type.stack_size:
				count = type.stack_size - slot.amount
				slot.amount = type.stack_size
	# if any is left create a new slot and
	# add it to it
	for i in range(items):
		var slot = items[i]
		if slot && slot.item_type:
			continue
		if !slot:
			items[i] = InventoryItem.new()
			slot = items[i]
		slot.itiem_type = type
		slot.amount += count
		if slot.amount > type.stack_size:
			count = type.stack_size - slot.amount
			slot.amount = type.stack_size
	if count > 0:
		return CantFitItemError.new(count, type).as_result()
	return Result.new().ok(null)

func remove_item(type: ItemType, amount:int) -> Result:
	var count := amount
	for slot in items:
		if count <= 0:
			return Result.new().ok(null)
		if !slot or slot.item_type != type:
			continue
		var delta = slot.amount - count
		slot.amount = min(0, slot.amount - count)
		if delta > 0:
			return Result.new().ok(null)
		count += delta
	if count > 0:
		return CantDeleteEnoughItemsError.new(count, type).as_result()
	return Result.new().ok(null)

func count_item_type(type: ItemType) -> int:
	var count : int = 0
	for slot in items:
		if !slot:
			continue
		if slot.item_type == type:
			count += slot.amount
	return count
