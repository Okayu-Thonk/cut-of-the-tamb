extends Node

# warning-ignore-all:unused_signal

# Emitted by: ritual.gd
signal ritual_destroyed
# Used For:
# show game over screen in level.gd

# Emitted by: ritual.gd
signal faith_generated(faith)
# Used For:
# generate faith for player.gd

# Emitted by: ritual.gd
signal ritual_coordinate_sent(coord)
# Used For:
# send coordinate to enemy

# Emitted by: enemies 
signal enemy_spawned(type)
# Used For:
# requesting ritual coordinate to level.gd

# Emitted by: enemies 
signal enemy_killed
# Used For:

