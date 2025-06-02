--@description Item; Draw An Empty Midi Item
--@version 1.0
--@author MaxMusiMax
-- https://www.youtube.com/watch?v=HEVKLiWkRkk
-- #######################################
-- #######################################
function print_rs (param)
	reaper.ShowConsoleMsg (tostring (param) .. "\n");
end
-- #######################################
-- #######################################
reaper.PreventUIRefresh(1);
-- #######################################
-- #######################################
-- print_rs (track)
--[[
]]--
-- #######################################
-- #######################################
function SetToggleButtonOnOff(numb);
	local is_new_value, filename, sec, cmd, mode, resolution, val = reaper.get_action_context();
	reaper.SetToggleCommandState(sec,cmd,numb or 0);
	reaper.RefreshToolbar2(sec,cmd);
end;

is_new_value, filename, sec, cmd, mode, resolution, val = reaper.get_action_context()
state = reaper.GetToggleCommandStateEx( sec, cmd )

if state == 1 then
	reaper.Main_OnCommand(39201, 0) -- Set default mouse modifier action for "Track left drag" to "Marquee select items"
	
	SetToggleButtonOnOff(0) -- 1 — on / 0 — off
else
	reaper.Main_OnCommand(39197, 0) -- Set default mouse modifier action for "Track left drag" to "Draw an empty MIDI item"
	
	SetToggleButtonOnOff(1) -- 1 — on / 0 — off
end
-- #######################################
-- #######################################
reaper.PreventUIRefresh(-1);
reaper.TrackList_AdjustWindows(0)  -- Updates the window view
reaper.UpdateArrange();  -- Updates the window view