schedule function ~/ 1t replace

execute as @e[type=arrow, tag=grappling_hook.arrow] at @s run function ~/arrow:

    data modify entity @s life set value -1

    execute on origin run tag @s add grappling_hook.me
    tag @s add grappling_hook.arrow.me

    scoreboard players operation #SEARCH_ID grappling_hook.data = @s grappling_hook.data
    execute as @e[type=item_display, tag=grappling_hook.rope, predicate=grappling_hook:impl/search_id] run function ~/update_leash:
        execute at @n[type=minecraft:arrow, tag=grappling_hook.arrow.me] run tp @s ~ ~ ~
        execute at @s facing entity @p[tag=grappling_hook.me] feet run tp @s ~ ~ ~ ~ ~
        execute at @p[tag=grappling_hook.me] run function #bs.position:get_distance_ata {scale:1000}
        execute store result entity @s transformation.scale[2] float 0.001 run scoreboard players get $position.get_distance_ata bs.out
        execute store result entity @s transformation.translation[2] float 0.0005 run scoreboard players get $position.get_distance_ata bs.out


    execute if entity @s[tag=grappling_hook.arrow.in_ground] run function ~/move_player:
        execute if score @s grappling_hook.block_range matches ..20 run return fail
        execute on origin run function #bs.position:get_distance_ata {scale:1000}
        scoreboard players operation #diff grappling_hook.data = $position.get_distance_ata bs.out
        scoreboard players operation #diff grappling_hook.data -= @s grappling_hook.block_range
        execute store result storage grappling_hook:main launch.diff double 0.001 run scoreboard players get #diff grappling_hook.data


        execute if entity @p[tag=grappling_hook.me, predicate=grappling_hook:impl/sneaking] run function ~/disable_grappling:
            kill @e[predicate=grappling_hook:impl/search_id, type=!player]


        execute if score #diff grappling_hook.data matches ..400 run return run function ~/disable_rope:
            tag @p[tag=grappling_hook.me] remove grappling_hook.rope_attached
            kill @e[tag=grappling_hook.swinger, predicate=grappling_hook:impl/search_id]
        
        
        execute as @p[tag=grappling_hook.me,tag=!grappling_hook.rope_attached] at @s run function ~/attach_rope:
            tag @s add grappling_hook.rope_attached
            execute positioned ~ ~0.5 ~ summon item_display run function ~/swing:
                tag @s add grappling_hook.swinger
                data merge entity @s {teleport_duration:3}
                scoreboard players operation @s grappling_hook.data = #SEARCH_ID grappling_hook.data
                # TODO: copier la vitesse du joueur dans le swinger (au minimum la norme)

        execute 
            at @n[tag=grappling_hook.swinger, predicate=grappling_hook:impl/search_id] 
            run function #bs.position:get_relative_ata {scale:1000}
        
        
            
        execute 
            as @n[tag=grappling_hook.swinger, predicate=grappling_hook:impl/search_id] 
            at @s 
            run function ~/move_swinger:
                scoreboard players set @s bs.vel.x 100
                ride @p[tag=grappling_hook.me] mount @s
                function #bs.move:apply_vel {scale:0.001,with:{on_collision:"function #bs.move:callback/slide"}}


        


    tag @s remove grappling_hook.arrow.me
    execute on origin run tag @s remove grappling_hook.me
