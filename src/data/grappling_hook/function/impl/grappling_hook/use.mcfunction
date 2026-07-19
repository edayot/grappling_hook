advancement revoke @s only grappling_hook:impl/grappling_hook
tag @s add grappling_hook.me

scoreboard players operation #SEARCH_ID grappling_hook.data = @s grappling_hook.data
kill @e[predicate=grappling_hook:impl/search_id, type=!player]
tag @s remove grappling_hook.rope_attached

scoreboard players add #GLOBAL grappling_hook.data 1
scoreboard players operation @s grappling_hook.data = #GLOBAL grappling_hook.data

execute as @e[type=arrow, distance=..5, tag=!grappling_hook.arrow.already] run function ~/test_origin:
    tag @s add grappling_hook.arrow.already
    scoreboard players set #temp grappling_hook.data 0
    execute on origin if entity @s[tag=grappling_hook.me] run scoreboard players set #temp grappling_hook.data 1
    execute if score #temp grappling_hook.data matches 0 run return fail

    scoreboard players operation @s grappling_hook.data = #GLOBAL grappling_hook.data

    data modify entity @s pickup set value 0b
    tag @s add grappling_hook.arrow
    tag @s add grappling_hook.arrow.me
    execute positioned ~ ~-16 ~ summon item_display run function ~/execute_summon:
        scoreboard players operation @s grappling_hook.data = #GLOBAL grappling_hook.data
        tag @s add grappling_hook.rope
        data merge entity @s {
            item:{id:stone}, 
            interpolation_duration:2, 
            teleport_duration:2, 
            transformation:{
                scale: [0.1, 0.1, 200],
                translation: [0, 0, 0],
            }
        }
        execute at @n[type=minecraft:arrow, tag=grappling_hook.arrow.me] run tp @s ~ ~ ~
    tag @s remove grappling_hook.arrow.me

tag @s remove grappling_hook.me
