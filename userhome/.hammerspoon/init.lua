hs.hotkey.bind({ "alt" }, "q", function()
	local front = hs.application.frontmostApplication()
	if front and front:name() == "Alacritty" then
		hs.osascript.applescript('tell application "System Events" to set visible of process "Alacritty" to false')
	else
		hs.execute("open -a Alacritty")
	end
end)
