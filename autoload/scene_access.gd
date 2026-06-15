extends Node

## Enum for level will be an key in dict
enum Levels {
	TEST_LEVEL = -1,
	MAIN_MENU = 0,
	LEVEL1,
	LEVEL2,
	LEVEL3,
}

## Dictionary mapping a given level id enum to the rid for the corresponding scene
var lvl_dict: Dictionary[Levels, String] = {
	Levels.TEST_LEVEL : "uid://bfafu0m38vteu",
	Levels.MAIN_MENU : "uid://jl41h4rl37o8",
}
