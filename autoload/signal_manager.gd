extends Node

# player related signals
signal player_was_hit(hp_points_to_deduct)
signal player_died
signal player_speed_powered_up
signal player_fired
signal player_hit_with_fist
signal player_equip_weapon(weapon)

# rocket related signals
signal rocket_was_hit(hp_points_to_deduct)

# alien related signals
signal hit_by_player(alien)
signal spawn_alien_wave(strength)

# din related signals
signal din_amount_updated(amount) # to update the ui!

# builder-box related signals
signal bought_item(item)

# general signals
signal update_hud(hud_values_dict)
signal pause_game
