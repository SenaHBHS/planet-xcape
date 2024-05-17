extends Node

# player related signals
signal player_was_hit(hp_points_to_deduct)
signal player_died
signal player_powered_up(power_up)
signal player_fired
signal player_equip_weapon(weapon)

# alien related signals
signal hit_by_player(alien)
signal spawn_alien_wave(strength)

# din related signals
signal update_din_amount(amount) # to update the hud!

# builder-box related signals
signal bought_item(item)

# general signals
signal update_hud(hud_values_dict)
signal pause_game