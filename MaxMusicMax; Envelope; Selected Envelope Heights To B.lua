--@description Envelope; Selected Envelope Heights To B
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
local envHeight = 750
local unselect_envelope_height = 58; -- высота огибающей — unselect_height

env = reaper.GetSelectedEnvelope( 0)

function SetEnvHeight(envelope, laneHeight)
	local BR_env = reaper.BR_EnvAlloc( envelope, false )
	local active, visible, armed, inLane, _, defaultShape, _, _, _, _, faderScaling = reaper.BR_EnvGetProperties( BR_env )
	reaper.BR_EnvSetProperties( BR_env, active, visible, armed, inLane, laneHeight, defaultShape, faderScaling )
	reaper.BR_EnvFree( BR_env, true )
end

function SetAllEnvelopesHeight(desired_height)
	-- Получить количество треков в проекте
	local track_count = reaper.CountTracks(0)
	-- Пройти по всем трекам
	for i = 0, track_count - 1 do
		local track = reaper.GetTrack(0, i)

		-- Пройти по всем огибающим трека
		local envelope_count = reaper.CountTrackEnvelopes(track)
		for j = 0, envelope_count - 1 do
			local envelope = reaper.GetTrackEnvelope(track, j)
			-- Создать объект BR_Env для работы с огибающей
			local BR_env = reaper.BR_EnvAlloc(envelope, false)
			-- Получить текущие свойства огибающей
			local active, visible, armed, inLane, laneHeight, defaultShape, _, _, _, faderScaling = reaper.BR_EnvGetProperties(BR_env)
			-- Установить новую высоту огибающей
			reaper.BR_EnvSetProperties(BR_env, active, visible, armed, inLane, desired_height, defaultShape, faderScaling)
			-- Освободить объект BR_Env
			reaper.BR_EnvFree(BR_env, true)
		end
	end
end

SetAllEnvelopesHeight (unselect_envelope_height)

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