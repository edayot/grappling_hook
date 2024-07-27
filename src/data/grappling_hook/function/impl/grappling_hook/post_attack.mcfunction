execute store result score #ax grappling_hook.data run data get entity @s Pos[0] 100
execute store result score #ay grappling_hook.data run data get entity @s Pos[1] 100
execute store result score #az grappling_hook.data run data get entity @s Pos[2] 100


scoreboard players operation #power grappling_hook.data = @s grappling_hook.arrow.power

execute 
    on origin 
    run function ./player_motion



scoreboard players operation #temp_id grappling_hook.data = @s grappling_hook.id
execute 
    as @e[type=bat,tag=grappling_hook.bat,distance=..5] 
    if score @s grappling_hook.id = #temp_id grappling_hook.data
    run function ./kill