------------------------------------------------------------
-- Mix Inspector 3.5 (Manual groups, instruments, ReEQ, ImGui-safe)
------------------------------------------------------------
-- https://t.me/beyondway_music/150
-- https://www.youtube.com/watch?v=5dNBiafibO8
------------------------------------------------------------

-- SAFETY: destroy old context if script crashed previously
if _G["MIX_INSPECTOR_CTX"] then
    pcall(reaper.ImGui_DestroyContext, _G["MIX_INSPECTOR_CTX"])
end

local ctx = reaper.ImGui_CreateContext('Mix Inspector')
_G["MIX_INSPECTOR_CTX"] = ctx

reaper.ClearConsole()

local live_mode = true

local window_seconds = 0.3
local window_text = "0.3"

local hold_time = 2.0

local results = {}
local peak_history = {}
local hold_values = {}

local master_hold = -150
local master_hold_time = 0

local sort_mode = 0

local active_filter = "off"

local helper_mode = false

local show_only_problems = false

local group_view = false




local recommended_levels = {
    -- DRUMS
    kick   = {min=-9,  max=-6},
    snare  = {min=-12, max=-8},
    clap   = {min=-18, max=-12},
    hat    = {min=-24, max=-18},
    tom    = {min=-15, max=-10},
    ride   = {min=-20, max=-14},
    crash  = {min=-20, max=-14},
    perc   = {min=-24, max=-18},

    -- BASS
    bass   = {min=-12, max=-8},
    sub    = {min=-12, max=-8},
    ["808"]= {min=-12, max=-8},

    -- VOCALS
    vocal  = {min=-15, max=-10},
    backvox= {min=-24, max=-16},
    choir  = {min=-20, max=-14},

    -- SYNTHS / KEYS / MUSIC
    lead   = {min=-18, max=-12},
    pad    = {min=-28, max=-20},
    pluck  = {min=-24, max=-16},
    synth  = {min=-20, max=-14},
    keys   = {min=-22, max=-16},
    piano  = {min=-22, max=-16},
    organ  = {min=-22, max=-16},
    arp    = {min=-26, max=-18},
    chord  = {min=-24, max=-18},

    -- GUITARS / ORCHESTRA
    guitar = {min=-20, max=-14},
    strings= {min=-26, max=-18},
    violin = {min=-26, max=-18},
    cello  = {min=-24, max=-16},
    brass  = {min=-22, max=-14},
    horn   = {min=-22, max=-14},
    flute  = {min=-28, max=-20},

    -- FX
    impact = {min=-12, max=-6},
    riser  = {min=-30, max=-20},
    sweep  = {min=-30, max=-20},
    noise  = {min=-28, max=-18},
    whoosh = {min=-28, max=-18},
}

local recommended_pan = {
    -- DRUMS
    kick   = {min=0,   max=0},
    snare  = {min=-5,  max=5},
    clap   = {min=10,  max=40},
    hat    = {min=30,  max=60},
    tom    = {min=10,  max=40},
    ride   = {min=20,  max=50},
    crash  = {min=30,  max=70},
    perc   = {min=20,  max=70},

    -- BASS
    bass   = {min=0,   max=0},
    sub    = {min=0,   max=0},
    ["808"]= {min=0,   max=0},

    -- VOCALS
    vocal  = {min=0,   max=0},
    backvox= {min=10,  max=40},
    choir  = {min=10,  max=40},

    -- SYNTHS / KEYS / MUSIC
    lead   = {min=-5,  max=5},
    pad    = {min=10,  max=40},
    pluck  = {min=20,  max=60},
    synth  = {min=10,  max=40},
    keys   = {min=10,  max=40},
    piano  = {min=20,  max=60},
    organ  = {min=10,  max=40},
    arp    = {min=20,  max=60},
    chord  = {min=10,  max=40},

    -- GUITARS / ORCHESTRA
    guitar = {min=30,  max=70},
    strings= {min=20,  max=60},
    violin = {min=20,  max=60},
    cello  = {min=10,  max=40},
    brass  = {min=10,  max=40},
    horn   = {min=10,  max=40},
    flute  = {min=20,  max=60},

    -- FX
    impact = {min=0,   max=0},
    riser  = {min=20,  max=80},
    sweep  = {min=20,  max=80},
    noise  = {min=20,  max=80},
    whoosh = {min=20,  max=80},
}


local function get_pan_color(inst, pan)
    if not helper_mode then
        return reaper.ImGui_ColorConvertDouble4ToU32(1,1,1,1)
    end

    local rule = recommended_pan[inst]
    if not rule then
        return reaper.ImGui_ColorConvertDouble4ToU32(1,1,1,1)
    end

    if pan < rule.min then
        return reaper.ImGui_ColorConvertDouble4ToU32(0.95, 0.80, 0.40, 1) -- жёлтый
    elseif pan > rule.max then
        return reaper.ImGui_ColorConvertDouble4ToU32(0.90, 0.35, 0.35, 1) -- красный
    else
        return reaper.ImGui_ColorConvertDouble4ToU32(0.45, 0.85, 0.45, 1) -- зелёный
    end
end

