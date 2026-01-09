local config = {
  enabled = true;
  dress = "None";
  random_each_run = false;
  debug_reload = false;
  hue_shift = 0;
  dresscolor = { r = 223, g = 122, b = 68 },
  haircolor = { r = 223, g = 122, b = 68 },
  arm_hue = 0,
  custom_dress_color = false,
  custom_hair_color = false,
  custom_dress = false,
  custom_dress_base = "None",
  custom_arm_color = false,
  use_exe = true,
  bright_dress = false,
}

local configDesc = {
  dress = "Select a skin from Lavender, Azure, Emerald, Onyx, Fuchsia, Gilded, Moonlight, Crimson, and more";
  random_each_run = "Choose a dress randomly at the start of the run.";
  debug_reload = "Meant for dev/debug purposes";
}

return config, configDesc