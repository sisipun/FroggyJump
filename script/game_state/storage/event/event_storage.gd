class_name EventStorage
extends Node


# GAME
signal game_updated(game)
signal game_level_completed(level_id, stars)


# LEVEL
signal level_start_request(level_id)

signal level_goal_changed(jumpers_count, jumpers_goal, stars_count)

signal level_started(level_id)
signal level_completed(level_id, stars)


# HOME
signal home_return_request
signal home_returned


# SETTINGS

# SOUND
signal sound_switch_request
signal music_switch_request
