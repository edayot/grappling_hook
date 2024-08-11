schedule function grappling_hook:impl/tick 1t replace


execute
    as @a[scores={grappling_hook.launch.delay=1..}]
    run function ./delayed_launch:
        execute 
            if score @s grappling_hook.launch.delay matches 1
            run function ./launch:
                scoreboard players operation $x player_motion.api.launch = @s grappling_hook.launch.x
                scoreboard players operation $y player_motion.api.launch = @s grappling_hook.launch.y
                scoreboard players operation $z player_motion.api.launch = @s grappling_hook.launch.z
                function player_motion:api/launch_xyz
        scoreboard players remove @s grappling_hook.launch.delay 1
        



execute
    as @e[tag=grappling_hook.arrow,tag=grappling_hook.arrow.summoned]
    at @s
    run function ~/arrow:
        data remove storage grappling_hook:main temp.UUID
        data modify entity @s damage set value 0.01

        execute
            on origin
            run function ./init_player:
                data modify storage grappling_hook:main temp.UUID set from entity @s UUID
                execute 
                    if data entity @s Inventory[{Slot:-106b}].components."minecraft:enchantments".levels."grappling_hook:grappling_hook"
                    store result score #level grappling_hook.data 
                    run data get entity @s Inventory[{Slot:-106b}].components."minecraft:enchantments".levels."grappling_hook:grappling_hook"
                execute 
                    if data entity @s SelectedItem.components."minecraft:enchantments".levels."grappling_hook:grappling_hook"
                    store result score #level grappling_hook.data 
                    run data get entity @s SelectedItem.components."minecraft:enchantments".levels."grappling_hook:grappling_hook"
                tag @s add grappling_hook.player.me
        scoreboard players operation @s grappling_hook.arrow.power = #level grappling_hook.data
        #kill other arrows from the same player
        execute
            as @e[tag=grappling_hook.arrow,tag=!grappling_hook.arrow.summoned]
            run function ~/kill_arrow:
                scoreboard players set #to_kill grappling_hook.data 0
                execute on origin if entity @s[tag=grappling_hook.player.me] run scoreboard players set #to_kill grappling_hook.data 1
                execute 
                    if score #to_kill grappling_hook.data matches 1 
                    run kill @s
        execute
            on origin
            run tag @s remove grappling_hook.player.me
        tag @s remove grappling_hook.arrow.summoned


scoreboard players add @e[tag=grappling_hook.arrow] grappling_hook.data 1
time_to_kill_in_second = 10
time_to_kill = time_to_kill_in_second * 20
raw f'kill @e[tag=grappling_hook.arrow,scores={{grappling_hook.data={time_to_kill}..}}]'