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

        execute 
            if entity @p[tag=grappling_hook.me, predicate=grappling_hook:impl/forward] 
            as @n[tag=grappling_hook.swinger, predicate=grappling_hook:impl/search_id] 
            run function ~/go_up:
                scoreboard players set @s bs.vel.x 0
                scoreboard players set @s bs.vel.y 100
                scoreboard players set @s bs.vel.z 0
                function #bs.move:apply_vel {scale:0.001,with:{on_collision:"function #bs.move:callback/slide"}}
                function #bs.position:get_distance_ata {scale:1000}
                scoreboard players operation @n[tag=grappling_hook.arrow.me] grappling_hook.block_range = $position.get_distance_ata bs.out
        execute 
            if entity @p[tag=grappling_hook.me, predicate=grappling_hook:impl/backward] 
            as @n[tag=grappling_hook.swinger, predicate=grappling_hook:impl/search_id] 
            run function ~/go_down:
                scoreboard players set @s bs.vel.x 0
                scoreboard players set @s bs.vel.y -100
                scoreboard players set @s bs.vel.z 0
                function #bs.move:apply_vel {scale:0.001,with:{on_collision:"function #bs.move:callback/slide"}}
                function #bs.position:get_distance_ata {scale:1000}
                scoreboard players operation @n[tag=grappling_hook.arrow.me] grappling_hook.block_range = $position.get_distance_ata bs.out        

        execute on origin run function #bs.position:get_distance_ata {scale:1000}
        scoreboard players operation #diff grappling_hook.data = $position.get_distance_ata bs.out
        scoreboard players operation #diff grappling_hook.data -= @s grappling_hook.block_range
        execute store result storage grappling_hook:main launch.diff double 0.001 run scoreboard players get #diff grappling_hook.data


        execute if entity @p[tag=grappling_hook.me, predicate=grappling_hook:impl/sneaking] run function ~/disable_grappling:
            kill @e[predicate=grappling_hook:impl/search_id, type=!player]


        execute if score #diff grappling_hook.data matches ..400 unless entity @p[tag=grappling_hook.me,tag=grappling_hook.rope_attached] run return fail
        
        
        execute as @p[tag=grappling_hook.me,tag=!grappling_hook.rope_attached] at @s run function ~/attach_rope:
            tag @s add grappling_hook.rope_attached
            execute positioned ~ ~0.5 ~ summon item_display run function ~/swing:
                tag @s add grappling_hook.swinger
                data merge entity @s {teleport_duration:3}
                scoreboard players operation @s grappling_hook.data = #SEARCH_ID grappling_hook.data
                # TODO: copier la vitesse du joueur dans le swinger (au minimum la norme)
                execute store result score @s grappling_hook.speed.x run data get entity @p[tag=grappling_hook.me] Motion[0] 1000
                execute store result score @s grappling_hook.speed.y run data get entity @p[tag=grappling_hook.me] Motion[1] 1000
                execute store result score @s grappling_hook.speed.z run data get entity @p[tag=grappling_hook.me] Motion[2] 1000

                function #bs.hitbox:set_entity {with:{width:0.5, height:1.2, depth:0.5, centered: false}}

            
        execute 
            as @n[tag=grappling_hook.swinger, predicate=grappling_hook:impl/search_id] 
            at @s 
            run function ~/move_swinger:
                ride @p[tag=grappling_hook.me] mount @s
