schedule function ~/ 1t replace

execute 
    as @e[type=item_display, tag=grappling_hook.rope] 
    run function ~/check:
        scoreboard players operation #SEARCH_ID grappling_hook.data = @s grappling_hook.data
        scoreboard players set #temp grappling_hook.data 0
        execute as @e[type=arrow, tag=grappling_hook.arrow, predicate=grappling_hook:impl/search_id] run scoreboard players set #temp grappling_hook.data 1
        
        execute if score #temp grappling_hook.data matches 0 run kill @s

execute 
    as @e[type=item_display, tag=grappling_hook.swinger] 
    run function ~/check