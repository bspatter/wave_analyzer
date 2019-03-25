
function [pulse_frequency, varargout] = find_pulse_frequency(pulse_time,pulse_pressure)   
% FIND_PULSE_FREQUENCY:
% GOAL: Finds the dominant frequency of the pulse (pulse defined based on the FDA definition of pulse definition)
% INPUT: First argument is time, second argument is pressure
% OUTPUT: pulse_frequency
% 
% REFERENCE: “Guidance for Industry and FDA Staff Information for Manufacturers Seeking Marketing Clearance of Diagnostic Ultrasound Systems and Transducers Preface Public Comment Additional Copies,” (2008). 
% pulse duration: 1.25 times the interval between the time when the time integral of intensity in an acoustic pulse at a point reaches 10 percent and when it reaches 90 percent of the pulse intensity integral.
% 
% NOTE: This assumes that the additional 0.25 portion of pulse duration (see definition above) is split evenly before and after the 10% and 90% portions of the pulse intensity integral.

pulse_time_adjusted = pulse_time-pulse_time(1); % start time from 0;
TimeTotal=range(pulse_time_adjusted); % Total time
SamplingFrequency = 1/mean(diff(pulse_time_adjusted)); % sampling frequency
N = round(TimeTotal*SamplingFrequency); %number of data points
N = round(N/2)*2; %force it to be even
TimeTotal = N/SamplingFrequency; %new total time domain length, if N changed
TimeFFT = (0:(N-1))/SamplingFrequency; % time vector (max(t) is 1 bin short of T)
FrequencySpectrum = (0:(N/2))/N*SamplingFrequency; %frequency vector (min(f)=0, the DC component. max(f) = fs/2 exactly)
FrequencySpectrum = FrequencySpectrum(:);
<<<<<<< HEAD


=======
>>>>>>> 95b56e3c2cf9579a25ccf21662829796006994b7
% Match pressure to output variables
if length(TimeFFT)==length(pulse_pressure)
    y = pulse_pressure;%function(t); %hypothetical time domain vector, length(y)=N
else
    y = interp1(pulse_time_adjusted,pulse_pressure, TimeFFT);%function(t); %hypothetical time domain vector, length(y)=N
end
PulsePressureFFT= bfft(y);
[~,pulse_frequency_index]=max(abs(PulsePressureFFT));
pulse_frequency = FrequencySpectrum(pulse_frequency_index);



varargout{1} = FrequencySpectrum;
varargout{2} = PulsePressureFFT;

PulsePressureFFT_real = PulsePressureFFT(1:floor(end*0.9));
% Find the center frequency according to FDA 510(k) guidelines (see 510(k) definitions of bandwidth, center frequency)
% The last 10% frequency bin is not included in f2 case the signal is over sampled.
f1i = find(abs(PulsePressureFFT_real)>max(abs(PulsePressureFFT_real))*0.71, 1,'first'); % 0.71 is -3 dB
f2i = find(abs(PulsePressureFFT_real(1:end-1))>(max(abs(PulsePressureFFT_real))*0.71), 1,'last');

f1 = FrequencySpectrum(f1i);
f2 = FrequencySpectrum(f2i);
fc = (f2+f1)/2;
PulseBandwidth = f2-f1;

% Fix for really narrowband signals
if f1==f2 && PulseBandwidth == 0
    f1b = interp1(abs(PulsePressureFFT_real((f1i-1):f1i)), FrequencySpectrum((f1i-1):f1i), max(abs(PulsePressureFFT_real))*0.71);
    f2b = interp1(abs(PulsePressureFFT_real(f2i:(f2i+1))), FrequencySpectrum(f2i:(f2i+1)), max(abs(PulsePressureFFT_real))*0.71);
    PulseBandwidth=f2b-f1b;
    fc = (f2b+f1b)/2;
end


varargout{3} = fc;

varargout{4} = PulseBandwidth;