local function get_hold_color(inst, hold)
    if not helper_mode then
        return reaper.ImGui_ColorConvertDouble4ToU32(1,1,1,1) -- белый
    end

    local rule = recommended_levels[inst]
    if not rule then
        return reaper.ImGui_ColorConvertDouble4ToU32(1,1,1,1)
    end

    if hold > rule.max then
        return reaper.ImGui_ColorConvertDouble4ToU32(0.90, 0.35, 0.35, 1) -- мягкий красный (Logic)
    elseif hold < rule.min then
        return reaper.ImGui_ColorConvertDouble4ToU32(0.95, 0.80, 0.40, 1) -- мягкий жёлтый (Logic)
    else
        return reaper.ImGui_ColorConvertDouble4ToU32(0.45, 0.85, 0.45, 1) -- мягкий зелёный (Logic)
    end
end


------------------------------------------------------------
-- USER MAPPINGS (groups & instruments, saved in ExtState)
------------------------------------------------------------

local user_groups = {}      -- guid -> group
local user_instruments = {} -- guid -> instrument

local function load_user_maps()
    local s = reaper.GetExtState("MixInspector", "UserGroups")
    if s and s ~= "" then
        for guid, group in s:gmatch("({[%w%-]+})=([%w_]+);") do
            user_groups[guid] = group
        end
    end

    local si = reaper.GetExtState("MixInspector", "UserInstruments")
    if si and si ~= "" then
        for guid, inst in si:gmatch("({[%w%-]+})=([%w_]+);") do
            user_instruments[guid] = inst
        end
    end
end

