from beet import Context, Language
from simple_item_plugin.utils import NAMESPACE, Lang, export_translated_string
from simple_item_plugin.item import Item, ItemGroup
from simple_item_plugin.crafting import ShapedRecipe, VanillaItem, ExternalItem
import json


def roman(num: int) -> str:
    chlist = "VXLCDM"
    rev = [int(ch) for ch in reversed(str(num))]
    chlist = ["I"] + [chlist[i % len(chlist)] + "\u0304" * (i // len(chlist))
                    for i in range(0, len(rev) * 2)]

    def period(p: int, ten: str, five: str, one: str) -> str:
        if p == 9:
            return one + ten
        elif p >= 5:
            return five + one * (p - 5)
        elif p == 4:
            return one + five
        else:
            return one * p

    return "".join(reversed([period(rev[i], chlist[i * 2 + 2], chlist[i * 2 + 1], chlist[i * 2])
                            for i in range(0, len(rev))]))

def all_roman(ctx: Context):
    if "minecraft:en_us" not in ctx.assets.languages:
        ctx.assets.languages["minecraft:en_us"] = Language()
    for i in range(2,1001):
        roman_number = roman(i)
        ctx.assets.languages["minecraft:en_us"].data[f"potion.potency.{i}"] = roman_number
        ctx.assets.languages["minecraft:en_us"].data[f"enchantment.level.{i}"] = roman_number


def beet_default(ctx: Context):
    ctx.require(all_roman)
    export_translated_string(ctx, ("grappling_hook.enchantement.description", {Lang.en_us: "Power :", Lang.fr_fr: "Puissance :"}))
    export_translated_string(ctx, (f"{NAMESPACE}.guide.first_page", {
        Lang.en_us: "This guide will show you how to craft a grappling hook (they are used like a crossbow).\n\nHere are all the crafts of the datapack :",
        Lang.fr_fr: "Ce guide va vous montrer comment fabriquer un grappin (ils sont utilisés comme des arbalètes).\n\nVoici tout les crafts du datapack :"
    }))
    grappling_hook = Item(
        id="grappling_hook",
        base_item="minecraft:crossbow",
        item_name=(
            f"{NAMESPACE}.item.grappling_hook",
            {Lang.en_us: "Grappling hook"},
        ),
        components_extra={
            "minecraft:enchantments": {
                "grappling_hook:grappling_hook": 1
            },
            "minecraft:enchantment_glint_override": False,
            "minecraft:max_damage": 60,
            "minecraft:custom_data": "{grappling_hook:1b}",
            "special:item_modifier": "grappling_hook:impl/add_versionning",
        },
        guide_description=(f"{NAMESPACE}.guide.basic", {
            Lang.en_us: "It is the most basic grapplign hook, checkout upgrades !",
            Lang.fr_fr: "C'est le grappin le plus basique, regardez les améliorations !"
        })
    ).export(ctx)

    guide = Item(
        id="guide",
        base_item="minecraft:written_book",
        item_name=(
            f"{NAMESPACE}.item.guide",
            {Lang.en_us: "Guide", Lang.fr_fr: "Guide"},
        ),
        components_extra={
            "minecraft:enchantment_glint_override": False,
            "special:item_modifier": ("grappling_hook:impl/guide", "grappling_hook:impl/add_versionning"),
        },
        guide_description=(f"{NAMESPACE}.guide.description", {
            Lang.en_us: "The guide you are currently holding.",
            Lang.fr_fr: "Le guide que vous tenez actuellement."
        })
    ).export(ctx)

    crossbow = VanillaItem(id="minecraft:crossbow").export(ctx)
    lead = VanillaItem(id="minecraft:lead").export(ctx)
    cobblestone = VanillaItem(id="minecraft:cobblestone").export(ctx)
    slime_ball = VanillaItem(id="minecraft:slime_ball").export(ctx)
    slime_block = VanillaItem(id="minecraft:slime_block").export(ctx)
    diamond = VanillaItem(id="minecraft:diamond").export(ctx)
    elytra = VanillaItem(id="minecraft:elytra").export(ctx)
    obsidian = VanillaItem(id="minecraft:obsidian").export(ctx)
    book = VanillaItem(id="minecraft:book").export(ctx)
    redstone = VanillaItem(id="minecraft:redstone").export(ctx)
    oak_log = VanillaItem(id="minecraft:oak_log").export(ctx)
    crafting_table = VanillaItem(id="minecraft:crafting_table").export(ctx)
    smooth_stone = VanillaItem(id="minecraft:smooth_stone").export(ctx)
    heavy_workbench = ExternalItem(
        id="smithed:crafter",
        loot_table_path="smithed.crafter:blocks/table",
        item_model="smithed.crafter:table",
        base_item="minecraft:furnace",
        minimal_representation={
            "id":"minecraft:furnace",
            "components": {
                "minecraft:item_name": {"translate":"block.smithed.crafter", "color":"white"},
            }
        }, 
        guide_description=(f"{NAMESPACE}.guide.heavy_workbench", {
            Lang.fr_fr: "C'est une table de craft qui permet de crafter les items de Grappling Hook.",
            Lang.en_us: "It's a crafting table that allows you to craft Grappling Hook items."
        })
    ).export(ctx)
    ShapedRecipe(
        items=(
            (oak_log, oak_log, oak_log),
            (oak_log, crafting_table, oak_log),
            (smooth_stone, smooth_stone, smooth_stone),
        ),
        result=(heavy_workbench, 1),
    ).export(ctx, True)

    ShapedRecipe(
        items=(
            (cobblestone, cobblestone, None),
            (cobblestone, crossbow, slime_ball),
            (None, slime_ball, lead),
        ),
        result=(grappling_hook, 1),
        flags=["consume_tools"],
    ).export(ctx)

    ShapedRecipe(
        items=(
            (book, slime_ball, None),
            (crossbow, redstone, None),
            (None, None, None),
        ),
        result=(guide, 1),
        flags=["consume_tools"],
    ).export(ctx)

    ItemGroup(
        id="special:all_items",
        name=("", {}),
        items_list=[heavy_workbench, guide],
        page_index=-1,
        item_icon=guide
    ).export(ctx)
