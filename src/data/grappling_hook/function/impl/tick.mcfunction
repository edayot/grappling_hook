schedule function ~/ 1t replace

execute as @e[type=arrow, tag=grappling_hook.tick_arrow] at @s run function ~/arrow:
    execute on origin run tag @s add grappling_hook.me
    tag @s add grappling_hook.arrow.me

    scoreboard players operation #SEARCH_ID grappling_hook.data = @s grappling_hook.data
    execute as @e[type=item_display, tag=grappling_hook.item_display, predicate=grappling_hook:impl/search_id] run function ~/update_leash:
        execute at @n[type=minecraft:arrow, tag=grappling_hook.arrow.me] run tp @s ~ ~ ~
        execute at @s facing entity @p[tag=grappling_hook.me] feet run tp @s ~ ~ ~ ~ ~

    tag @s remove grappling_hook.arrow.me
    execute on origin run tag @s remove grappling_hook.me