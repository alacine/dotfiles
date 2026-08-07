local terminal = "alacritty"
local file_manager = "dolphin"
local menu = "rofi -show drun"
local main_mod = "CTRL + ALT"

local function bind(keys, dispatcher, opts)
	hl.bind(keys, dispatcher, opts)
end

local function exec(cmd, rules)
	return hl.dsp.exec_cmd(cmd, rules)
end

hl.monitor({
	output = "eDP-1",
	mode = "preferred",
	position = "0x1080",
	scale = 1.25,
})

hl.monitor({
	output = "DP-1",
	mode = "1920x1080@60",
	position = "0x0",
	scale = 1,
	transform = 0,
})

hl.on("hyprland.start", function()
	hl.exec_cmd("waybar")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("swaync")
	hl.exec_cmd("clipse -listen")
	hl.exec_cmd("kdeconnect-indicator")
	hl.exec_cmd(
		"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP LIBVA_DRIVER_NAME NVD_BACKEND MOZ_ENABLE_WAYLAND"
	)
end)

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("GTK_IM_MODULE", "fcitx")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("XDG_MENU_PREFIX", "arch-")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("ELECTRON_ENABLE_WAYLAND_IME", "true")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")
hl.env("MOZ_ENABLE_WAYLAND", "1")

hl.config({
	xwayland = {
		force_zero_scaling = true,
	},

	general = {
		gaps_in = 5,
		gaps_out = 15,
		border_size = 2,
		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},

	decoration = {
		rounding = 15,
		rounding_power = 2,
		active_opacity = 1.0,
		inactive_opacity = 1.0,
		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)",
		},
		blur = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
			new_optimizations = true,
		},
	},

	animations = {
		enabled = true,
	},

	dwindle = {
		preserve_split = true,
	},

	scrolling = {
		column_width = 0.5,
		follow_focus = true,
		focus_fit_method = 1,
		direction = "right",
		wrap_focus = true,
		wrap_swapcol = true,
	},

	misc = {
		force_default_wallpaper = -1,
		disable_hyprland_logo = false,
	},

	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = true,
		},
	},
})

hl.layer_rule({ name = "blur-waybar", match = { namespace = "waybar" }, blur = true })
hl.layer_rule({ name = "blur-lockscreen", match = { namespace = "lockscreen" }, blur = true })

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })

for i = 1, 5 do
	hl.workspace_rule({ workspace = tostring(i), layout = "scrolling" })
end

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

hl.device({
	name = "epic-mouse-v1",
	sensitivity = -0.5,
})

bind(main_mod .. " + Q", hl.dsp.window.close())
bind(main_mod .. " + M", hl.dsp.exit())
bind(main_mod .. " + F", hl.dsp.window.float({ action = "toggle" }))
bind("SUPER + F", exec("~/.config/scripts/hypr-toggle-maximize"))
bind(main_mod .. " + P", hl.dsp.window.pseudo())
bind(main_mod .. " + J", hl.dsp.layout("togglesplit"))
bind(main_mod .. " + comma", hl.dsp.layout("move -col"))
bind(main_mod .. " + period", hl.dsp.layout("move +col"))
bind(main_mod .. " + SHIFT + comma", hl.dsp.layout("swapcol l"))
bind(main_mod .. " + SHIFT + period", hl.dsp.layout("swapcol r"))

bind(main_mod .. " + E", exec(file_manager, { float = true }))
bind("CTRL + ALT + T", exec("alacritty", { float = true }))
bind("ALT + Q", exec("~/.config/scripts/hypr-dropdown"))
bind("ALT + code:36", exec(terminal))

bind("ALT + code:65", exec(menu))
bind(main_mod .. " + code:65", exec("rofi -show run"))
bind(main_mod .. " + Escape", exec("killall rofi"))
bind(main_mod .. " + W", exec("rofi -show window"))
bind(main_mod .. " + S", exec("rofi -show ssh"))
bind(main_mod .. " + L", exec("~/.config/scripts/powermenu"))
bind(main_mod .. " + N", exec("~/.config/scripts/rofi-wifi-menu"))
bind(main_mod .. " + B", exec("~/.config/scripts/rofi-bluetooth"))
bind(main_mod .. " + code:65", exec("~/.config/scripts/rofi-tmux"))

