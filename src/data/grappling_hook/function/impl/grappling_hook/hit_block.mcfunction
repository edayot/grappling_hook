


execute store result score #ax grappling_hook.data run data get entity @s Pos[0] 100
execute store result score #ay grappling_hook.data run data get entity @s Pos[1] 100
execute store result score #az grappling_hook.data run data get entity @s Pos[2] 100

scoreboard players operation #power grappling_hook.data = @s grappling_hook.arrow.power


execute 
    on origin 
    run function ./player_motion:
        tag @s remove grappling_hook.player
    

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

        execute if score #abs_dx grappling_hook.data > #max_abs_speed grappling_hook.data run scoreboard players operation #abs_dx grappling_hook.data = #max_abs_speed grappling_hook.data
        execute if score #abs_dy grappling_hook.data > #max_abs_speed grappling_hook.data run scoreboard players operation #abs_dy grappling_hook.data = #max_abs_speed grappling_hook.data
        execute if score #abs_dz grappling_hook.data > #max_abs_speed grappling_hook.data run scoreboard players operation #abs_dz grappling_hook.data = #max_abs_speed grappling_hook.data

        execute if score #dx grappling_hook.data matches ..0 run scoreboard players operation #abs_dx grappling_hook.data *= #-1 grappling_hook.data
        execute if score #dy grappling_hook.data matches ..0 run scoreboard players operation #abs_dy grappling_hook.data *= #-1 grappling_hook.data
        execute if score #dz grappling_hook.data matches ..0 run scoreboard players operation #abs_dz grappling_hook.data *= #-1 grappling_hook.data

        scoreboard players operation #dx grappling_hook.data = #abs_dx grappling_hook.data
        scoreboard players operation #dy grappling_hook.data = #abs_dy grappling_hook.data
        scoreboard players operation #dz grappling_hook.data = #abs_dz grappling_hook.data


        scoreboard players operation $x player_motion.api.launch = #dx grappling_hook.data
        scoreboard players operation $y player_motion.api.launch = #dy grappling_hook.data
        scoreboard players operation $z player_motion.api.launch = #dz grappling_hook.data
        execute at @s run function player_motion:api/launch_xyz

kill @e[limit=1, type=item, distance=..5, nbt={Age: 0s, Item: {id: "minecraft:lead"}}]
scoreboard players operation #temp_id grappling_hook.data = @s grappling_hook.id
execute 
    as @e[type=bat,tag=grappling_hook.bat,distance=..5] 
    if score @s grappling_hook.id = #temp_id grappling_hook.data
    run function ./kill:
        tp ~ -300 ~
        kill @s
kill @s
