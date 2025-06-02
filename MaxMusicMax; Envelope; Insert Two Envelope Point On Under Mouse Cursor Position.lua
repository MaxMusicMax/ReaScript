--@description Envelope; Insert Envelope Point On Under Mouse Cursor Position
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
function printTable(tbl, indent)
    indent = indent or 0  -- Устанавливаем отступ по умолчанию в 0, если он не задан
    local prefix = string.rep("  ", indent)  -- Создаем строку отступа на основе текущего уровня отступа

    for k, v in pairs(tbl) do  -- Проходим по всем парам ключ-значение в таблице
        if type(v) == "table" then  -- Если значение является таблицей
            reaper.ShowConsoleMsg(prefix .. tostring(k) .. ": {\n")  -- Печатаем ключ и открывающую скобку для новой таблицы
            printTable(v, indent + 1)  -- Рекурсивно вызываем printTable для вложенной таблицы, увеличивая уровень отступа
            reaper.ShowConsoleMsg(prefix .. "}\n")  -- Печатаем закрывающую скобку для таблицы
        else  -- Если значение не является таблицей
            reaper.ShowConsoleMsg(prefix .. tostring(k) .. ": " .. tostring(v) .. "\n")  -- Печатаем ключ и значение
        end
    end
end
-- #######################################
-- #######################################
function printValue(value, indent)
    indent = indent or 0  -- Устанавливаем отступ по умолчанию в 0, если он не задан
    local prefix = string.rep("  ", indent)  -- Создаем строку отступа на основе текущего уровня отступа

    if type(value) == "table" then  -- Если значение является таблицей
        reaper.ShowConsoleMsg(prefix .. "{\n")  -- Печатаем открывающую скобку для таблицы
        for k, v in pairs(value) do  -- Проходим по всем парам ключ-значение в таблице
            reaper.ShowConsoleMsg(prefix .. "  " .. tostring(k) .. ": ")  -- Печатаем ключ с отступом
            printValue(v, indent + 1)  -- Рекурсивно вызываем printValue для значения, увеличивая уровень отступа
        end
        reaper.ShowConsoleMsg(prefix .. "}\n")  -- Печатаем закрывающую скобку для таблицы
    else  -- Если значение не является таблицей
        reaper.ShowConsoleMsg(prefix .. tostring(value) .. "\n")  -- Печатаем значение
    end
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
-- local context = reaper.JS_Mouse_GetState(0)
-- track, context, position = reaper.BR_TrackAtMouseCursor()

-- reaper.SetEditCurPos( cursor_position - 0.003, true, true )
-- reaper.Main_OnCommand(40106, 0) -- Envelope: Insert new point at current position (do not remove nearby points) — 40106
-- reaper.Main_OnCommand(40915, 0) -- Envelope: Insert new point at current position (remove nearby points) — 40915

-- reaper.SetEditCurPos( cursor_position + 0.003, true, true )
-- reaper.Main_OnCommand(40106, 0) -- Envelope: Insert new point at current position (do not remove nearby points) — 40106
-- reaper.Main_OnCommand(40915, 0) -- Envelope: Insert new point at current position (remove nearby points) — 40915

local select_envelope_height = 700; -- высота огибающей — select_height
local unselect_envelope_height = 58; -- высота огибающей — unselect_height
local tracks_height = 58; -- высота огибающей — height_tracks
local cursor_padding = 0.001
-- cursor_padding = 0.0005
-- reaper.Main_OnCommand(reaper.NamedCommandLookup("_BR_UNSEL_ENV"), 0) -- SWS/BR: Unselect envelope
-- reaper.Main_OnCommand(reaper.NamedCommandLookup("40297"), 0) -- SWS/BR: Unselect envelope
-- first_track = reaper.GetTrack(0, 0);
-- reaper.SetOnlyTrackSelected(first_track);
-- reaper.SetTrackSelected(first_track, false);

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

function SetAllTracksHeight(desired_height)
	-- Получить количество треков в проекте
	local track_count = reaper.CountTracks(0)
	-- Пройти по всем трекам
	for i = 0, track_count - 1 do
		local track = reaper.GetTrack(0, i)
		reaper.SetMediaTrackInfo_Value(track, "I_HEIGHTOVERRIDE", desired_height)
	end
end

SetAllEnvelopesHeight (unselect_envelope_height)

-- window, segment, details = reaper.BR_GetMouseCursorContext()
local window = reaper.BR_GetMouseCursorContext();
-- retval, takeEnvelope = reaper.BR_GetMouseCursorContext_Envelope()
reaper.Main_OnCommand(reaper.NamedCommandLookup("_BR_SEL_ENV_MOUSE"), 0) -- SWS/BR: Select envelope at mouse cursor
local envelope = reaper.GetSelectedEnvelope(0)

if envelope ~= nil then
	
	-- Создать объект BR_Env для работы с огибающей
	local BR_env = reaper.BR_EnvAlloc(envelope, false)
	-- Получить текущие свойства огибающей
	local active, visible, armed, inLane, laneHeight, defaultShape, _, _, _, faderScaling = reaper.BR_EnvGetProperties(BR_env)
	-- Установить новую высоту огибающей
	reaper.BR_EnvSetProperties(BR_env, active, visible, armed, inLane, select_envelope_height, defaultShape, faderScaling)
	-- Освободить объект BR_Env
	reaper.BR_EnvFree(BR_env, true)
	if window == 'arrange' or window == 'ruler' then; -- если курсор мыши над «ruler» или «arrange»
		local cur_pos = reaper.BR_GetMouseCursorContext_Position(); -- положение мыши
		_, value, _, _, _ = reaper.Envelope_Evaluate( envelope, cur_pos, 0, 0 )
		reaper.InsertEnvelopePoint( envelope, cur_pos - cursor_padding, value, 0, 0, 0, 0 )
		reaper.InsertEnvelopePoint( envelope, cur_pos + cursor_padding, value, 0, 0, 0, 0 )
		
		SetAllTracksHeight (tracks_height)
		
		reaper.Main_OnCommand(reaper.NamedCommandLookup("40297"), 0) -- Track: Unselect (clear selection of) all tracks
		reaper.Main_OnCommand(reaper.NamedCommandLookup("_BR_UNSEL_ENV"), 0) -- SWS/BR: Unselect envelope
		
		-- https://rmmedia.ru/threads/134701/page-36
		-- https://forum.cockos.com/showpost.php?p=2131911&postcount=2
		local title = reaper.JS_Localize('ReaScript console output', "common")
		local hwnd = reaper.JS_Window_Find(title, true)
		if hwnd then reaper.JS_Window_Destroy(hwnd) end
	end;
else
	SetAllTracksHeight (tracks_height)
	SetAllEnvelopesHeight (unselect_envelope_height)
	-- print_rs ( "Наведите мышь на трек огибающей" )
end;

reaper.Undo_EndBlock( "MaxMusicMax; Envelope; Insert Envelope Point On Under Mouse Cursor Position", 4 )
-- #######################################
-- #######################################
reaper.PreventUIRefresh(-1);
reaper.TrackList_AdjustWindows(0)  -- Updates the window view
reaper.UpdateArrange();  -- Updates the window view
-- #######################################
-- #######################################