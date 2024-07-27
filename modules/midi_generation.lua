MIDI_CONFIG = {}

MIDI_CONFIG.CHOICES =
{
  "safe",  _("Safe Defaults"),
  "relaxed",   _("Relaxed (May Sound Weird)")
}

function MIDI_CONFIG.setup(self)
  module_param_up(self)
end

function MIDI_CONFIG.all_done()
  for _,song in pairs(GAME.RESOURCES.MUSIC_LUMPS) do
    gui.prog_step("Generating MIDI...")
    if gui.generate_midi_track("scripts/midi/" .. PARAM.midi_config_selection .. ".json", "temp/" .. song .. ".mid") == 1 then
      if ob_mod_enabled("compress_output") == 1 then
        gui.pk3_insert_file("temp/" .. song .. ".mid", "music/" .. song .. ".mid")
      else
        gui.wad_insert_file("temp/" .. song .. ".mid", song)
      end
      gui.remove_temp_file(song .. ".mid")
    end
  end
end

OB_MODULES["midi_generation"] =
{

  name = "midi_generation",

  label = _("MIDI Generation"),

  where = "experimental",
  engine = "!idtech_0",
  port = "!limit_enforcing",
  priority = 5,

  tooltip = _("Procedurally generate replacement MIDI tracks"),

  hooks =
  {
    setup = MIDI_CONFIG.setup,
    all_done = MIDI_CONFIG.all_done
  },

  options =
  {
    {
      name = "midi_config_selection",
      label=_("Generator Config"),
      choices=MIDI_CONFIG.CHOICES,
      default = "safe",
      tooltip = _("Choose which procedural MIDI config to use")
    },
  },
}