
scoreboard players operation #SEARCH_ID grappling_hook.data = @s grappling_hook.data

execute on origin run function ~/setup:
    tag @s add grappling_hook.me
    data modify storage grappling_hook:temp pos1 set from entity @s Pos

    data modify storage grappling_hook:temp Motion set from entity @s Motion

    execute at @s summon item_display run function ~/summon_swinger:
        tag @s add grappling_hook.swinger
        data merge entity @s {teleport_duration:3}
        scoreboard players operation @s grappling_hook.data = #SEARCH_ID grappling_hook.data

        function #bs.hitbox:set_entity {with:{width:0.5, height:1.2, depth:0.5, centered: false}}
        ride @p[tag=grappling_hook.me] mount @s


data modify storage grappling_hook:temp pos2 set from entity @s Pos

function grappling_hook:impl/calc_distance
data modify entity @s data.grappling_hook.rope_size set compute default float (
    max(storage grappling_hook:temp distance, 0.1)
)
data modify entity @s data.grappling_hook.prev_motion set from storage grappling_hook:temp Motion

execute on origin run function ~/after_hit:
    tag @s remove grappling_hook.me


tag @s add grappling_hook.arrow.in_ground