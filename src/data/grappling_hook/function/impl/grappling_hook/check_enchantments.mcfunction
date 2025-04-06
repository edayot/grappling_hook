advancement revoke @s only grappling_hook:impl/check_enchantments



data remove storage grappling_hook:main temp.Inventory
data modify storage grappling_hook:main temp.Inventory set from entity @s Inventory

data modify storage grappling_hook:main temp.RealInventory set value []
data modify storage grappling_hook:main temp.RealInventory append from storage grappling_hook:main temp.Inventory[{components:{"minecraft:custom_data":{grappling_hook:1b}}}]
data remove storage grappling_hook:main temp.Inventory


execute if data storage grappling_hook:main temp.RealInventory[0] run function ~/loop



function ~/loop:
    scoreboard players set #glint grappling_hook.data -1
    scoreboard players set #slot grappling_hook.data -1
    execute store result score #slot grappling_hook.data run data get storage grappling_hook:main temp.RealInventory[0].Slot
    execute store result score #glint grappling_hook.data run data get storage grappling_hook:main temp.RealInventory[0].components."minecraft:enchantment_glint_override"

    data remove storage grappling_hook:main temp.RealInventory[0].components."minecraft:enchantments"."grappling_hook:grappling_hook"
    execute 
        summon item_display 
        run function ~/item_display:
            data modify entity @s item set from storage grappling_hook:main temp.RealInventory[0]
            scoreboard players set #has_no_enchantments grappling_hook.data 1
            execute store result score #has_no_enchantments grappling_hook.data if items entity @s contents *[minecraft:enchantments={}]
            kill @s

    execute
        if score #has_no_enchantments grappling_hook.data matches 1
        unless score #glint grappling_hook.data matches 0
        run function ~/remove_glint:
            execute if score #slot grappling_hook.data matches 0..35 run function ~/normal with storage grappling_hook:main temp.RealInventory[0]
            function ~/normal:
                $item modify entity @s container.$(Slot) grappling_hook:impl/remove_glint
            execute if score #slot grappling_hook.data matches -106 run item modify entity @s weapon.offhand grappling_hook:impl/remove_glint
    execute
        if score #has_no_enchantments grappling_hook.data matches 0
        unless score #glint grappling_hook.data matches 1
        run function ~/add_glint:
            execute if score #slot grappling_hook.data matches 0..35 run function ~/normal with storage grappling_hook:main temp.RealInventory[0]
            function ~/normal:
                $item modify entity @s container.$(Slot) grappling_hook:impl/add_glint
            execute if score #slot grappling_hook.data matches -106 run item modify entity @s weapon.offhand grappling_hook:impl/add_glint

    data remove storage grappling_hook:main temp.RealInventory[0]
    execute if data storage grappling_hook:main temp.RealInventory[0] run function ~/
