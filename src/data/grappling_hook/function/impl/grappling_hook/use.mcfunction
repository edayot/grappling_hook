advancement revoke @s only grappling_hook:impl/grappling_hook

tag @s add grappling_hook.player.me
execute 
    as @e[type=arrow,tag=grappling_hook.arrow]
    run function ./check_origin:
        scoreboard players set #is_good_arrow grappling_hook.data 0
        execute on origin if entity @s[tag=grappling_hook.player.me] run scoreboard players set #is_good_arrow grappling_hook.data 1
        execute 
            if score #is_good_arrow grappling_hook.data matches 1
            run function ./check_power:
                execute if score @s grappling_hook.arrow.power matches 30.. run function ./hit_block
                execute unless score @s grappling_hook.arrow.power matches 30.. run kill @s

tag @s remove grappling_hook.player.me
