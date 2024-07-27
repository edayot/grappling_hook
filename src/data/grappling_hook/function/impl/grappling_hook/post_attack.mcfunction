execute store result score #ax grappling_hook.data run data get entity @s Pos[0] 100
execute store result score #ay grappling_hook.data run data get entity @s Pos[1] 100
execute store result score #az grappling_hook.data run data get entity @s Pos[2] 100



execute 
    on attacker 
    run function ./player_motion
