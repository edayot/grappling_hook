


execute store result score #ax grappling_hook.data run data get entity @s Pos[0] 100
execute store result score #ay grappling_hook.data run data get entity @s Pos[1] 100
execute store result score #az grappling_hook.data run data get entity @s Pos[2] 100

scoreboard players operation #power grappling_hook.data = @s grappling_hook.arrow.power


execute 
    on origin 
    if entity @s[distance=..200]
    run function ./player_motion:   
        execute if entity @s[type=minecraft:player,nbt={FallFlying:1b}] run return fail

        scoreboard players operation #current_max_abs_speed grappling_hook.data = #max_abs_speed grappling_hook.data
        execute if score #power grappling_hook.data matches ..30 run scoreboard players operation #current_max_abs_speed grappling_hook.data /= #2 grappling_hook.data

        execute store result score #px grappling_hook.data run data get entity @s Pos[0] 100
        execute store result score #py grappling_hook.data run data get entity @s Pos[1] 100
        execute store result score #pz grappling_hook.data run data get entity @s Pos[2] 100

        scoreboard players operation #dx grappling_hook.data = #ax grappling_hook.data
        scoreboard players operation #dy grappling_hook.data = #ay grappling_hook.data
        scoreboard players operation #dz grappling_hook.data = #az grappling_hook.data

        scoreboard players operation #dx grappling_hook.data -= #px grappling_hook.data
        scoreboard players operation #dy grappling_hook.data -= #py grappling_hook.data
        scoreboard players operation #dz grappling_hook.data -= #pz grappling_hook.data

        scoreboard players operation #dx grappling_hook.data *= #power grappling_hook.data
        scoreboard players operation #dy grappling_hook.data *= #power grappling_hook.data
        scoreboard players operation #dz grappling_hook.data *= #power grappling_hook.data

        scoreboard players operation #dy grappling_hook.data /= #2 grappling_hook.data
        execute if score #dy grappling_hook.data matches ..1000 run scoreboard players set #dy grappling_hook.data 1000
        scoreboard players add #dy grappling_hook.data 8000

        scoreboard players operation #abs_dx grappling_hook.data = #dx grappling_hook.data
        scoreboard players operation #abs_dy grappling_hook.data = #dy grappling_hook.data
        scoreboard players operation #abs_dz grappling_hook.data = #dz grappling_hook.data

        execute if score #dx grappling_hook.data matches ..0 run scoreboard players operation #abs_dx grappling_hook.data *= #-1 grappling_hook.data
        execute if score #dy grappling_hook.data matches ..0 run scoreboard players operation #abs_dy grappling_hook.data *= #-1 grappling_hook.data
        execute if score #dz grappling_hook.data matches ..0 run scoreboard players operation #abs_dz grappling_hook.data *= #-1 grappling_hook.data

        execute if score #abs_dx grappling_hook.data > #current_max_abs_speed grappling_hook.data run scoreboard players operation #abs_dx grappling_hook.data = #current_max_abs_speed grappling_hook.data
        execute if score #abs_dy grappling_hook.data > #current_max_abs_speed grappling_hook.data run scoreboard players operation #abs_dy grappling_hook.data = #current_max_abs_speed grappling_hook.data
        execute if score #abs_dz grappling_hook.data > #current_max_abs_speed grappling_hook.data run scoreboard players operation #abs_dz grappling_hook.data = #current_max_abs_speed grappling_hook.data

        execute if score #dx grappling_hook.data matches ..0 run scoreboard players operation #abs_dx grappling_hook.data *= #-1 grappling_hook.data
        execute if score #dy grappling_hook.data matches ..0 run scoreboard players operation #abs_dy grappling_hook.data *= #-1 grappling_hook.data
        execute if score #dz grappling_hook.data matches ..0 run scoreboard players operation #abs_dz grappling_hook.data *= #-1 grappling_hook.data

        scoreboard players operation #dx grappling_hook.data = #abs_dx grappling_hook.data
        scoreboard players operation #dy grappling_hook.data = #abs_dy grappling_hook.data
        scoreboard players operation #dz grappling_hook.data = #abs_dz grappling_hook.data


        scoreboard players set @s grappling_hook.launch.delay 1
        scoreboard players operation @s grappling_hook.launch.x = #dx grappling_hook.data
        scoreboard players operation @s grappling_hook.launch.y = #dy grappling_hook.data
        scoreboard players operation @s grappling_hook.launch.z = #dz grappling_hook.data
        execute 
            unless entity @s[type=player] at @s run function ./merge_motion:
                data modify storage grappling_hook:main temp.Motion set value [0.0d,0.0d,0.0d]
                execute store result storage grappling_hook:main temp.Motion[0] double 0.0001 run scoreboard players get #dx grappling_hook.data
                execute store result storage grappling_hook:main temp.Motion[1] double 0.0001 run scoreboard players get #dy grappling_hook.data
                execute store result storage grappling_hook:main temp.Motion[2] double 0.0001 run scoreboard players get #dz grappling_hook.data
                data modify entity @s Motion set from storage grappling_hook:main temp.Motion

kill @s
