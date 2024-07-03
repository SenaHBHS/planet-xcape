extends Node

# level related signals
signal level_changed

# player related signals
signal player_was_hit(hp_points_to_deduct)
signal player_hp_points_updated
signal player_died
signal player_speed_powered_up
signal player_health_powered_up
signal player_fired
signal player_hit_with_fist
signal player_equip_weapon(weapon)

# rocket related signals
signal rocket_was_hit(hp_points_to_deduct)
signal rocket_hp_points_updated

# alien related signals
signal hit_by_player(alien)
signal spawn_alien_wave(strength)

# alien waves related signals
signal alien_wave_countdown_updated

# din related signals
signal din_collected # to play the sound
signal din_amount_updated(amount) # to update the ui!

# ui related signals
signal one_second_elapsed
signal set_builder_box_opened(is_open)

# inventory related signals
signal inventory_focus_changed
signal rerender_inventory_bar

# options related signals
signal options_chagned

# saving related signals
signal reset_current_profile