hl.window_rule({
	name = "dropdown",
	match = { class = "dropdown" },
	float = true,
	size = "monitor_w*0.75 monitor_h*0.8",
	center = true,
})

hl.window_rule({
	name = "clipse",
	match = { class = "app.clipse" },
	float = true,
	size = "monitor_w*0.75 monitor_h*0.6",
	stay_focused = true,
	center = true,
})

bind(main_mod .. " + V", exec(terminal .. " --class=app.clipse -e clipse"))

bind(
	"SUPER + SHIFT + S",
	exec([[grimblast copysave area && notify-send "Screenshot" "Area saved to clipboard" -i camera-photo]])
)
bind(
	"SUPER + SHIFT + P",
	exec([[grimblast copysave screen && notify-send "Screenshot" "Screen saved to clipboard" -i camera-photo]])
)
bind(
	"SUPER + SHIFT + W",
	exec([[grimblast copysave active && notify-send "Screenshot" "Window saved to clipboard" -i camera-photo]])
)

bind("CTRL + left", hl.dsp.focus({ direction = "l" }))
bind("CTRL + right", hl.dsp.focus({ direction = "r" }))
bind("CTRL + up", hl.dsp.focus({ direction = "u" }))
bind("CTRL + down", hl.dsp.focus({ direction = "d" }))

bind("ALT + Tab", function()
	hl.dispatch(hl.dsp.window.cycle_next())
	hl.dispatch(hl.dsp.window.bring_to_top())
end)

bind(main_mod .. " + left", hl.dsp.focus({ workspace = "e-1" }))
bind(main_mod .. " + right", hl.dsp.focus({ workspace = "e+1" }))
bind("SUPER + up", hl.dsp.workspace.toggle_special("1"))
bind("SUPER + down", hl.dsp.workspace.toggle_special("0"))

for i = 1, 10 do
	local key = i % 10
	bind(main_mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

bind("CTRL + ALT + up", hl.dsp.focus({ workspace = "special" }))
bind(main_mod .. " + SHIFT + left", hl.dsp.window.move({ workspace = "e-1" }))
bind(main_mod .. " + SHIFT + right", hl.dsp.window.move({ workspace = "e+1" }))
bind(main_mod .. " + SHIFT + up", hl.dsp.window.move({ workspace = "special" }))

bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

bind("CTRL + SHIFT + left", hl.dsp.window.move({ direction = "l" }))
bind("CTRL + SHIFT + right", hl.dsp.window.move({ direction = "r" }))
bind("CTRL + SHIFT + up", hl.dsp.window.move({ direction = "u" }))
bind("CTRL + SHIFT + down", hl.dsp.window.move({ direction = "d" }))
bind("CTRL + SUPER + left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }))
bind("CTRL + SUPER + right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }))
bind("CTRL + SUPER + up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }))
bind("CTRL + SUPER + down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }))

bind(
	"XF86AudioRaiseVolume",
	exec("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
bind("XF86AudioLowerVolume", exec("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
bind("XF86AudioMute", exec("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
bind("XF86AudioMicMute", exec("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
bind("XF86MonBrightnessUp", exec("brightnessctl s 10%+"), { locked = true, repeating = true })
bind("XF86MonBrightnessDown", exec("brightnessctl s 10%-"), { locked = true, repeating = true })

bind("XF86AudioNext", exec("playerctl next"), { locked = true })
bind("XF86AudioPause", exec("playerctl play-pause"), { locked = true })
bind("XF86AudioPlay", exec("playerctl play-pause"), { locked = true })
bind("XF86AudioPrev", exec("playerctl previous"), { locked = true })

hl.window_rule({
	name = "suppress-maximize-events",
	match = { class = ".*" },
	suppress_event = "maximize",
})

hl.window_rule({
	name = "fix-xwayland-drags",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

hl.window_rule({
	name = "move-hyprland-run",
	match = { class = "hyprland-run" },
	move = "20 monitor_h-120",
	float = true,
})

hl.window_rule({
	name = "no-blur-alacritty",
	match = { class = "^(Alacritty|dropdown)$" },
	no_blur = true,
})
