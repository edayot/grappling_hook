from beet import Context
from simple_item_plugin.types import NAMESPACE, Lang
from simple_item_plugin.item import Item, MergeOverridesPolicy
from simple_item_plugin.crafting import ShapedRecipe, VanillaItem


def beet_default(ctx: Context):
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
                    "grappling_hook:grappling_hook": 10
                },
                "show_in_tooltip": False
            },
            "minecraft:enchantment_glint_override": False
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
                    "grappling_hook:grappling_hook": 15
                },
                "show_in_tooltip": False
            },
            "minecraft:enchantment_glint_override": False
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
                    "grappling_hook:grappling_hook": 30
                },
                "show_in_tooltip": False
            },
            "minecraft:enchantment_glint_override": False
        }
    ).export(ctx)

    elytra = VanillaItem("minecraft:elytra")
    diamond = VanillaItem("minecraft:diamond")

