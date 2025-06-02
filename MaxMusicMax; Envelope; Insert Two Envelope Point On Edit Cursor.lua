--@description Envelope; Insert Two Envelope Point On Edit Cursor
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
-- reaper.Main_OnCommand(40726, 0) -- Envelope: Insert 4 envelope points at time selection 40726
-- #######################################
-- #######################################
-- cursor_position = reaper.GetCursorPosition();

-- reaper.SetEditCurPos( cursor_position - 0.003, true, true )
-- reaper.Main_OnCommand(40106, 0) -- Envelope: Insert new point at current position (do not remove nearby points) — 40106
-- reaper.Main_OnCommand(40915, 0) -- Envelope: Insert new point at current position (remove nearby points) — 40915

-- reaper.SetEditCurPos( cursor_position + 0.003, true, true )
-- reaper.Main_OnCommand(40106, 0) -- Envelope: Insert new point at current position (do not remove nearby points) — 40106
-- reaper.Main_OnCommand(40915, 0) -- Envelope: Insert new point at current position (remove nearby points) — 40915
cursor_padding = 0.001

cur_pos = reaper.GetCursorPosition();
env = reaper.GetSelectedEnvelope(0)
if env ~= nil then
	-- print_rs (env)
	_, value, _, _, _ = reaper.Envelope_Evaluate( env, cur_pos, 0, 0 )

	reaper.InsertEnvelopePoint( env, cur_pos - cursor_padding, value, 0, 0, 0, 0 )
	reaper.InsertEnvelopePoint( env, cur_pos + cursor_padding, value, 0, 0, 0, 0 )
end

reaper.Undo_EndBlock( "Envelope; Insert Two Envelope Point On Edit Cursor", 4 )
-- #######################################
-- #######################################
reaper.PreventUIRefresh(-1);
reaper.TrackList_AdjustWindows(0)  -- Updates the window view
reaper.UpdateArrange();  -- Updates the window view
-- #######################################
-- #######################################