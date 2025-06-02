--@description Envelope; Insert Envelope Point On Edit Cursor
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
-- #######################################
-- #######################################
-- https://forum.cockos.com/showpost.php?p=2307073&postcount=12
cur_pos = reaper.GetCursorPosition()
env = reaper.GetSelectedEnvelope(0)
_, value, _, _, _ = reaper.Envelope_Evaluate( env, cur_pos, 0, 0 )
reaper.InsertEnvelopePoint( env, cur_pos, value, 0, 0, 0, 0 )
-- #######################################
-- #######################################
reaper.PreventUIRefresh(-1);
reaper.TrackList_AdjustWindows(0)  -- Updates the window view
reaper.UpdateArrange();  -- Updates the window view
-- #######################################
-- #######################################