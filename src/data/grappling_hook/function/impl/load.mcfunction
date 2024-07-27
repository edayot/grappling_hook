

execute as @a[tag=convention.debug] run function grappling_hook:impl/print_version

scoreboard objectives add grappling_hook.data dummy
scoreboard players set #-1 grappling_hook.data -1
scoreboard players set #2 grappling_hook.data 2

schedule function grappling_hook:impl/tick 1t replace