local function save_user_maps()
    local parts = {}
    for guid, group in pairs(user_groups) do
        parts[#parts+1] = guid .. "=" .. group .. ";"
    end
    reaper.SetExtState("MixInspector", "UserGroups", table.concat(parts), true)

    parts = {}
    for guid, inst in pairs(user_instruments) do
        parts[#parts+1] = guid .. "=" .. inst .. ";"
    end
    reaper.SetExtState("MixInspector", "UserInstruments", table.concat(parts), true)
end

load_user_maps()

------------------------------------------------------------
-- GROUP ORDER
------------------------------------------------------------

local group_order = {
  drums = 1,
  bass = 2,
  music = 3,
  vocals = 4,
  fx = 5,
  other = 6
}

------------------------------------------------------------
-- INSTRUMENT PRIORITY
------------------------------------------------------------

local instrument_priority = {
  kick=1, snare=2, clap=3, hat=4, perc=5, tom=6, ride=7, crash=8,
  bass=1, sub=2, ["808"]=3,
  lead=1, chord=2, pad=3, arp=4, synth=5, pluck=6, keys=7, piano=8, guitar=9,
  vox=1, vocal=1, backvox=2, choir=3,
  impact=1, riser=2, sweep=3, noise=4, whoosh=5,
  strings=1, violin=2, cello=3, brass=4, horn=5, flute=6
}

------------------------------------------------------------
-- GROUP DETECTION (auto, with user override)
------------------------------------------------------------

local function detect_group(name, guid)
    if guid and user_groups[guid] then
        return user_groups[guid]
    end

    name = string.lower(name or "")

    -- DRUMS / PERCUSSION
    if name:find("kick")
    or name:find("snare")
    or name:find("clap")
    or name:find("hat")
    or name:find("hihat")
    or name:find("ride")
    or name:find("crash")
    or name:find("tom")
    or name:find("rim")
    or name:find("perc")
    or name:find("drum")
    or name:find("shaker")
    or name:find("tamb")
    or name:find("cowbell")
    then return "drums" end

    -- BASS
    if name:find("bass")
    or name:find("sub")
    or name:find("808")
    then return "bass" end

    -- VOCALS
    if name:find("vox")
    or name:find("vocal")
    or name:find("lead vocal")
    or name:find("back")
    or name:find("choir")
    then return "vocals" end

    -- FX
    if name:find("fx")
    or name:find("impact")
    or name:find("riser")
    or name:find("sweep")
    or name:find("noise")
    or name:find("whoosh")
    or name:find("drop")
    then return "fx" end

    -- MUSIC (synths, keys, guitars, pads, strings)
    if name:find("lead")
    or name:find("synth")
    or name:find("pad")
    or name:find("pluck")
    or name:find("keys")
    or name:find("piano")
    or name:find("epiano")
    or name:find("organ")
    or name:find("guitar")
    or name:find("strum")
    or name:find("chord")
    or name:find("arp")
    or name:find("string")
    or name:find("violin")
    or name:find("cello")
    or name:find("brass")
    or name:find("horn")
    or name:find("flute")
    then return "music" end

    return "other"
end

------------------------------------------------------------
-- INSTRUMENT DETECTION (auto, with user override)
------------------------------------------------------------

local function detect_instrument(name, guid)
    if guid and user_instruments[guid] then
        return user_instruments[guid]
    end

    name = string.lower(name or "")

    -- DRUMS
    if name:find("kick") then return "kick" end
    if name:find("snare") then return "snare" end
    if name:find("clap") then return "clap" end
    if name:find("hat") or name:find("hihat") then return "hat" end
    if name:find("tom") then return "tom" end
    if name:find("ride") then return "ride" end
    if name:find("crash") then return "crash" end
    if name:find("perc") then return "perc" end

    -- BASS
    if name:find("bass") then return "bass" end
    if name:find("sub") then return "sub" end
    if name:find("808") then return "808" end

    -- VOCALS
    if name:find("vocal") or name:find("vox") then return "vocal" end
    if name:find("back") then return "backvox" end
    if name:find("choir") then return "choir" end

    -- SYNTHS / KEYS
    if name:find("lead") then return "lead" end
    if name:find("synth") then return "synth" end
    if name:find("pad") then return "pad" end
    if name:find("pluck") then return "pluck" end
    if name:find("keys") then return "keys" end
    if name:find("piano") then return "piano" end
    if name:find("organ") then return "organ" end
    if name:find("arp") then return "arp" end
    if name:find("chord") then return "chord" end

    -- GUITARS
    if name:find("guitar") then return "guitar" end
    if name:find("strum") then return "strum" end

    -- ORCHESTRA
    if name:find("string") then return "strings" end
    if name:find("violin") then return "violin" end
    if name:find("cello") then return "cello" end
    if name:find("brass") then return "brass" end
    if name:find("horn") then return "horn" end
    if name:find("flute") then return "flute" end

    -- FX
    if name:find("impact") then return "impact" end
    if name:find("riser") then return "riser" end
    if name:find("sweep") then return "sweep" end
    if name:find("noise") then return "noise" end
    if name:find("whoosh") then return "whoosh" end

    return "other"
end

------------------------------------------------------------
-- FREQ UTIL
------------------------------------------------------------

local function freq_to_percent(freq)
    local MIN_FREQ = 10
    local MAX_FREQ = 22050
    local FREQ_LOG_MAX = math.log(MAX_FREQ / MIN_FREQ)
    return (math.log(freq / MIN_FREQ) / FREQ_LOG_MAX) * 100
end

------------------------------------------------------------
-- DB UTILS
------------------------------------------------------------

local function db(x)
  if not x or x <= 0 then return -150 end
  return 20 * math.log(x,10)
end

local function db_to_lin(dbv)
  return 10^(dbv/20)
end

local function lin_to_db(lin)
  if lin <= 0 then return -150 end
  return 20 * math.log(lin,10)
end

------------------------------------------------------------
-- PAN UTILS
------------------------------------------------------------

local function pan_to_percent(p)
  return p * 100
end

local function percent_to_pan(v)
  return v / 100
end

------------------------------------------------------------
-- MASTER HOLD
------------------------------------------------------------

local function get_master_peak()
  local master = reaper.GetMasterTrack(0)
  local peak = reaper.Track_GetPeakInfo(master,0) or 0
  local current_db = db(peak)

  if current_db > master_hold then
    master_hold = current_db
    master_hold_time = reaper.time_precise()
  else
    if reaper.time_precise() - master_hold_time > hold_time then
      master_hold = master_hold - 0.5
    end
  end

  return master_hold
end

------------------------------------------------------------
-- MASTER COLOR
------------------------------------------------------------

local function master_color(db_val)
  if db_val > -1 then
    return reaper.ImGui_ColorConvertDouble4ToU32(1,0.3,0.3,1)
  elseif db_val > -3 then
    return reaper.ImGui_ColorConvertDouble4ToU32(1,0.8,0.2,1)
  else
    return reaper.ImGui_ColorConvertDouble4ToU32(0.4,1,0.4,1)
  end
end

------------------------------------------------------------
-- FX RENAME HELPER
------------------------------------------------------------

local function rename_fx(track, fx, new_name)
    reaper.TrackFX_SetNamedConfigParm(track, fx, "renamed_name", new_name)
    reaper.TrackList_AdjustWindows(false)
end

------------------------------------------------------------
-- MASTER MONITORING FILTER (ReEQ)
------------------------------------------------------------

local function ensure_master_reeq()
    local master = reaper.GetMasterTrack(0)
    local fx_count = reaper.TrackFX_GetCount(master)
    local found_idx = -1

    for i = 0, fx_count - 1 do
        local ok, fx_name = reaper.TrackFX_GetNamedConfigParm(master, i, "fx_name")
        if ok and fx_name and fx_name:find("ReEQ") then
            found_idx = i
            break
        end
    end

    if found_idx >= 0 then
        rename_fx(master, found_idx, "Mix Inspector EQ")
        return master, found_idx
    end

    local fx = reaper.TrackFX_AddByName(master, "JS: ReEQ - Parametric Graphic Equalizer", false, -1)
    rename_fx(master, fx, "Mix Inspector EQ")

    return master, fx
end

------------------------------------------------------------
-- FILTER CONTROL (ReEQ 1.2.0)
------------------------------------------------------------

local function set_filter(mode)
    active_filter = mode

    local master, fx = ensure_master_reeq()
    if fx < 0 then return end

    local p_enabled = 17
    local p_type    = 19
    local p_freq    = 20
    local p_gain    = 21
    local p_q       = 22
    local p_slope   = 23

    if mode == "off" then
        reaper.TrackFX_SetParam(master, fx, p_enabled, 0)
        return
    end

    reaper.TrackFX_SetParam(master, fx, p_enabled, 2)
    reaper.TrackFX_SetParam(master, fx, p_gain, 0)
    reaper.TrackFX_SetParam(master, fx, p_q, 35)
    reaper.TrackFX_SetParam(master, fx, p_slope, 3)

    local function set_freq(hz)
        local val = freq_to_percent(hz)
        if val then
            reaper.TrackFX_SetParam(master, fx, p_freq, val)
        end
    end

    local TYPE = {
        PEAK = 0,
        HP = 1,
        HP_BW = 2,
        LOW_SHELF = 3,
        HIGH_SHELF = 4,
        LP = 5,
        LP_BW = 6,
        NOTCH = 7,
        BP = 8,
        TILT = 9,
        PULTEC = 10,
        ALLPASS = 11,
        HP_ANALOG = 12,
        LP_ANALOG = 13
    }

    if mode == "sub" then
        reaper.TrackFX_SetParam(master, fx, p_type, TYPE.LP_BW)
        set_freq(160)

    elseif mode == "lowmid" then
        reaper.TrackFX_SetParam(master, fx, p_type, TYPE.BP)
        set_freq(350)

    elseif mode == "mid" then
        reaper.TrackFX_SetParam(master, fx, p_type, TYPE.BP)
        set_freq(1200)

    elseif mode == "presence" then
        reaper.TrackFX_SetParam(master, fx, p_type, TYPE.BP)
        set_freq(4000)

    elseif mode == "air" then
        reaper.TrackFX_SetParam(master, fx, p_type, TYPE.BP)
        set_freq(14000)
    end
end

------------------------------------------------------------
-- SORT
------------------------------------------------------------

local function sort_results()
  if sort_mode == 0 then return end

  table.sort(results,function(a,b)
    local ga = group_order[a.group] or 99
    local gb = group_order[b.group] or 99
    if ga ~= gb then return ga < gb end

    local pa = instrument_priority[a.inst] or 99
    local pb = instrument_priority[b.inst] or 99
    if pa ~= pb then return pa < pb end

    return a.name < b.name
  end)
end

------------------------------------------------------------
-- ANALYZE
------------------------------------------------------------

local function analyze()
  results = {}

  local track_count = reaper.CountTracks(0)

  for i=0,track_count-1 do
    local track = reaper.GetTrack(0,i)
    local _, name = reaper.GetTrackName(track)

    local id = tostring(track)
    local guid = reaper.GetTrackGUID(track)

    local peak = reaper.Track_GetPeakInfo(track,0) or 0

    peak_history[id] = peak_history[id] or {}

    table.insert(peak_history[id],{
      time=reaper.time_precise(),
      peak=peak
    })

    local filtered={}
    local now=reaper.time_precise()

    for _,v in ipairs(peak_history[id]) do
      if now-v.time<=window_seconds then
        table.insert(filtered,v)
      end
    end

    peak_history[id]=filtered

    local max_peak=0

    for _,v in ipairs(filtered) do
      if v.peak>max_peak then
        max_peak=v.peak
      end
    end

    local peak_db=db(max_peak)

    local hold_db=hold_values[id] or -150
    local current_db=db(peak)

    if current_db>hold_db then
      hold_db=current_db
      hold_values[id]=hold_db
      hold_values[id.."_time"]=reaper.time_precise()
    else
      local t=hold_values[id.."_time"] or 0
      if reaper.time_precise()-t>hold_time then
        hold_db=hold_db-0.5
        hold_values[id]=hold_db
      end
    end

    local col=reaper.GetMediaTrackInfo_Value(track,"I_CUSTOMCOLOR") or 0
    col=math.floor(col)

    if (col & 0x1000000)~=0 then
      col=col & 0xFFFFFF
    end

    local r=(col>>16)&0xFF
    local g=(col>>8)&0xFF
    local b=col&0xFF

    local color_u32=reaper.ImGui_ColorConvertDouble4ToU32(r/255,g/255,b/255,1)

    local group = detect_group(name, guid)
    local inst  = detect_instrument(name, guid)

    table.insert(results,{
      track=track,
      name=name,
      peak=peak_db,
      hold=hold_db,
      id=id,
      guid=guid,
      color=color_u32,
      group=group,
      inst=inst
    })
  end

  sort_results()
end


local function build_group_summary()
    local summary = {}

    for g,_ in pairs(group_order) do
        summary[g] = {
            tracks = {},
            peak = -150,
            hold = -150,
            vol_sum = 0,
            pan_sum = 0,
            count = 0
        }
    end

    for _,row in ipairs(results) do
        local g = row.group
        local s = summary[g]

        table.insert(s.tracks, row.track)

        if row.peak > s.peak then s.peak = row.peak end
        if row.hold > s.hold then s.hold = row.hold end

        local vol = lin_to_db(reaper.GetMediaTrackInfo_Value(row.track,"D_VOL"))
        s.vol_sum = s.vol_sum + vol

        local pan = pan_to_percent(reaper.GetMediaTrackInfo_Value(row.track,"D_PAN"))
        s.pan_sum = s.pan_sum + pan

        s.count = s.count + 1
    end

    return summary
end

local function is_group_solo(g)
    local group_has_solo = true
    local others_have_solo = false

    for _,row in ipairs(results) do
        local solo = reaper.GetMediaTrackInfo_Value(row.track,"I_SOLO") > 0

        if row.group == g then
            if not solo then group_has_solo = false end
        else
            if solo then others_have_solo = true end
        end
    end

    return group_has_solo and not others_have_solo
end

local function is_group_muted(g)
    for _,row in ipairs(results) do
        if row.group == g then
            if reaper.GetMediaTrackInfo_Value(row.track,"B_MUTE") == 0 then
                return false
            end
        end
    end
    return true
end



local function draw_group_table()
    local summary = build_group_summary()

    reaper.ImGui_TableSetupColumn(ctx,"Group")
    reaper.ImGui_TableSetupColumn(ctx,"Peak")
    reaper.ImGui_TableSetupColumn(ctx,"Hold")
    reaper.ImGui_TableSetupColumn(ctx,"Avg Vol")
    reaper.ImGui_TableSetupColumn(ctx,"Avg Pan")
    reaper.ImGui_TableSetupColumn(ctx,"S", reaper.ImGui_TableColumnFlags_WidthFixed(), 22)
    reaper.ImGui_TableSetupColumn(ctx,"M", reaper.ImGui_TableColumnFlags_WidthFixed(), 22)

    reaper.ImGui_TableHeadersRow(ctx)

    for g,_ in pairs(group_order) do
        local s = summary[g]

        reaper.ImGui_TableNextRow(ctx)

        -- Group name
        reaper.ImGui_TableSetColumnIndex(ctx,0)
        reaper.ImGui_Text(ctx, string.upper(g))

        -- Peak
        reaper.ImGui_TableSetColumnIndex(ctx,1)
        reaper.ImGui_Text(ctx, string.format("%.1f", s.peak))

        -- Hold
        reaper.ImGui_TableSetColumnIndex(ctx,2)
        reaper.ImGui_Text(ctx, string.format("%.1f", s.hold))

        -- Avg Volume
        reaper.ImGui_TableSetColumnIndex(ctx,3)
        if s.count > 0 then
            reaper.ImGui_Text(ctx, string.format("%.1f", s.vol_sum / s.count))
        else
            reaper.ImGui_Text(ctx, "-")
        end

        -- Avg Pan
        reaper.ImGui_TableSetColumnIndex(ctx,4)
        if s.count > 0 then
            reaper.ImGui_Text(ctx, string.format("%.0f%%", s.pan_sum / s.count))
        else
            reaper.ImGui_Text(ctx, "-")
        end

       -- GROUP SOLO (toggle)
       reaper.ImGui_TableSetColumnIndex(ctx,5)
       
       local solo_active = is_group_solo(g)
       
       -- Цвета как у обычного SOLO
       local solo_col     = reaper.ImGui_ColorConvertDouble4ToU32(0.55, 0.50, 0.20, 1)
       local solo_col_act = reaper.ImGui_ColorConvertDouble4ToU32(0.80, 0.70, 0.25, 1)
       
       reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Button(), solo_active and solo_col_act or solo_col)
       
       if reaper.ImGui_Button(ctx, "S##"..g) then
           local active = is_group_solo(g)
       
           for _,row in ipairs(results) do
               if active then
                   reaper.SetMediaTrackInfo_Value(row.track,"I_SOLO",0)
               else
                   if row.group == g then
                       reaper.SetMediaTrackInfo_Value(row.track,"I_SOLO",1)
                   else
                       reaper.SetMediaTrackInfo_Value(row.track,"I_SOLO",0)
                   end
               end
           end
       end
       
       reaper.ImGui_PopStyleColor(ctx)
       
        

       -- GROUP MUTE (toggle)
       reaper.ImGui_TableSetColumnIndex(ctx,6)
       
       local mute_active = is_group_muted(g)
       
       -- Цвета как у обычного MUTE
       local mute_col     = reaper.ImGui_ColorConvertDouble4ToU32(0.45, 0.25, 0.25, 1)
       local mute_col_act = reaper.ImGui_ColorConvertDouble4ToU32(0.75, 0.30, 0.30, 1)
       
       reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Button(), mute_active and mute_col_act or mute_col)
       
       if reaper.ImGui_Button(ctx, "M##"..g) then
           local active = is_group_muted(g)
       
           for _,row in ipairs(results) do
               if row.group == g then
                   reaper.SetMediaTrackInfo_Value(row.track,"B_MUTE", active and 0 or 1)
               end
           end
       end
       
       reaper.ImGui_PopStyleColor(ctx)
       
        
    end
