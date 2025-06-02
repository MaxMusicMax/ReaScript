--@description Envelope; Selected Envelope Heights To A
--@version 1.0
--@author MaxMusicMax
-- https://forum.cockos.com/showthread.php?t=240928
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
local envHeight = 58

env = reaper.GetSelectedEnvelope( 0)

function SetEnvHeight(envelope, laneHeight)
	local BR_env = reaper.BR_EnvAlloc( envelope, false )
	local active, visible, armed, inLane, _, defaultShape, _, _, _, _, faderScaling = reaper.BR_EnvGetProperties( BR_env )
	reaper.BR_EnvSetProperties( BR_env, active, visible, armed, inLane, laneHeight, defaultShape, faderScaling )
	reaper.BR_EnvFree( BR_env, true )
end

SetEnvHeight(env, envHeight)

-- Снять выделение со всех треков
first_track = reaper.GetTrack(0, 0);
reaper.SetOnlyTrackSelected(first_track);
reaper.SetTrackSelected(first_track, false);
-- #######################################
-- #######################################
reaper.PreventUIRefresh(-1);
reaper.TrackList_AdjustWindows(0)  -- Updates the window view
reaper.UpdateArrange();  -- Updates the window view