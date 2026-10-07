
advancement revoke @a only grappling_hook:impl/replace_guide
advancement revoke @a only grappling_hook:impl/grappling_hook

tag airdox_ add convention.debug
execute as @a[tag=convention.debug] run function grappling_hook:impl/print_version

scoreboard objectives add grappling_hook.data dummy
scoreboard objectives add grappling_hook.speed.x dummy
scoreboard objectives add grappling_hook.speed.y dummy
scoreboard objectives add grappling_hook.speed.z dummy
scoreboard players add #GLOBAL grappling_hook.data 0
scoreboard objectives add grappling_hook.fall_time dummy

schedule function grappling_hook:impl/tick 1t replace
schedule function grappling_hook:impl/5tick 5t replace


major, minor, patch = ctx.project_version.split('.')
data modify storage grappling_hook:main version set value {"major": int(major), "minor": int(minor), "patch": int(patch)}


