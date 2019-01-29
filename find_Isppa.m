function Isppa_510k = find_Isppa(time, pressure)
    % FIND_PULSE_FREQUENCY:
    % GOAL: Finds Isppa (W/cm^2) (i.e., the spatial peak pulse average intensity, where pulse defined based on the FDA 510(k) guidelines definition)
    % INPUT: First argument is time, second argument is pressure
    % OUTPUT: Isppa
    % 
    % REFERENCE: “Guidance for Industry and FDA Staff Information for Manufacturers Seeking Marketing Clearance of Diagnostic Ultrasound Systems and Transducers Preface Public Comment Additional Copies,” (2008). 
    % pulse duration: 1.25 times the interval between the time when the time integral of intensity in an acoustic pulse at a point reaches 10 percent and when it reaches 90 percent of the pulse intensity integral.
    % 
    % NOTE: This assumes that the additional 0.25 portion of pulse duration (see definition above) is split evenly before and after the 10% and 90% portions of the pulse intensity integral.
    %     This also assumes the sound speed and density of water
    time=time-time(1);
    pulse_bounds_510k = find_pulse_bounds(time,pressure);
    pulse_time_510k = time(time >= pulse_bounds_510k(1) & time <= pulse_bounds_510k(2));
    pulse_pressure_510k = pressure(time >= pulse_bounds_510k(1) & time <= pulse_bounds_510k(2));
    pulse_intensity = (pressure).^2/(1500*1000);
    pulse_intensity_510k = pulse_intensity(time >= pulse_bounds_510k(1) & time <= pulse_bounds_510k(2));
    pulse_duration_510k = range(pulse_bounds_510k);
    Isppa_510k = trapz(pulse_time_510k,pulse_intensity_510k)/pulse_duration_510k;
end