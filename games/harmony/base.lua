HARMONY = { }

----------------------------------------------------------------
gui.import("params")
gui.import("entities")
gui.import("monsters")
gui.import("pickups")
gui.import("weapons")
gui.import("shapes")
gui.import("materials")
gui.import("themes")
gui.import("levels")
gui.import("resources")
----------------------------------------------------------------

OB_GAMES["harmony"] =
{
	label = _("Harmony (Exp)"),
	priority = 29,
	
	format = "doom",
	--sub_format = "harmony",
	engine = "zdoom",
	
	game_dir = "harmony",
	iwad_name = "harm1.wad",
	
	tables =
	{
		HARMONY
	},
	
	hooks =
	{
		--setup = HARMONY.setup,
		get_levels = HARMONY.get_levels,
		all_done = HARMONY.all_done
	},
}