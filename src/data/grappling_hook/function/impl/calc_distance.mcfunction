data modify storage grappling_hook:temp distance set compute default float (
    sqrt(
        (storage grappling_hook:temp pos1[0] - storage grappling_hook:temp pos2[0])**2 +
        (storage grappling_hook:temp pos1[1] - storage grappling_hook:temp pos2[1])**2 +
        (storage grappling_hook:temp pos1[2] - storage grappling_hook:temp pos2[2])**2
    )
)
