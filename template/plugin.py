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
    ).export(ctx)
    grappling_hook = Item(
        id="grappling_hook_bis",
        base_item="minecraft:crossbow",
        item_name=(
            f"{NAMESPACE}.item.grappling_hook",
            {Lang.en_us: "Grappling hook", Lang.fr_fr: "Grapin"},
        ),
        merge_overrides_policy={
            "layer0": MergeOverridesPolicy.use_model_path
        },
    ).export(ctx)
