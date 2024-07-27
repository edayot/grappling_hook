from beet import Context
from simple_item_plugin.types import NAMESPACE, Lang
from simple_item_plugin.item import Item, MergeOverridesPolicy


def beet_default(ctx: Context):
    grappling_hook = Item(
        id="grappling_hook",
        base_item="minecraft:crossbow",
        item_name=(
            f"{NAMESPACE}.item.grappling_hook",
            {Lang.en_us: "Grappling hook", Lang.fr_fr: "Grapin"},
        ),
        merge_overrides_policy={
            "layer0": MergeOverridesPolicy.use_model_path
        },
        components_extra={
            "minecraft:enchantments": {
                "levels": {
                    "grappling_hook:grappling_hook": 1
                },
                "show_in_tooltip": False
            },
            "minecraft:enchantment_glint_override": False
        }
    ).export(ctx)
