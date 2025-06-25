local wezterm = require 'wezterm'
return {
  adjust_window_size_when_changing_font_size = false,
  color_scheme = 'Catppuccin Mocha',
  enable_tab_bar = false,
  font_size = 16.0,
  font = wezterm.font 'JetBrains Mono',
  macos_window_background_blur = 30,

  window_background_opacity = 1.0,
  window_decorations = 'RESIZE',
}
