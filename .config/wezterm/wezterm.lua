-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- Apply your config choices
config.color_scheme = "Catppuccin Mocha"

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 22

config.enable_tab_bar = false
config.window_decorations = "RESIZE"

config.window_background_opacity = 1.0
config.macos_window_background_blur = 0

-- and finally, return the configuration to wezterm
return config
