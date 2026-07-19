execute on origin run tag @s add grappling_hook.me
execute at @s on origin run function #bs.position:get_distance_ata {scale:1000}
scoreboard players operation @s grappling_hook.block_range = $position.get_distance_ata bs.out
execute if score @s grappling_hook.block_range matches ..20 run scoreboard players set @s grappling_hook.data 20
execute on origin run function ~/after_hit:
    tag @s remove grappling_hook.me


tag @s add grappling_hook.arrow.in_ground