from beet import Context, Language
from simple_item_plugin.utils import NAMESPACE, Lang, export_translated_string
from simple_item_plugin.item import Item, MergeOverridesPolicy
from simple_item_plugin.crafting import ShapedRecipe, VanillaItem


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
    basic_grappling_hook = Item(
        id="basic_grappling_hook",
        base_item="minecraft:crossbow",
        item_name=(
            f"{NAMESPACE}.item.basic_grappling_hook",
            {Lang.en_us: "Basic Grappling hook", Lang.fr_fr: "Grapin basique"},
        ),
        merge_overrides_policy={
            "layer0": MergeOverridesPolicy.use_model_path
        },
        components_extra={
            "minecraft:enchantments": {
                "levels": {
                    "grappling_hook:impl/grappling_hook": 10
                },
            },
            "minecraft:enchantment_glint_override": False,
            "minecraft:max_damage": 60,
            "minecraft:custom_data": "{grappling_hook:1b}"
        }
    ).export(ctx)

    normal_grappling_hook = Item(
        id="normal_grappling_hook",
        base_item="minecraft:crossbow",
        item_name=(
            f"{NAMESPACE}.item.normal_grappling_hook",
            {Lang.en_us: "Normal Grappling hook", Lang.fr_fr: "Grapin normal"},
        ),
        merge_overrides_policy={
            "layer0": MergeOverridesPolicy.use_model_path
        },
        components_extra={
            "minecraft:enchantments": {
                "levels": {
                    "grappling_hook:impl/grappling_hook": 15
                },
            },
            "minecraft:enchantment_glint_override": False,
            "minecraft:max_damage": 200,
            "minecraft:custom_data": "{grappling_hook:1b}"
        }
    ).export(ctx)

    advanced_grappling_hook = Item(
        id="advanced_grappling_hook",
        base_item="minecraft:crossbow",
        item_name=(
            f"{NAMESPACE}.item.advanced_grappling_hook",
            {Lang.en_us: "Advanced Grappling hook", Lang.fr_fr: "Grapin avancé"},
        ),
        merge_overrides_policy={
            "layer0": MergeOverridesPolicy.use_model_path
        },
        components_extra={
            "minecraft:enchantments": {
                "levels": {
                    "grappling_hook:impl/grappling_hook": 30
                },
            },
            "minecraft:enchantment_glint_override": False,
            "minecraft:max_damage": 420,
            "minecraft:custom_data": "{grappling_hook:1b}"
        }
    ).export(ctx)

    crossbow = VanillaItem("minecraft:crossbow")
    lead = VanillaItem("minecraft:lead")
    cobblestone = VanillaItem("minecraft:cobblestone")
    slime_ball = VanillaItem("minecraft:slime_ball")
    slime_block = VanillaItem("minecraft:slime_block")
    diamond = VanillaItem("minecraft:diamond")
    elytra = VanillaItem("minecraft:elytra")
    obsidian = VanillaItem("minecraft:obsidian")

    ShapedRecipe(
        (
            (cobblestone, cobblestone, None),
            (cobblestone, crossbow, slime_ball),
            (None, slime_ball, lead),
        ),
        (basic_grappling_hook, 1),
        flags=["consume_tools"],
    ).export(ctx)

    ShapedRecipe(
        (
            (diamond, diamond, None),
            (diamond, basic_grappling_hook, slime_block),
            (None, slime_block, None),
        ),
        (normal_grappling_hook, 1),
        flags=["consume_tools"],
    ).export(ctx)

    ShapedRecipe(
        (
            (obsidian, obsidian, None),
            (obsidian, normal_grappling_hook, elytra),
            (None, elytra, None),
        ),
        (advanced_grappling_hook, 1),
        flags=["consume_tools"],
    ).export(ctx)
