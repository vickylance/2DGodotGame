extends Node

var coins_collected := 0 setget set_coins

func set_coins(new_value):
	coins_collected = new_value
	print(coins_collected)
