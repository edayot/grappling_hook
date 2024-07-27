schedule function grappling_hook:impl/tick 1t replace



execute
    as @e[tag=grappling_hook.arrow,tag=grappling_hook.arrow.summoned]
    at @s
    run function ~/arrow:
        tag @s remove grappling_hook.arrow.summoned
        scoreboard players operation #temp_id grappling_hook.data = @s grappling_hook.id
        data remove storage grappling_hook:main temp.UUID
        execute on origin run data modify storage grappling_hook:main temp.UUID set from entity @s UUID
        execute
            positioned ~ ~5 ~
            summon bat
            run function ~/bat:
                tag @s add grappling_hook.bat
                data merge entity @s {Invulnerable:true,Silent:true,DeathLootTable:"minecraft:empty"}
                scoreboard players operation @s grappling_hook.id = #temp_id grappling_hook.data
                data modify entity @s leash.UUID set from storage grappling_hook:main temp.UUID
                effect give @s invisibility infinite 1 true


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