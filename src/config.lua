local config = {
  enabled = true;
  dress = "None";
  random_each_run = false;
  debug_reload = false;
  hue_shift = 0;
}

local configDesc = {
  dress = "Select a skin from Lavender, Azure, Emerald, Onyx, Fuchsia, Gilded, Moonlight, Crimson, and more";
  random_each_run = "Choose a dress randomly at the start of the run.";
  debug_reload = "Meant for dev/debug purposes";
}

return config, configDesc