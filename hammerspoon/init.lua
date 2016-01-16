function reloadConfig(files)
    doReload = false
    for _,file in pairs(files) do
        if file:sub(-4) == ".lua" then
            doReload = true
        end
    end
    if doReload then
        hs.reload()
    end
end
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("config loaded")

-- Android Studio

androidStudioWindows = hs.application.find("Android Studio"):allWindows()
androidStudioWindowsCount = #androidStudioWindows
for k,v in pairs(androidStudioWindows) do
	windowTitle = v:title()
	if string.find(windowTitle, "Android Studio") then
		androidMainWindow = v
	elseif string.find(windowTitle, "Android Monitor") then
		androidMonitorWindow = v
	elseif string.find(windowTitle, "Find") then
		androidFindWindow = v
	elseif string.find(windowTitle, "Project") then
		androidProjectWindow = v
	end
end
-- todo: decide what to do with the other android studio windows

-- f: float from 0 to 1 representing percentage of screen width
function left(f)
	return hs.geometry.rect(0, 0, f, 1)
end
function leftSplit(f, onTop, yf)
	yf = yf or 0.5
	if onTop then
		y = 0
	else
		y = 0.5 + (0.5 - yf)
	end
	return hs.geometry.rect(0, y, f, yf)
end
function right(f)
	return hs.geometry.rect(1, 0, -f, 1)
end
function rightSplit(f, onTop, yf)
	yf = yf or 0.5
	if onTop then
		y = 0
	else
		y = 0.5 + (0.5 - yf)
	end
	
	return hs.geometry.rect(1-f, y, f, yf)
end

-- Multi-Window Layouts

laptopScreen = "Color LCD"
for _,screen in pairs(hs.screen.allScreens()) do
	if string.find(screen:name(), "ASUS") then
		asusScreen = screen
	elseif string.find(screen:name(), "DELL") then
		dellScreen = screen
	end
end
numScreens = #hs.screen.allScreens()

genymotionEmulatorWindow = hs.window.find("Genymotion").find("API") -- fucking hacked up way of selecting from multiple hs.windows

if numScreens == 1 then
	-- do this only if it's only the laptop - have different settings for different monitor setups
	windowLayout = {
		{"Android Studio", androidMainWindow:title(), laptopScreen, left(0.7), nil, nil},
		{"Android Studio", androidMonitorWindow:title(), laptopScreen, right(0.7), nil, nil}
	}
elseif numScreens == 3 then
	windowLayout = {
		{"Android Studio", androidMainWindow:title(), asusScreen, left(1), nil, nil},
		{"Android Studio", androidMonitorWindow:title(), dellScreen, leftSplit(0.7, true, 0.6), nil, nil},
		{"Android Studio", androidFindWindow:title(), dellScreen, leftSplit(0.7, false, 0.4), nil, nil},
		{"Genymotion", genymotionEmulatorWindow:title(), dellScreen, right(0.3), nil, nil},
		{"iTunes", "iTunes", laptopScreen, left(0.8), nil, nil}
	}
end
hs.layout.apply(windowLayout)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "1", function()
	hs.alert.show(hs.application.frontmostApplication():name())
	hs.alert.show(hs.window.frontmostWindow():title())
end)

--

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "W", function()
	hs.notify.new({title="Hammerspoon", informativeText="Hello World"}):send()
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "H", function()
	local win = hs.window.focusedWindow()
	local f = win:frame()

	f.x = f.x - 10
	win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
	local win = hs.window.focusedWindow()
	local f = win:frame()
	local screen = win:screen()
	local max = screen:frame()

	f.x = max.x
	f.y = max.y
	f.w = max.w / 2
	f.h = max.h

	win:setFrame(f)
end)