# here update velocity @s grappling_hook.speed.[xyz]
                execute at @e[type=arrow, tag=grappling_hook.arrow.me] run function #bs.position:get_relative_ata {scale:1000}

                # Constantes (scale 1000) : SCALE=1000, DAMPING=0.99
                scoreboard players set #SCALE grappling_hook.data 1000
                scoreboard players set #DAMPING grappling_hook.data 990

                # v_free = v_old * damping (+ gravite sur Y)
                scoreboard players operation #fvx grappling_hook.data = @s grappling_hook.speed.x
                scoreboard players operation #fvx grappling_hook.data *= #DAMPING grappling_hook.data
                scoreboard players operation #fvx grappling_hook.data /= #SCALE grappling_hook.data

                scoreboard players operation #fvy grappling_hook.data = @s grappling_hook.speed.y
                scoreboard players operation #fvy grappling_hook.data *= #DAMPING grappling_hook.data
                scoreboard players operation #fvy grappling_hook.data /= #SCALE grappling_hook.data
                scoreboard players remove #fvy grappling_hook.data 80

                scoreboard players operation #fvz grappling_hook.data = @s grappling_hook.speed.z
                scoreboard players operation #fvz grappling_hook.data *= #DAMPING grappling_hook.data
                scoreboard players operation #fvz grappling_hook.data /= #SCALE grappling_hook.data

                # Produit scalaire r . v_free (divise terme par terme, anti-overflow)
                scoreboard players operation #t1 grappling_hook.data = @s bs.pos.x
                scoreboard players operation #t1 grappling_hook.data *= #fvx grappling_hook.data
                scoreboard players operation #t1 grappling_hook.data /= #SCALE grappling_hook.data

                scoreboard players operation #t2 grappling_hook.data = @s bs.pos.y
                scoreboard players operation #t2 grappling_hook.data *= #fvy grappling_hook.data
                scoreboard players operation #t2 grappling_hook.data /= #SCALE grappling_hook.data

                scoreboard players operation #t3 grappling_hook.data = @s bs.pos.z
                scoreboard players operation #t3 grappling_hook.data *= #fvz grappling_hook.data
                scoreboard players operation #t3 grappling_hook.data /= #SCALE grappling_hook.data

                scoreboard players operation #dot grappling_hook.data = #t1 grappling_hook.data
                scoreboard players operation #dot grappling_hook.data += #t2 grappling_hook.data
                scoreboard players operation #dot grappling_hook.data += #t3 grappling_hook.data

                # |v_old|^2 (vitesse AVANT amortissement)
                scoreboard players operation #v1 grappling_hook.data = @s grappling_hook.speed.x
                scoreboard players operation #v1 grappling_hook.data *= @s grappling_hook.speed.x
                scoreboard players operation #v1 grappling_hook.data /= #SCALE grappling_hook.data

                scoreboard players operation #v2 grappling_hook.data = @s grappling_hook.speed.y
                scoreboard players operation #v2 grappling_hook.data *= @s grappling_hook.speed.y
                scoreboard players operation #v2 grappling_hook.data /= #SCALE grappling_hook.data

                scoreboard players operation #v3 grappling_hook.data = @s grappling_hook.speed.z
                scoreboard players operation #v3 grappling_hook.data *= @s grappling_hook.speed.z
                scoreboard players operation #v3 grappling_hook.data /= #SCALE grappling_hook.data

                scoreboard players operation #vsq grappling_hook.data = #v1 grappling_hook.data
                scoreboard players operation #vsq grappling_hook.data += #v2 grappling_hook.data
                scoreboard players operation #vsq grappling_hook.data += #v3 grappling_hook.data

                # tension/m = (r.v_free + |v_old|^2) * SCALE / L
                scoreboard players operation #sum grappling_hook.data = #dot grappling_hook.data
                scoreboard players operation #sum grappling_hook.data += #vsq grappling_hook.data
                scoreboard players operation #sum grappling_hook.data *= #SCALE grappling_hook.data
                scoreboard players operation #sum grappling_hook.data /= @n[tag=grappling_hook.arrow.me] grappling_hook.block_range

                # correction = (tension/m) * r / L, axe par axe
                scoreboard players operation #cx grappling_hook.data = #sum grappling_hook.data
                scoreboard players operation #cx grappling_hook.data *= @s bs.pos.x
                scoreboard players operation #cx grappling_hook.data /= @n[tag=grappling_hook.arrow.me] grappling_hook.block_range

                scoreboard players operation #cy grappling_hook.data = #sum grappling_hook.data
                scoreboard players operation #cy grappling_hook.data *= @s bs.pos.y
                scoreboard players operation #cy grappling_hook.data /= @n[tag=grappling_hook.arrow.me] grappling_hook.block_range

                scoreboard players operation #cz grappling_hook.data = #sum grappling_hook.data
                scoreboard players operation #cz grappling_hook.data *= @s bs.pos.z
                scoreboard players operation #cz grappling_hook.data /= @n[tag=grappling_hook.arrow.me] grappling_hook.block_range

                # Vitesse finale = v_free - correction
                scoreboard players operation @s grappling_hook.speed.x = #fvx grappling_hook.data
                scoreboard players operation @s grappling_hook.speed.x -= #cx grappling_hook.data

                scoreboard players operation @s grappling_hook.speed.y = #fvy grappling_hook.data
                scoreboard players operation @s grappling_hook.speed.y -= #cy grappling_hook.data

                scoreboard players operation @s grappling_hook.speed.z = #fvz grappling_hook.data
                scoreboard players operation @s grappling_hook.speed.z -= #cz grappling_hook.data



                scoreboard players operation @s bs.vel.x = @s grappling_hook.speed.x
                scoreboard players operation @s bs.vel.y = @s grappling_hook.speed.y
                scoreboard players operation @s bs.vel.z = @s grappling_hook.speed.z
                function #bs.move:apply_vel {scale:0.001,with:{on_collision:"function #bs.move:callback/slide"}}


        


    tag @s remove grappling_hook.arrow.me
    execute on origin run tag @s remove grappling_hook.me
