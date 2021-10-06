function sprops = signal_properties(radar_data)
% Function to read radar data and calculate basic signal properties.
%
    c = 299792458;   % speed of ligth [m/s]
    data_len = length(radar_data.DATA1);
    waveform = radar_data.WAVEFORM;
    
    tol = 1e-4;
    
    if waveform=='FMCW_SAWTOOTH'
        % Sweep
        SweepTime = radar_data.SWEEPTIME / 1000; % [ms] -> [s]
        NTS = radar_data.samplenumberpersweep;
        NSweeps = data_len / NTS;  % Number of sweeps
        recordtime = NSweeps * SweepTime;   % [s] total time

        % Signal
        NPulses = NSweeps;
        f0 = radar_data.CENTERFREQUENCY;  % [Hz]
        BW = radar_data.BANDWIDTH; % [Hz]
        fslope     = BW/SweepTime;     % [Hz/s = 1/s^2]

        % Range
        NRanges = NTS;  % range gates = number 
        sampling_rate  = NTS/SweepTime;    % sampling freq (no. per second) [Hz]
        range_res = c/(2*BW);

        sampling_freq = 1/SweepTime;  % [Hz]
        IF_freq_max = sampling_rate;    % [Hz]
        maxRange = c*IF_freq_max / (2*fslope);   % Max. range [m]

        dR = (c/2/fslope)*sampling_freq; % [m] same as range resolution.
        dt = dR/c;

        nRanges = IF_freq_max / sampling_freq;
        range_max = nRanges*dR;
        
        if max([nRanges-NRanges, range_max-maxRange]) < tol
            sprops.DateTime = radar_data.DATE;
            sprops.SweepTime = SweepTime;
            sprops.RecordTime = recordtime;
            sprops.NTS = NTS;
            sprops.NSweeps = NSweeps;
            sprops.NPulses = NPulses;
            sprops.waveform = waveform;
            sprops.f0 = f0;
            sprops.BW = BW;
            sprops.fslope = fslope;
            sprops.NRanges = NRanges;
            sprops.SamplingRate = sampling_rate;
            sprops.SamplingFreq = sampling_freq;
            sprops.RangeRes = range_res;
            sprops.RangeMax = maxRange;
            sprops.dR = dR;
            sprops.dt = dt;
        else
            disp(nRanges==NRanges); disp(NRanges); disp(range_max==maxRange); disp(maxRange);
            error("Calculations failed")
        end
    end

end