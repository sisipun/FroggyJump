class_name EventStorage
extends Node


# GAME
signal game_updated(game)


# LEVEL
signal level_start_request(level_id)

signal level_goal_changed(jumpers_count, jumpers_goal, stars_count)

signal level_started(level_id)
signal level_completed(level_id, stars)
signal level_failed(level_id)


# HOME
signal home_return_request
signal home_returned


# SETTINGS
signal settings_show_request

# SOUND
signal sound_switch_request
signal sound_switched(value)
signal music_switch_request
signal music_switched(value)
