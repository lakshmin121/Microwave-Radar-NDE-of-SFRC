function pspectrum = power_spectrum(x, varargin)
% Frequency spectrum of signal.
% Use mode = '1-sided' or '2-sided'.
% Default '1-sided'.
% Multiply f in result with sampling frequency to obtain f values in
% physical units (Hz).
%
  
    mode = '1-sided';  % default value.
    numvarargs = length(varargin);  % number of optional arguments input by user.
    if numvarargs > 1
        error("Only one optional value for 'mode' accepted.");
    elseif numvarargs > 0
        mode = varargin;
    end
    
    L = length(x);  % Length of signal = Total time of aperiodic signal.
    % Fast Fourier Transform -> Spectrum.
    X = fft(x, L);  % FFT
    
    P2 = X/L;  % Amplitude (2-sided)
    f = (0:(L/2))/L;  % frequency steps;
    
    switch true
        case (strcmpi(mode,'2-sided')==1)
            pspectrum.P = P2;
            f2 = [fliplr(-f(1:end-1)), f(1:end-1)];
            pspectrum.f = f2;
        case (strcmpi(mode,'1-sided')==1)
            P1 = P2(1:L/2+1);
            P1(2:end-1) = 2*P1(2:end-1);
            pspectrum.P = P1;
            pspectrum.f = f;
        otherwise
            error("Invalid input for mode. Use '1-sided' or '2-sided'");
    end

end