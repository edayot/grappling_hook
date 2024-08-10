execute on origin store result score #ax grappling_hook.data run data get entity @s Pos[0] 100
execute on origin store result score #ay grappling_hook.data run data get entity @s Pos[1] 100
execute on origin store result score #az grappling_hook.data run data get entity @s Pos[2] 100


scoreboard players operation #power grappling_hook.data = @s grappling_hook.arrow.power

execute 
    as @n[tag=grappling_hook.victim]
    run function ./apply_victim_motion:
        tag @s remove grappling_hook.victim
        function ./player_motion

