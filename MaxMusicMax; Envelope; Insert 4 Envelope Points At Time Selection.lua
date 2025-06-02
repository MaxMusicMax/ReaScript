--@description Envelope; Insert 4 Envelope Points At Time Selection
--@version 1.0
--@author MaxMusicMax
-- https://forum.cockos.com/showthread.php?p=2059855
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

start_time, end_time = reaper.GetSet_LoopTimeRange2(0, false, false, 0, 0, false)

if start_time ~= end_time then
	reaper.Main_OnCommand(40726, 0) -- Envelope: Insert 4 envelope points at time selection 40726
	reaper.Main_OnCommand(41181, 0) -- Envelopes: Move selected points down a little bit 41181
	reaper.Main_OnCommand(41181, 0) -- Envelopes: Move selected points down a little bit 41181
	reaper.Main_OnCommand(41181, 0) -- Envelopes: Move selected points down a little bit 41181
else
	-- reaper.Main_OnCommand(40290, 0) -- Time selection: Set time selection to items
end
-- #######################################
-- #######################################
reaper.PreventUIRefresh(-1);
reaper.TrackList_AdjustWindows(0)  -- Updates the window view
reaper.UpdateArrange();  -- Updates the window view