end


------------------------------------------------------------
-- TABLE
------------------------------------------------------------

local function draw_table()
  if reaper.ImGui_BeginTable(ctx,"mix",7) then
  
  if group_view then
      draw_group_table()
      reaper.ImGui_EndTable(ctx)
      return
  end
  

    reaper.ImGui_TableSetupColumn(ctx,"Track", reaper.ImGui_TableColumnFlags_WidthFixed(), 180)
    reaper.ImGui_TableSetupColumn(ctx,"S", reaper.ImGui_TableColumnFlags_WidthFixed(), 22)
    reaper.ImGui_TableSetupColumn(ctx,"M", reaper.ImGui_TableColumnFlags_WidthFixed(), 22)
    reaper.ImGui_TableSetupColumn(ctx,"Peak", reaper.ImGui_TableColumnFlags_WidthFixed(), 65)
    reaper.ImGui_TableSetupColumn(ctx,"Hold", reaper.ImGui_TableColumnFlags_WidthFixed(), 85)
    
    reaper.ImGui_TableSetupColumn(ctx,"Volume", reaper.ImGui_TableColumnFlags_WidthFixed(), 85)
    reaper.ImGui_TableSetupColumn(ctx,"Pan", reaper.ImGui_TableColumnFlags_WidthFixed(), 100)
    

    reaper.ImGui_TableHeadersRow(ctx)

    local last_group=nil

    for _,row in ipairs(results) do
    
        if show_only_problems and helper_mode then
            local bad = false
    
            -- громкость
            local ruleL = recommended_levels[row.inst]
            if ruleL and (row.hold < ruleL.min or row.hold > ruleL.max) then
                bad = true
            end
    
            -- панорама
            local pan = pan_to_percent(reaper.GetMediaTrackInfo_Value(row.track,"D_PAN"))
            local ruleP = recommended_pan[row.inst]
            if ruleP and (pan < ruleP.min or pan > ruleP.max) then
                bad = true
            end
    
            if not bad then
                goto continue
            end
        end
    

      if sort_mode==1 and row.group~=last_group then
        reaper.ImGui_TableNextRow(ctx)
        reaper.ImGui_TableSetColumnIndex(ctx,0)
        reaper.ImGui_Text(ctx,"──── "..string.upper(row.group).." ────")
        last_group=row.group
      end

      reaper.ImGui_TableNextRow(ctx)

      reaper.ImGui_TableSetColumnIndex(ctx,0)

      -- Цветовая полоса во всю высоту строки (10 px)
      local dl = reaper.ImGui_GetWindowDrawList(ctx)
      local x, y = reaper.ImGui_GetCursorScreenPos(ctx)
      local row_height = reaper.ImGui_GetTextLineHeight(ctx) + 6
      local bar_width = 10

      reaper.ImGui_DrawList_AddRectFilled(
          dl,
          x, y,
          x + bar_width, y + row_height,
          row.color
      )

      -- Сдвигаем курсор вправо после полосы
      reaper.ImGui_SetCursorScreenPos(ctx, x + bar_width + 6, y)

      -- Имя трека (ЛКМ — выбрать, ПКМ — контекстное меню)
      if reaper.ImGui_Button(ctx,row.name.."##"..row.id) then
        reaper.SetOnlyTrackSelected(row.track)
        reaper.Main_OnCommand(40913,0)
      end
      
      
      -- Открываем контекстное меню по ПКМ
      reaper.ImGui_OpenPopupOnItemClick(ctx, "ctx_menu_" .. row.id, 1)
      
      if reaper.ImGui_BeginPopup(ctx, "ctx_menu_" .. row.id) then
      
        if reaper.ImGui_BeginMenu(ctx, "Assign group") then
            local function group_item(label, key)
                local selected = (user_groups[row.guid] == key)
                if reaper.ImGui_MenuItem(ctx, label, nil, selected) then
                    user_groups[row.guid] = key
                    save_user_maps()
                    row.group = key
                    sort_results()
                end
            end
      
            group_item("Drums",  "drums")
            group_item("Bass",   "bass")
            group_item("Music",  "music")
            group_item("Vocals", "vocals")
            group_item("FX",     "fx")
            group_item("Other",  "other")
      
            reaper.ImGui_EndMenu(ctx)
        end
      
        if reaper.ImGui_BeginMenu(ctx, "Assign instrument") then
            local function inst_item(label, key)
                local selected = (user_instruments[row.guid] == key)
                if reaper.ImGui_MenuItem(ctx, label, nil, selected) then
                    user_instruments[row.guid] = key
                    save_user_maps()
                    row.inst = key
                    sort_results()
                end
            end
      
            -- Drums
            inst_item("Kick",   "kick")
            inst_item("Snare",  "snare")
            inst_item("Clap",   "clap")
            inst_item("Hat",    "hat")
            inst_item("Tom",    "tom")
            inst_item("Ride",   "ride")
            inst_item("Crash",  "crash")
            inst_item("Perc",   "perc")
      
            reaper.ImGui_Separator(ctx)
      
            -- Bass
            inst_item("Bass",   "bass")
            inst_item("Sub",    "sub")
            inst_item("808",    "808")
      
            reaper.ImGui_Separator(ctx)
      
            -- Synths / Keys
            inst_item("Lead",   "lead")
            inst_item("Pad",    "pad")
            inst_item("Pluck",  "pluck")
            inst_item("Synth",  "synth")
            inst_item("Keys",   "keys")
            inst_item("Piano",  "piano")
            inst_item("Organ",  "organ")
            inst_item("Arp",    "arp")
            inst_item("Chord",  "chord")
      
            reaper.ImGui_Separator(ctx)
      
            -- Guitars / Orchestra
            inst_item("Guitar", "guitar")
            inst_item("Strings","strings")
            inst_item("Violin", "violin")
            inst_item("Cello",  "cello")
            inst_item("Brass",  "brass")
            inst_item("Horn",   "horn")
            inst_item("Flute",  "flute")
      
            reaper.ImGui_Separator(ctx)
      
            -- Vocals / FX
            inst_item("Vocal",  "vocal")
            inst_item("Back Vox","backvox")
            inst_item("Choir",  "choir")
            inst_item("Impact", "impact")
            inst_item("Riser",  "riser")
            inst_item("Sweep",  "sweep")
            inst_item("Noise",  "noise")
            inst_item("Whoosh", "whoosh")
      
            reaper.ImGui_EndMenu(ctx)
        end
      
        reaper.ImGui_Separator(ctx)
      
        if reaper.ImGui_MenuItem(ctx, "Reset to auto-detect") then
            user_groups[row.guid] = nil
            user_instruments[row.guid] = nil
            save_user_maps()
            row.group = detect_group(row.name, row.guid)
            row.inst  = detect_instrument(row.name, row.guid)
            sort_results()
        end
      
        reaper.ImGui_EndPopup(ctx)
      end
      
      
      
      
      ------------------------------------------------------------
      -- COLUMN 1 — SOLO
      ------------------------------------------------------------
      ------------------------------------------------------------
      -- SOLO BUTTON (yellow)
      ------------------------------------------------------------
      reaper.ImGui_TableSetColumnIndex(ctx,1)
      
      local solo = reaper.GetMediaTrackInfo_Value(row.track, "I_SOLO")
      local solo_active = (solo > 0)
      
      -- Цвета
      local solo_col     = reaper.ImGui_ColorConvertDouble4ToU32(0.55, 0.50, 0.20, 1)   -- жёлтый
      local solo_col_act = reaper.ImGui_ColorConvertDouble4ToU32(0.80, 0.70, 0.25, 1)   -- активный жёлтый
      
      -- Применяем цвет
      reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Button(), solo_active and solo_col_act or solo_col)
      
      if reaper.ImGui_Button(ctx, "S##solo" .. row.id) then
          reaper.SetMediaTrackInfo_Value(row.track, "I_SOLO", solo_active and 0 or 1)
      end
      
      reaper.ImGui_PopStyleColor(ctx)
      
      
      ------------------------------------------------------------
      -- COLUMN 2 — MUTE
      ------------------------------------------------------------
      ------------------------------------------------------------
      -- MUTE BUTTON (red)
      ------------------------------------------------------------
      reaper.ImGui_TableSetColumnIndex(ctx,2)
      
      local mute = reaper.GetMediaTrackInfo_Value(row.track, "B_MUTE")
      local mute_active = (mute > 0)
      
      -- Цвета
      local mute_col     = reaper.ImGui_ColorConvertDouble4ToU32(0.45, 0.25, 0.25, 1)   -- красный
      local mute_col_act = reaper.ImGui_ColorConvertDouble4ToU32(0.75, 0.30, 0.30, 1)   -- активный красный
      
      -- Применяем цвет
      reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Button(), mute_active and mute_col_act or mute_col)
      
      if reaper.ImGui_Button(ctx, "M##mute" .. row.id) then
          reaper.SetMediaTrackInfo_Value(row.track, "B_MUTE", mute_active and 0 or 1)
      end
      
      reaper.ImGui_PopStyleColor(ctx)
      
      
      

      

      reaper.ImGui_TableSetColumnIndex(ctx,3)
      reaper.ImGui_Text(ctx,string.format("%.1f dB",row.peak))

      reaper.ImGui_TableSetColumnIndex(ctx,4)
      
      reaper.ImGui_TableSetColumnIndex(ctx,4)
      
      local col = get_hold_color(row.inst, row.hold)
      reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Text(), col)
      
      local hold_label = string.format("%.1f dB", row.hold)
      reaper.ImGui_Text(ctx, hold_label)
      
      if reaper.ImGui_IsItemHovered(ctx) then
          local rule = recommended_levels[row.inst]
          if rule then
              reaper.ImGui_BeginTooltip(ctx)
              reaper.ImGui_Text(ctx, row.inst)
              reaper.ImGui_Text(ctx, string.format("Recommended: %.1f…%.1f dB", rule.min, rule.max))
              reaper.ImGui_Text(ctx, "Current: " .. hold_label)
              reaper.ImGui_EndTooltip(ctx)
          end
      end
      
      reaper.ImGui_PopStyleColor(ctx)
      
      

      reaper.ImGui_TableSetColumnIndex(ctx,5)
      
      row.vol_text=row.vol_text or ""
      
      local vol=reaper.GetMediaTrackInfo_Value(row.track,"D_VOL")
      local db_val=lin_to_db(vol)
      
      if row.vol_text=="" then
          row.vol_text=string.format("%.1f",db_val)
      end
      
      reaper.ImGui_SetNextItemWidth(ctx, 45)
      
      local changed,new_text=
          reaper.ImGui_InputText(ctx,"##vol"..row.id,row.vol_text,reaper.ImGui_InputTextFlags_EnterReturnsTrue())
      
      
      if changed then
          row.vol_text=new_text
          local new_db=tonumber(new_text)
      
          if new_db then
              reaper.SetMediaTrackInfo_Value(row.track,"D_VOL",db_to_lin(new_db))
          end
      end
      
      -- <<< ВОТ ЗДЕСЬ FIX >>>
      reaper.ImGui_SameLine(ctx)
      
      if helper_mode and recommended_levels[row.inst] then
          if reaper.ImGui_Button(ctx, "Fix##fixvol"..row.id) then
              local rule = recommended_levels[row.inst]
              local target = (rule.min + rule.max) / 2
              reaper.SetMediaTrackInfo_Value(row.track, "D_VOL", db_to_lin(target))
              row.vol_text = string.format("%.1f", target)
          end
      end
      -- <<< ДО СЮДА >>>
      

      reaper.ImGui_TableSetColumnIndex(ctx,6)
      
      row.pan_text = row.pan_text or ""
      
      local pan = reaper.GetMediaTrackInfo_Value(row.track,"D_PAN")
      local pan_percent = pan_to_percent(pan)
      
      if row.pan_text == "" then
          row.pan_text = string.format("%.0f", pan_percent)
      end
      
      -- Цвет подсветки (Mix Helper)
      local col = get_pan_color(row.inst, pan_percent)
      reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Text(), col)
      
      reaper.ImGui_SetNextItemWidth(ctx, 45)
      
      local changed_pan,new_text_pan=
          reaper.ImGui_InputText(ctx,"##pan"..row.id,row.pan_text,reaper.ImGui_InputTextFlags_EnterReturnsTrue())
      
      
      reaper.ImGui_PopStyleColor(ctx)
      
      -- Tooltip при наведении
      if reaper.ImGui_IsItemHovered(ctx) then
          local rule = recommended_pan[row.inst]
          if rule then
              reaper.ImGui_BeginTooltip(ctx)
              reaper.ImGui_Text(ctx, row.inst)
              reaper.ImGui_Text(ctx, string.format("Recommended pan: %d…%d%%", rule.min, rule.max))
              reaper.ImGui_Text(ctx, string.format("Current: %.0f%%", pan_percent))
              reaper.ImGui_EndTooltip(ctx)
          end
      end
      
      -- Обработка изменения панорамы
      if changed_pan then
          row.pan_text = new_text_pan
          local new_pan = tonumber(new_text_pan)
      
          if new_pan then
              if new_pan > 100 then new_pan = 100 end
              if new_pan < -100 then new_pan = -100 end
              reaper.SetMediaTrackInfo_Value(row.track,"D_PAN",percent_to_pan(new_pan))
          end
      end
      
      reaper.ImGui_SameLine(ctx)
      
      if helper_mode and recommended_pan[row.inst] then
          if reaper.ImGui_Button(ctx, "Fix##fixpan"..row.id) then
              local rule = recommended_pan[row.inst]
              local target = (rule.min + rule.max) / 2
              reaper.SetMediaTrackInfo_Value(row.track, "D_PAN", percent_to_pan(target))
              row.pan_text = string.format("%.0f", target)
          end
      end
      

      reaper.ImGui_SameLine(ctx)

      if reaper.ImGui_Button(ctx,"C##"..row.id) then
        reaper.SetMediaTrackInfo_Value(row.track,"D_PAN",0)
        row.pan_text="0"
      end
      
       ::continue::

    end

    reaper.ImGui_EndTable(ctx)

  end
  
 
  
