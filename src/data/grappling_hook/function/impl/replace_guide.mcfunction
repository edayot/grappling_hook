advancement revoke @s only grappling_hook:impl/replace_guide


major,minor,patch = ctx.project_version.split('.')
execute 
	if items entity @s weapon.mainhand written_book[
		custom_data~{smithed:{id:"grappling_hook:guide"}},
		!custom_data~{grappling_hook:{version:{major:int(major),minor:int(minor),patch:int(patch)}}}
	]
	run function ~/modify:
        item modify entity @s weapon.mainhand grappling_hook:impl/add_versionning
        item modify entity @s weapon.mainhand grappling_hook:impl/guide