local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- windowsの場合はここを有効化
-- config.default_prog = { "wsl.exe", "--distribution", "ubuntu", "--cd", "~" }

config.automatically_reload_config = true
config.font = wezterm.font("0xProto Nerd Font Mono")
config.font_size = 19.0
config.use_ime = true
config.initial_cols = 125
config.initial_rows = 50
config.max_fps = 120
config.color_scheme = 'Misterioso (Gogh)'

-- 背景の透明度
config.window_background_opacity = 0.85
config.macos_window_background_blur = 80

-- タイトルバーを非表示
config.window_decorations = "RESIZE"

-- タブが一つの時は非表示
config.hide_tab_bar_if_only_one_tab = false

-- タブバーの透過
config.window_frame = {
  font_size = 16.5,
  -- inactive_titlebar_bg = "none",
  -- active_titlebar_bg = "none",
}

-- タブの追加ボタンを非表示
config.show_new_tab_button_in_tab_bar = true

-- タブ同士の境界線を非表示
config.colors = {
  background = "#333333",
  cursor_fg = "#202b55",
  cursor_bg = "#ffffff",
  tab_bar = {
    inactive_tab_edge = "none",

    new_tab = {
      bg_color = "NONE",
      fg_color = "#696969",
    },
  },
}

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local cwd_uri = tab.active_pane.current_working_dir
  local cwd = ""

  if cwd_uri then
    cwd = cwd_uri.file_path or cwd_uri:sub(8)
  end

  -- パス分割
  local parts = {}
  for part in cwd:gmatch("[^/]+") do
    table.insert(parts, part)
  end

  local folder_name = parts[#parts] or ""
  local parent_name = parts[#parts - 1] or ""

  local display_title = "📁" .. parent_name .. "/" .. folder_name

  -- 色設定（hover, active 対応）
  local is_active = tab.is_active
  local is_hover = hover
  local bg = is_active and "#148f77" or (is_hover and "#2980b9" or "#2e4053")
  local fg = is_active and "#ffffff" or "#cccccc"

  return {
    { Background = { Color = bg } },
    { Foreground = { Color = fg } },
    { Text = " " .. wezterm.truncate_right(display_title, max_width + 5) },

  }
end)

return config
