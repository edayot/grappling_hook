schedule function ~/ 1t replace

execute as @a at @s run function ~/player:
    execute if entity @s[predicate=grappling_hook:impl/sneaking] run item modify entity @s grappling_hook:impl/all_grappling_hook {"type": "minecraft:set_item", "item": "minecraft:crossbow"}
    
    execute if predicate {
        "type": "minecraft:entity_properties",
        "entity": "this",
        "predicate": {
            "minecraft:flags": {
                "is_on_ground": false
            }
        }
    } run return run scoreboard players add @s grappling_hook.fall_time 1
    scoreboard players set @s grappling_hook.fall_time 0


execute as @e[type=arrow, tag=grappling_hook.arrow] at @s run function ~/arrow:
    scoreboard players operation #SEARCH_ID grappling_hook.data = @s grappling_hook.data
    
    data modify entity @s life set value -1

    execute on origin run function ~/setup_player:
        tag @s add grappling_hook.me
        data modify storage grappling_hook:temp pos1 set from entity @s Pos
        execute if entity @s[predicate=grappling_hook:impl/sneaking] run function ~/disable_grappling:
            kill @e[predicate=grappling_hook:impl/search_id, type=!player]
    
    tag @s add grappling_hook.arrow.me

    data modify storage grappling_hook:temp pos2 set from entity @s Pos
    function grappling_hook:impl/calc_distance

    execute as @e[type=item_display, tag=grappling_hook.rope, predicate=grappling_hook:impl/search_id] run function ~/update_leash:
        execute at @n[type=minecraft:arrow, tag=grappling_hook.arrow.me] run tp @s ~ ~ ~
        execute at @s facing entity @p[tag=grappling_hook.me] feet run tp @s ~ ~ ~ ~ ~

        data modify entity @s transformation.scale[2] set from storage grappling_hook:temp distance
        data modify entity @s transformation.translation[2] set compute default float (storage grappling_hook:temp distance)/2

    execute 
        unless entity @n[type=item_display, tag=grappling_hook.swinger, predicate=grappling_hook:impl/search_id] 
        if entity @s[tag=grappling_hook.arrow.in_ground]
        run function ~/try_summon_swinger:
            execute if score @p[tag=grappling_hook.me] grappling_hook.fall_time matches ..12 run return fail

            data modify entity @s data.grappling_hook.rope_size set compute default float (
                max(storage grappling_hook:temp distance, 0.1)
            )
            data modify entity @s data.grappling_hook.prev_motion set from storage grappling_hook:temp Motion

            execute at @p[tag=grappling_hook.me] summon item_display run function ~/summon_swinger:
                tag @s add grappling_hook.swinger
                data merge entity @s {teleport_duration:3}
                scoreboard players operation @s grappling_hook.data = #SEARCH_ID grappling_hook.data

                function #bs.hitbox:set_entity {with:{width:0.5, height:1.2, depth:0.5, centered: false}}
                ride @p[tag=grappling_hook.me] mount @s


    execute if entity @n[type=item_display, tag=grappling_hook.swinger, predicate=grappling_hook:impl/search_id] run function ~/update_velocity: 

        data modify storage grappling_hook:temp v set value [0d,0d,0d]
        data modify storage grappling_hook:temp v set from entity @s data.grappling_hook.prev_motion

        data modify storage grappling_hook:temp v[1] set compute default float (storage grappling_hook:temp v[1] + -0.08)

        data modify storage grappling_hook:temp v[0] set compute default float (storage grappling_hook:temp v[0] * 0.98)
        data modify storage grappling_hook:temp v[1] set compute default float (storage grappling_hook:temp v[1] * 0.98)
        data modify storage grappling_hook:temp v[2] set compute default float (storage grappling_hook:temp v[2] * 0.98)

        data modify storage grappling_hook:temp rope_size set from entity @s data.grappling_hook.rope_size

        execute if predicate {
            "type": "minecraft:float_value_check",
            "value": {
                "type": "minecraft:storage",
                "storage": "grappling_hook:temp",
                "path": "distance",
                "fallback": -1
            },
            "test": {
                "min": {
                    "type": "minecraft:storage",
                    "storage": "grappling_hook:temp",
                    "path": "rope_size",
                    "fallback": 0
                }
            }
        } run function ~/pulling:

            data modify storage grappling_hook:temp d set value [0d,0d,0d]
            data modify storage grappling_hook:temp d set from storage grappling_hook:temp pos1
            data modify storage grappling_hook:temp d[0] set compute default float (storage grappling_hook:temp d[0] - storage grappling_hook:temp pos2[0])
            data modify storage grappling_hook:temp d[1] set compute default float (storage grappling_hook:temp d[1] - storage grappling_hook:temp pos2[1])
            data modify storage grappling_hook:temp d[2] set compute default float (storage grappling_hook:temp d[2] - storage grappling_hook:temp pos2[2])
        
            data modify storage grappling_hook:temp n set value [0d,0d,0d]
            data modify storage grappling_hook:temp n set from storage grappling_hook:temp d
            data modify storage grappling_hook:temp n[0] set compute default float (storage grappling_hook:temp n[0])/(storage grappling_hook:temp distance)
            data modify storage grappling_hook:temp n[1] set compute default float (storage grappling_hook:temp n[1])/(storage grappling_hook:temp distance)
            data modify storage grappling_hook:temp n[2] set compute default float (storage grappling_hook:temp n[2])/(storage grappling_hook:temp distance)

            data modify storage grappling_hook:temp vr set value 0
            data modify storage grappling_hook:temp vr set compute default float (
                (storage grappling_hook:temp v[0] * storage grappling_hook:temp n[0]) +
                (storage grappling_hook:temp v[1] * storage grappling_hook:temp n[1]) +
                (storage grappling_hook:temp v[2] * storage grappling_hook:temp n[2])
            )

            execute if predicate {
                "type": "minecraft:float_value_check",
                "value": {
                    "type": "minecraft:storage",
                    "storage": "grappling_hook:temp",
                    "path": "vr",
                    "fallback": -1
                },
                "test": {
                    "min": 0
                }
            } run function ~/pull:
                data modify storage grappling_hook:temp v[0] set compute default float (storage grappling_hook:temp v[0] - storage grappling_hook:temp n[0] * storage grappling_hook:temp vr)
                data modify storage grappling_hook:temp v[1] set compute default float (storage grappling_hook:temp v[1] - storage grappling_hook:temp n[1] * storage grappling_hook:temp vr)
                data modify storage grappling_hook:temp v[2] set compute default float (storage grappling_hook:temp v[2] - storage grappling_hook:temp n[2] * storage grappling_hook:temp vr)

            data modify storage grappling_hook:temp factor set compute default float (
                (storage grappling_hook:temp distance - storage grappling_hook:temp rope_size) * 0.1
            )
            data modify storage grappling_hook:temp v[0] set compute default float (
                storage grappling_hook:temp v[0] - storage grappling_hook:temp n[0] * storage grappling_hook:temp factor
            )
            data modify storage grappling_hook:temp v[1] set compute default float (
                storage grappling_hook:temp v[1] - storage grappling_hook:temp n[1] * storage grappling_hook:temp factor
            )
            data modify storage grappling_hook:temp v[2] set compute default float (
                storage grappling_hook:temp v[2] - storage grappling_hook:temp n[2] * storage grappling_hook:temp factor
            )



        execute 
            as @e[type=item_display, tag=grappling_hook.swinger, predicate=grappling_hook:impl/search_id] 
            run function ~/apply_vel:
                data modify storage grappling_hook:temp p0 set from entity @s Pos
                execute store result score @s bs.vel.x run data get storage grappling_hook:temp v[0] 1000
                execute store result score @s bs.vel.y run data get storage grappling_hook:temp v[1] 1000
                execute store result score @s bs.vel.z run data get storage grappling_hook:temp v[2] 1000
                function #bs.move:apply_vel {scale:0.001,with:{on_collision:"function #bs.move:callback/slide"}}

                data modify storage grappling_hook:temp p1 set from entity @s Pos
                data modify storage grappling_hook:temp v set value [0d,0d,0d]
                data modify storage grappling_hook:temp v[0] set compute default float (storage grappling_hook:temp p1[0] - storage grappling_hook:temp p0[0])
                data modify storage grappling_hook:temp v[1] set compute default float (storage grappling_hook:temp p1[1] - storage grappling_hook:temp p0[1])
                data modify storage grappling_hook:temp v[2] set compute default float (storage grappling_hook:temp p1[2] - storage grappling_hook:temp p0[2])

        # set speed
        data modify entity @s data.grappling_hook.prev_motion set from storage grappling_hook:temp v
        

    
    
    tag @s remove grappling_hook.arrow.me
    execute on origin run tag @s remove grappling_hook.me
