--- Audio class
-- @module audio
-- @alias Audio

norns.version.audio = '0.0.2'

local Audio = {}

--- set headphone gain
-- @param gain (0-64)
Audio.headphone_gain = function(gain)
  gain_hp(gain)
end

--- set level for one input channel
-- @param channel (1 or 2)
-- @param level in [0, 1]
Audio.input_level = function(channel, level)
  _norns.level_adc(channel, level)
end

--- set level for *both* output channels
-- @param level in [0, 1]
Audio.output_level = function(level)
  _norns.level_dac(level)
end

Audio.level_ext = function(level)
  _norns.level_ext(level)
end

-- set monitor level for *both* input channels
-- @param level in [0, 1]
Audio.monitor_level = function(level)
  _norns.level_monitor(level)
end

--- set monitor mode to mono
--- both inputs will be mixed to both outputs
Audio.monitor_mono = function()
  _norns.monitor_mix_mono()
end

--- set monitor mode to stereo
--- each input will be monitored on the respective output
Audio.monitor_stereo = function()
  _norns.monitor_mix_stereo()
end

--- set tape level
-- @param level [0,1]
Audio.level_tape = function(level)
  _norns.level_tape(level)
end

--- enable input pitch analysis
Audio.pitch_on = function()
  audio_pitch_on()
end

--- disable input pitch analysis (saves CPU)
Audio.pitch_off = function()
  audio_pitch_off()
end

--- restart the audio engine (recompile sclang)
Audio.restart = function()
   restart_audio()
end




--- global functions
-- @section globals

--- callback for VU meters
--- scripts should redefine this
-- @param in1 input level 1 in [0, 63], audio taper
-- @param in2
-- @param out1
-- @param out2
Audio.vu = function(in1, in2, out1, out2)
   -- print (in1 .. '\t' .. in2 .. '\t' .. out1 .. '\t' .. out2)
end


--- helpers
-- @section helpers

--- set output level, clamped, save state
-- @param value audio level (0-64)
function Audio.set_audio_level(value)
  local l = util.clamp(value,0,64)
  if l ~= norns.state.out then
    norns.state.out = l
    Audio.output_level(l / 64.0)
  end
end

--- adjust output level, clamped, save state
-- @param delta amount to change output level
function Audio.adjust_output_level(delta)
  local l = util.clamp(norns.state.out + delta,0,64)
  if l ~= norns.state.out then
    norns.state.out = l
    Audio.output_level(l / 64.0)
  end
end


return Audio
