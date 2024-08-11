
advancement revoke @a only grappling_hook:impl/check_enchantments
advancement revoke @a only grappling_hook:impl/grappling_hook
advancement revoke @a only grappling_hook:impl/replace_guide



execute as @a[tag=convention.debug] run function grappling_hook:impl/print_version

scoreboard objectives add grappling_hook.data dummy
scoreboard objectives add grappling_hook.arrow.power dummy

scoreboard objectives add grappling_hook.launch.delay dummy
scoreboard objectives add grappling_hook.launch.x dummy
scoreboard objectives add grappling_hook.launch.y dummy
scoreboard objectives add grappling_hook.launch.z dummy


scoreboard players set #-1 grappling_hook.data -1
scoreboard players set #2 grappling_hook.data 2

# config
scoreboard players set #max_abs_speed grappling_hook.data 100000


schedule function grappling_hook:impl/tick 1t replace


major, minor, patch = ctx.project_version.split('.')
data modify storage grappling_hook:main version set value {"major": int(major), "minor": int(minor), "patch": int(patch)}
