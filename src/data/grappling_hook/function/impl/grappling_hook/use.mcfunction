advancement revoke @s only grappling_hook:impl/grappling_hook

execute 
    if entity @s[tag=grappling_hook.player] 
    run function ~/fast_use:
        scoreboard players operation #temp_id grappling_hook.data = @s grappling_hook.id
        execute 
            as @e[type=arrow,tag=grappling_hook.arrow]
            if score @s grappling_hook.id = #temp_id grappling_hook.data
            at @s
            run function ./hit_block
