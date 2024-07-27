schedule function grappling_hook:impl/tick 1t replace



execute
    as @e[tag=grappling_hook.arrow,tag=grappling_hook.arrow.summoned]
    at @s
    run function ~/arrow:
        scoreboard players operation #temp_id grappling_hook.data = @s grappling_hook.id
        data remove storage grappling_hook:main temp.UUID

        execute
            on origin
            run function ./init_player:
                data modify storage grappling_hook:main temp.UUID set from entity @s UUID
                execute store result score #level grappling_hook.data run data get entity @s Inventory[{Slot:-106b}].components."minecraft:enchantments".levels."grappling_hook:impl/grappling_hook"
                execute store result score #level grappling_hook.data run data get entity @s SelectedItem.components."minecraft:enchantments".levels."grappling_hook:impl/grappling_hook"
                scoreboard players operation @s grappling_hook.id = #temp_id grappling_hook.data
                tag @s add grappling_hook.player
                tag @s add grappling_hook.player.me
        scoreboard players operation @s grappling_hook.arrow.power = #level grappling_hook.data
        execute
            positioned ~ ~5 ~
            summon bat
            run function ~/bat:
                tag @s add grappling_hook.bat
                data merge entity @s {Invulnerable:true,Silent:true,DeathLootTable:"minecraft:empty"}
                scoreboard players operation @s grappling_hook.id = #temp_id grappling_hook.data
                data modify entity @s leash.UUID set from storage grappling_hook:main temp.UUID
                effect give @s invisibility infinite 1 true
            
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


execute
    as @e[tag=grappling_hook.arrow]
    at @s
    run function ~/tp_bat:
        scoreboard players operation #temp_id grappling_hook.data = @s grappling_hook.id
        data remove storage grappling_hook:main temp.UUID
        execute on origin run data modify storage grappling_hook:main temp.UUID set from entity @s UUID
        execute 
            as @e[type=bat,tag=grappling_hook.bat,distance=..5] 
            if score @s grappling_hook.id = #temp_id grappling_hook.data
            run function ~/tp_bat_to_arrow:
                tp ~ ~ ~
                execute 
                    unless data entity @s leash.UUID run function ./releash:
                        kill @e[limit=1, type=item, distance=..5, nbt={Age: 0s, Item: {id: "minecraft:lead"}}]
                        data modify entity @s leash.UUID set from storage grappling_hook:main temp.UUID