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
        scoreboard players operation #temp_id grappling_hook.data = @s grappling_hook.id
        data remove storage grappling_hook:main temp.UUID
        data modify entity @s damage set value 0.01

        execute
            on origin
            run function ./init_player:
                data modify storage grappling_hook:main temp.UUID set from entity @s UUID
                execute store result score #level grappling_hook.data run data get entity @s Inventory[{Slot:-106b}].components."minecraft:enchantments".levels."grappling_hook:grappling_hook"
                execute store result score #level grappling_hook.data run data get entity @s SelectedItem.components."minecraft:enchantments".levels."grappling_hook:grappling_hook"
                scoreboard players operation @s grappling_hook.id = #temp_id grappling_hook.data
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
                    run function grappling_hook:impl/grappling_hook/kill
        execute
            on origin
            run tag @s remove grappling_hook.player.me
        tag @s remove grappling_hook.arrow.summoned