end


------------------------------------------------------------
-- UI
------------------------------------------------------------

local function top_bar()

  if reaper.ImGui_Button(ctx,"Scan Mix") then analyze() end

  reaper.ImGui_SameLine(ctx)

  if reaper.ImGui_Button(ctx,live_mode and "Live: ON" or "Live: OFF") then
    live_mode=not live_mode
  end

  reaper.ImGui_SameLine(ctx)

  if reaper.ImGui_Button(ctx,sort_mode==0 and "Sort: Project" or "Sort: Groups") then
    sort_mode=1-sort_mode
    analyze()
  end
  
  reaper.ImGui_SameLine(ctx)
  
  if reaper.ImGui_Button(ctx, show_only_problems and "Problems Only: ON" or "Problems Only: OFF") then
      show_only_problems = not show_only_problems
  end
  
  
  reaper.ImGui_SameLine(ctx)
  
  if reaper.ImGui_Button(ctx, helper_mode and "Mix Helper: ON" or "Mix Helper: OFF") then
      helper_mode = not helper_mode
  end
  
  reaper.ImGui_SameLine(ctx)
  
  if reaper.ImGui_Button(ctx, group_view and "Group View: ON" or "Group View: OFF") then
      group_view = not group_view
  end
  
  

  reaper.ImGui_SameLine(ctx)

  reaper.ImGui_SetNextItemWidth(ctx,50)

  local changed,new_text=
    reaper.ImGui_InputText(ctx,"Peak(s)",window_text,reaper.ImGui_InputTextFlags_EnterReturnsTrue())

  if changed then

    window_text=new_text

    local v=tonumber(new_text)

    if v then

      if v<0.05 then v=0.05 end
      if v>5 then v=5 end

      window_seconds=v

    end

  end

  local master_peak=get_master_peak()

  reaper.ImGui_SameLine(ctx)

  local col=master_color(master_peak)

  reaper.ImGui_PushStyleColor(ctx,reaper.ImGui_Col_Text(),col)
  reaper.ImGui_Text(ctx,"Master "..string.format("%.1f dB",master_peak))
  reaper.ImGui_PopStyleColor(ctx)


  reaper.ImGui_Separator(ctx)
  reaper.ImGui_Text(ctx, "Monitoring Filters:")

  local function FilterButton(label, mode)
      local is_active = (active_filter == mode)

      if is_active then
          local col_btn = reaper.ImGui_ColorConvertDouble4ToU32(0.2, 0.8, 0.2, 1)
          reaper.ImGui_PushStyleColor(ctx, reaper.ImGui_Col_Button(), col_btn)
      end

      local clicked = reaper.ImGui_Button(ctx, label)

      if is_active then
          reaper.ImGui_PopStyleColor(ctx)
      end

      if clicked then
          set_filter(mode)
      end
  end

  FilterButton("Sub Check", "sub")
  reaper.ImGui_SameLine(ctx)
  FilterButton("Low-Mid", "lowmid")
  reaper.ImGui_SameLine(ctx)
  FilterButton("Mid", "mid")
  reaper.ImGui_SameLine(ctx)
  FilterButton("Presence", "presence")
  reaper.ImGui_SameLine(ctx)
  FilterButton("Air", "air")
  reaper.ImGui_SameLine(ctx)
  FilterButton("Off", "off")

  reaper.ImGui_Separator(ctx)

end

------------------------------------------------------------
-- LOOP
------------------------------------------------------------

local function loop()

  if live_mode then
    pcall(analyze)
  end

  local open = true

  local ok, err = pcall(function()

    local visible
    visible, open = reaper.ImGui_Begin(ctx, "mix Inspector by beyondway", true)

    if visible then
      top_bar()
      draw_table()
      reaper.ImGui_End(ctx)
    end

  end)

  if not ok then
    reaper.ShowConsoleMsg("ImGui error: "..tostring(err).."\n")
  end

  if open then
    reaper.defer(loop)
  else
    pcall(reaper.ImGui_DestroyContext, ctx)
    _G["MIX_INSPECTOR_CTX"] = nil
  end

end

pcall(analyze)
reaper.defer(loop)

