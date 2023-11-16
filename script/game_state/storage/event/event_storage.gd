class_name EventStorage
extends Node


# GAME
signal game_updated(game)
signal game_stars_updated(level_id, score)


# LEVEL
signal level_start_request(level_id)

signal level_started(level_id)
signal level_completed(level_id, stars)


# HOME
signal home_return_request
