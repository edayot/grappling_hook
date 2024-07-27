

execute as @a[tag=convention.debug] run function grappling_hook:impl/print_version

scoreboard objectives add grappling_hook.data dummy
scoreboard objectives add grappling_hook.id dummy

scoreboard players set #-1 grappling_hook.data -1
scoreboard players set #2 grappling_hook.data 2

# config
scoreboard players set #power grappling_hook.data 15
scoreboard players set #max_abs_speed grappling_hook.data 100000

# variables
scoreboard players set #GLOBAL_ID grappling_hook.data 0

schedule function grappling_hook:impl/tick 1t replace
