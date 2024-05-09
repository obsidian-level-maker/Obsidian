HARMONY = { }

----------------------------------------------------------------
gui.import("params")
gui.import("themes")
gui.import("resources")
gui.import("names")
----------------------------------------------------------------

function HARMONY.all_done()
	gui.wad_insert_file("data/endoom/ENDOOM.bin", "ENDOOM")
end

OB_GAMES["harmony"] =
{
	label = _("Harmony Compat"),
	priority = 91,
	
	engine = "idtech_1",
	format = "doom",
	
	game_dir = "harmony",
	iwad_name = "harm1.wad",

	tables =
	{
		HARMONY
	},
	
	hooks =
	{
		slump_setup = HARMONY.slump_setup,
		all_done = HARMONY.all_done
	},
}