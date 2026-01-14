local config = {
  enabled = true;
  dress = "None";
  random_each_run = false;
  debug_reload = false;
  dresscolor = { r = 202, g = 105, b = 28 },
  haircolor = { r = 203, g = 178, b = 121 },
  arm_hue = 0,
  custom_dress_color = false,
  custom_hair_color = false,
  custom_dress = false,
  custom_dress_base = "None",
  custom_arm_color = false,
  use_exe = true,
  bright_dress = false,
  current_preset = "Default",
  enable_shimmer_fix = false,
}

local configDesc = {
  dress = "Select a skin from Lavender, Azure, Emerald, Onyx, Fuchsia, Gilded, Moonlight, Crimson, and more";
  random_each_run = "Choose a dress randomly at the start of the run.";
  debug_reload = "Meant for dev/debug purposes";
  arm_hue = "Hue shift for Mel Arm Glow (0-360)";
  custom_dress_color = "Use a custom color for the dress";
  custom_hair_color = "Use a custom color for the dress";
  custom_dress = "Enable custom dress customization";
  custom_dress_base = "Use base game dress for Custom skin";
  custom_arm_color = "Set a custom arm glow hue";
  use_exe = "DEBUG: set false to use the script instead of exe";
  bright_dress = "Use a bright dress as the custom dress base";
  current_preset = "current preset selected in the preset selector ImGui";
  enable_shimmer_fix = "Mitigate shimmer for custom skins by using a lower res texture, model may look a bit blurry in some situations"
}

return config, configDesc