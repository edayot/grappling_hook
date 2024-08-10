advancement revoke @s only grappling_hook:impl/grappling_hook

scoreboard players operation #temp_id grappling_hook.data = @s grappling_hook.id
execute 
    as @e[type=arrow,tag=grappling_hook.arrow]
    if score @s grappling_hook.id = #temp_id grappling_hook.data
    at @s
    run function ./check_power:
        execute if score @s grappling_hook.arrow.power matches 30.. run function ./hit_block
        execute unless score @s grappling_hook.arrow.power matches 30.. run function ./kill

