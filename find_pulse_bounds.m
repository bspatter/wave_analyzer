function pulse_bounds = find_pulse_bounds(t,p)   
% FIND_PULSE_BOUNDS:
% GOAL: Finds the bounds of an ultrasound pulse based on the FDA definition of pulse definition
% INPUT: First argument is time, second argument is pressure
% OUTPUT: t0 = start time of pulse, tf = end time of pulse
% 
% REFERENCE: “Guidance for Industry and FDA Staff Information for Manufacturers Seeking Marketing Clearance of Diagnostic Ultrasound Systems and Transducers Preface Public Comment Additional Copies,” (2008). 
% pulse duration: 1.25 times the interval between the time when the time integral of intensity in an acoustic pulse at a point reaches 10 percent and when it reaches 90 percent of the pulse intensity integral.
% 
% NOTE: This assumes that the additional 0.25 portion of pulse duration (see definition above) is split evenly before and after the 10% and 90% portions of the pulse intensity integral.


pulse_energy_fraction = cumtrapz(t,p.^2)./trapz(t,p.^2);
t0i_temp = find(pulse_energy_fraction>0.1,1,'first');
tfi_temp = find(pulse_energy_fraction>0.9,1,'first');   
tp0_temp = t(t0i_temp);
tpf_temp = t(tfi_temp);
dt_pulse = (tpf_temp-tp0_temp)*1.25;
t0 = tp0_temp-dt_pulse*0.125;
tf = tpf_temp+dt_pulse*0.125;

pulse_bounds = [t0,tf];
% tp0i = find(t>tp0,1,'first');
% tpfi = find(t>tpf,1,'first');   
   