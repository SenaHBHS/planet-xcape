extends Node

# best time is the least amount of time taken to beat each level
var _best_time_dict = {
	"easy": 0,
	"medium": 0,
	"hard": 0
}

func get_high_score(level):
	return _best_time_dict[level]

func update_best_time(time_taken_in_the_current_round, level):
	if time_taken_in_the_current_round > _best_time_dict[level]:
		_best_time_dict[level] = time_taken_in_the_current_round
	else:
		pass
