function varargout = wave_gui(varargin)
%WAVE_GUI - Graphical user interface for analyzing measured ultrasound data
% 
% 
%%
% 
% <<blank_gui_20180716.png>>
% 
% 
% WAVE_GUI MATLAB code for wave_gui.fig
%      WAVE_GUI, by itself, creates a new WAVE_GUI or raises the existing
%      singleton*.
%
%      H = WAVE_GUI returns the handle to a new WAVE_GUI or the handle to
%      the existing singleton*.
%
%      WAVE_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in WAVE_GUI.M with the given input arguments.
%
%      WAVE_GUI('Property','Value',...) creates a new WAVE_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before wave_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to wave_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help wave_gui

% Last Modified by GUIDE v2.5 07-Jun-2018 13:55:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @wave_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @wave_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before wave_gui is made visible.
function wave_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to wave_gui (see VARARGIN)

% Choose default command line output for wave_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This stuff runs at the very beginning.
handles.axes1.Box = 'on';
% Set width and height
handles.uitable2.ColumnWidth={125};
handles.uitable2.Position(3) = handles.uitable2.Extent(3);
handles.uitable2.Position(4) = handles.uitable2.Extent(4);


% --- Outputs from this function are returned to the command line.
function varargout = wave_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;




function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function [wave_data]=pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clean-up anything we might not want
clearstuff(handles)

if strcmpi(handles.edit1.String,'wave csv file')
    [file, path] = uigetfile({'*.csv';'*.*'},'File Selector');
    % edit1_Callback(hObject, eventdata, handles)
    handles.edit1.String=sprintf('%s%s',path,file);
end


filename = handles.edit1.String;

% read the input data from the csv file
[time,ch1] = read_input_data(filename);


% 
time_micro = time*1e6; % Time in microseconds

% voltage
ch1(isinf(ch1))=[]; %remove unreal values
voltage_mean = mean(ch1);
voltage_relative = ch1 - voltage_mean;

% sensitivity
calibration = str2double(handles.edit2.String); %(V/MPa)

% Pressure = ch1/calibration*1e6;
Pressure_MPa = voltage_relative/calibration;
Pressure = Pressure_MPa*1e6;



axes(handles.axes1)
handles.axes1.UserData.MainPlot = plot(time_micro,Pressure_MPa);
xlim([min(time_micro), max(time_micro)])
xlabel('Time (\mus)')
ylabel('Pressure (MPa)')

rho = 1e3;
c=1.5e3;
Velocity = Pressure / (rho*c);
Instant_Intensity = Pressure.*Velocity;
Instant_Intensity_Wcm2 = Instant_Intensity * (0.01)^2;
Intensity = Pressure.^2/(rho*c);
PII = trapz(time, Instant_Intensity)/range(time); %Pulse intensity integral based on Kinsler Eq. (5.9.1)
PII_cm = trapz(time, Instant_Intensity)/range(time)/1e4; %Pulse intensity integral based on Kinsler Eq. (5.9.1) per centimeter

% Match Doug's calculations
DH = diff(time).*(Instant_Intensity_Wcm2(1:(end-1)) + Instant_Intensity_Wcm2(2:end))/2; %Doug's column H
DI = cumsum(DH); %Doug's column I
DPII = sum(DH(1:9900/10e3*length(time)));% Doug's Pulse average intensity value
DK = DI/DPII; %Something normalized by pulse average intensity

lt10percent = sum(DK<0.1);
lt90percent = sum(DK<0.9);
        


date_rec = '02-May-2018';

tekfile = filename;

sample_duration_micro = range(time_micro);
% pulse_duration_micro =

Pmax_MPa = max(Pressure_MPa);
Pmin_MPa = min(Pressure_MPa);
Pabs_mid_MPa = (Pmax_MPa - Pmin_MPa)/2;

% FFT stuff
time_adjusted = time-time(1); % start time from 0;
TimeTotal=range(time_adjusted); % Total time
SamplingFrequency = 1/mean(diff(time_adjusted)); % sampling frequency
N = round(TimeTotal*SamplingFrequency); %number of data points
N = round(N/2)*2; %force it to be even
TimeTotal = N/SamplingFrequency; %new total time domain length, if N changed
TimeFFT = (0:(N-1))/SamplingFrequency; % time vector (max(t) is 1 bin short of T)
FrequencySpectrum = (0:(N/2))/N*SamplingFrequency; %frequency vector (min(f)=0, the DC component. max(f) = fs/2 exactly)
% Match pressure to output variables
if length(TimeFFT)==length(Pressure)
    y = Pressure;%function(t); %hypothetical time domain vector, length(y)=N
else
    y = interp1(time,Pressure, TimeFFT);%function(t); %hypothetical time domain vector, length(y)=N
end
PressureFFT= bfft(y);
[~,dominant_frequency_index]=max(abs(PressureFFT));
dominant_frequency = FrequencySpectrum(dominant_frequency_index);

pulse_duration = range(time);
pulse_duration_micro = pulse_duration*1e6;

% Is the signal undersampled?
undersampled_flag = true;
MI = 0;
if ~(max(FrequencySpectrum)==dominant_frequency)
    undersampled_flag = false;
%     MI = abs(min(pulse_pressure_MPa))/sqrt(pulse_frequency/1e6);
end

[time_derated, Pressure_derated] = derate_wave(time,Pressure,str2double(handles.edit7.String), str2double(handles.edit8.String));
Intensity_derated = Pressure_derated.^2/(rho*c);

% Update the pulse bounds & call analyze pulse
handles.edit3.String = time(end)*1e6;
handles.edit4.String = time(1)*1e6;


wavedata = struct('time',time,'time_micro',time*1e6,'voltage',ch1,'voltage_mean',voltage_mean,'voltage_relative',voltage_relative,'calibration_VoltMPa',calibration,...
    'Pressure',Pressure,'Pressure_MPa',Pressure_MPa,'PressurePeakPositive',max(Pressure),'PressurePeakNegative',min(Pressure),'PressureCenter',Pabs_mid_MPa,'PulsePressure_MPa',0,...
    'Intensity',Instant_Intensity,'Intensity_Wcm2',Instant_Intensity_Wcm2,'IntensityPeak_Wcm2',max(Instant_Intensity_Wcm2), 'IntensityPulseAverage_Wcm2',0,'IntensityIntegral_Wcm2',PII_cm,...
    'WaveDuration',range(time),'WaveDuration_micro',range(time_micro),'PulseDuration',pulse_duration,'PulseDuration_micro',pulse_duration_micro,...
    'PressureFFT',PressureFFT(:),'FrequencySpectrum',FrequencySpectrum(:),'UnderSampled',undersampled_flag,...
    'Pressure_derated',Pressure_derated,'time_derated',time_derated,'Intensity_derated',Intensity_derated,...
    'rho',rho,'c',c,'lt10percent',lt10percent,'lt90percent',lt90percent,...
    'MI',MI,'tekfile',filename...    
    );

handles.pushbutton1.UserData = wavedata;

pushbutton5_Callback(hObject, eventdata, handles)

function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wavedata = handles.pushbutton1.UserData;

pulse_interval = [str2double(handles.edit4.String), str2double(handles.edit3.String)]/1e6;
pulse_left_boundary_index = find(wavedata.time <= pulse_interval(1),1,'last');
if isempty(pulse_left_boundary_index); pulse_left_boundary_index = 1; end
pulse_right_boundary_index = find(wavedata.time >= pulse_interval(2),1,'first');
if isempty(pulse_right_boundary_index); pulse_right_boundary_index = length(wavedata.time); end

pulse_range_indeces = [pulse_left_boundary_index, pulse_right_boundary_index];
        
pulse_duration = range(wavedata.time(pulse_range_indeces));
pulse_duration_micro = pulse_duration*1e6;

pulse_pressure = wavedata.Pressure(pulse_range_indeces(1):pulse_range_indeces(2));
pulse_pressure_MPa = pulse_pressure/1e6;
pulse_intensity = wavedata.Intensity(pulse_range_indeces(1):pulse_range_indeces(2));
pulse_time = wavedata.time(pulse_range_indeces(1):pulse_range_indeces(2));
Half_Max_Intensity = 0.5*max(pulse_intensity);
pulse_half_times = intersections(pulse_time,(pulse_intensity-Half_Max_Intensity),[min(pulse_time),max(pulse_time)],[0,0]);
pulse_half_times_micro = pulse_half_times * 1e6;
pulse_half_intensities = interp1q(pulse_time,pulse_intensity,pulse_half_times);
pulse_half_intensities_cm = pulse_half_intensities/1e4;
FWHM = range(pulse_half_times);

pulse_average_intensity = trapz(pulse_time,pulse_intensity)/range(pulse_time);
pulse_average_intensity_cm = pulse_average_intensity / 1e4;

% % % FFT stuff to get frequency for the pulse alone
[pulse_frequency, FrequencySpectrum,PulsePressureFFT] = find_pulse_frequency(pulse_time,pulse_pressure);

% Set the reported pulse frequency to 0 if the signal is too underresolved to get the correct frequency
if ~(max(FrequencySpectrum)==pulse_frequency)
    MI = abs(min(pulse_pressure_MPa))/sqrt(pulse_frequency/1e6);    
    fpulse = pulse_frequency;
else
    wavedata.UnderSampled = true;
    MI = 0;
    fpulse = 0;
end
wavedata.MI = MI;

% Pulse Duration (based on manual choice of pulse bounds)
pulse_duration = range(pulse_time);
pulse_duration_micro = pulse_duration*1e6;


% Find the pulse duration and Isppa according to FDA 510(k) guidelines, using the selected pulse area as the signal
wavedata.pulse_bounds_510k = find_pulse_bounds(pulse_time,pulse_pressure);
pulse_time_510k = pulse_time(pulse_time >= wavedata.pulse_bounds_510k(1) & pulse_time <= wavedata.pulse_bounds_510k(2));
pulse_pressure_510k = pulse_pressure(pulse_time >= wavedata.pulse_bounds_510k(1) & pulse_time <= wavedata.pulse_bounds_510k(2));
pulse_intensity_510k = pulse_intensity(pulse_time >= wavedata.pulse_bounds_510k(1) & pulse_time <= wavedata.pulse_bounds_510k(2));
wavedata.pulse_duration_510k = range(wavedata.pulse_bounds_510k);
wavedata.Isppa_510k = trapz(pulse_time_510k,pulse_intensity_510k)/wavedata.pulse_duration_510k;

% estimate pulse frequency (we will try to get within two digits of that.
[pulse_frequency_estimate, ~, ~, ~] = find_pulse_frequency(pulse_time_510k,pulse_pressure_510k); % Not sure about the center frequency because I don't know what portion of the pulse you are supposed to use to define the spectrum
pulse_oom = 10^floor(log10(pulse_frequency_estimate));

% calculate using padded zeros if necessary
fc_old = pulse_frequency_estimate; wavedata.fc_510k = 0; npad = 1;
while round(fc_old/pulse_oom,2)~=round(wavedata.fc_510k/pulse_oom,2) && npad<1e7
    fc_old = wavedata.fc_510k;
    npad = npad*10;
    pulse_time_padded = [pulse_time; max(pulse_time)+[mean(diff(pulse_time)).*(1:npad)]']-pulse_time(1);
    pulse_pressure_padded = [zeros(npad/2,1); pulse_pressure; zeros(npad/2,1)];
    [wavedata.pulse_frequency_510k, wavedata.FrequencySpectrum_510k, wavedata.PulsePressureFFT_510k, wavedata.fc_510k] = find_pulse_frequency(pulse_time_padded,pulse_pressure_padded);    
end
if npad==1e7 && round(fc_old/pulse_oom,2)~=round(wavedata.fc_510k/pulse_oom,2)
    fprintf('FFT May be inaccurate. Too many zeros (i.e., >10^7) needed as padding to resolve.\n\n')
end

wavedata.Ipa_510k = trapz(pulse_time,pulse_intensity)/wavedata.pulse_duration_510k;

depth_cm = str2double(handles.edit7.String);
alpha_dBcmMHz = 0.3;
wavedata.MI_510k = abs(wavedata.PressurePeakNegative/1e6)*exp(-alpha_dBcmMHz*depth_cm*wavedata.fc_510k/1e6*(depth_cm*0.01))/sqrt(wavedata.fc_510k/1e6);

% Assign relevant data to table in gui
pulse_table_data = [pulse_duration_micro, round(max(pulse_pressure_MPa),2), round(min(pulse_pressure_MPa),2), round((max(pulse_pressure_MPa) - min(pulse_pressure_MPa))/2,2), round(pulse_average_intensity_cm,1),round(fpulse/1e6,2),round(MI,2), wavedata.pulse_duration_510k*1e6, round(wavedata.Isppa_510k/1e4,1), round(wavedata.pulse_frequency_510k/1e6,2), round(wavedata.Ipa_510k/1e4,1),round(wavedata.MI_510k,2)]';
handles.uitable2.Data = pulse_table_data;

wavedata.PulsePressure_MPa = pulse_pressure_MPa;
wavedata.IntensityPulseAverage_Wcm2 = pulse_average_intensity_cm;

handles.pushbutton1.UserData = wavedata;


% axes(handles.axes1);
% handles.axes1.UserData.MainPlot = plot(wavedata.FrequencySpectrum/1e6,abs(wavedata.PressureFFT));
% 
% handles.axes1.XLim = [min(wavedata.FrequencySpectrum), min([max(wavedata.FrequencySpectrum),100e6])]/1e6;
% if wavedata.UnderSampled
%     handles.axes1.UserData.mytext = text(0.05,0.95,'Warning: Undersampled Signal','Units','Normalized','Color','red','FontWeight','bold');
% end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[x,~]=ginput(1);
x = x(end);
xstr=sprintf('%.3f',x);
handles.edit4.String = xstr;
axes(handles.axes1); hold on;
if isfield(handles.axes1.UserData,'LeftBoundaryPlot'); delete(handles.axes1.UserData.LeftBoundaryPlot); end % remove old line
handles.axes1.UserData.LeftBoundaryPlot = plot(x*[1,1], handles.axes1.YLim,'r--'); hold off;

wavedata = handles.pushbutton1.UserData;
wavedata.PulseDuration = (str2double(handles.edit3.String) - str2double(handles.edit4.String))/1e6;
wavedata.PulseDuration_micro = wavedata.PulseDuration*1e6;
handles.pushbutton1.UserData = wavedata;


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB


% handles    structure with handles and user data (see GUIDATA)
[x,~]=ginput(1);
x = x(end);
xstr=sprintf('%.3f',x);
handles.edit3.String = xstr;
axes(handles.axes1); hold on;
if isfield(handles.axes1.UserData,'RightBoundaryPlot'); delete(handles.axes1.UserData.RightBoundaryPlot); end % remove old line
handles.axes1.UserData.RightBoundaryPlot = plot(x*[1,1], handles.axes1.YLim,'r--'); hold off

wavedata = handles.pushbutton1.UserData;
wavedata.PulseDuration = (str2double(handles.edit3.String) - str2double(handles.edit4.String))/1e6;
wavedata.PulseDuration_micro = wavedata.PulseDuration*1e6;
handles.pushbutton1.UserData = wavedata;


% --- Executes on button press in togglebutton1.
function togglebutton1_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton1


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, path] = uigetfile({'*.csv';'*.*'},'File Selector');
% edit1_Callback(hObject, eventdata, handles)
handles.edit1.String=sprintf('%s/%s',path,file);
    pushbutton1_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function uibuttongroup2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function radiobutton3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes during object creation, after setting all properties.
% function radiobutton2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes when selected object is changed in uibuttongroup2.
function uibuttongroup2_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup2 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wavedata = handles.pushbutton1.UserData;
switch (get(eventdata.NewValue,'Tag'))
    case 'radiobutton2'
%         handles.axes1.UserData.MainPlot = plot(wavedata.time_micro,wavedata.Pressure_MPa);
        handles.axes1.UserData.MainPlot.XData = wavedata.time_micro;
        handles.axes1.UserData.MainPlot.YData = wavedata.Pressure_MPa;
        handles.axes1.XLabel = xlabel('Time (\mus)');
        handles.axes1.YLabel = ylabel('Pressure (MPa)');
        handles.axes1.XLim = [min(wavedata.time_micro), max(wavedata.time_micro)];
        
        if handles.checkbox1.Value            
%             hold on
%             derated_plot = plot(wavedata.time_derated*1e6,wavedata.Pressure_derated/1e6,'r'); hold off
            handles.axes1.UserData.DeratedPlot.XData = wavedata.time_derated*1e6;
            handles.axes1.UserData.DeratedPlot.YData = wavedata.Pressure_derated/1e6;
%             handles.axes1.UserData.DeratedPlot = derated_plot;
        end
        
        
        
    case 'radiobutton3'
        if isfield(handles.axes1.UserData,'mytext'); delete(handles.axes1.UserData.mytext); end % Clear out unnecessary text
        axes(handles.axes1);
        handles.axes1.UserData.MainPlot.XData = wavedata.time_micro;
        handles.axes1.UserData.MainPlot.YData = wavedata.Intensity_Wcm2;
        handles.axes1.XLabel = xlabel('Time (\mus)');
        handles.axes1.YLabel =ylabel('Intensity (W / cm^2)');
        handles.axes1.XLim = [min(wavedata.time_micro), max(wavedata.time_micro)];
        
        if handles.checkbox1.Value            
%             hold on
%             derated_plot = plot(wavedata.time_derated*1e6,wavedata.Intensity_derated/1e4,'r'); hold off
            handles.axes1.UserData.DeratedPlot.XData = wavedata.time_derated*1e6;
            handles.axes1.UserData.DeratedPlot.YData = wavedata.Intensity_derated/1e4;
%             handles.axes1.UserData.DeratedPlot = derated_plot;
        end
        
        
    case 'radiobutton4'
        if isfield(handles.axes1.UserData,'mytext'); delete(handles.axes1.UserData.mytext); end % Clear out unnecessary text
        axes(handles.axes1);
        handles.axes1.UserData.MainPlot = plot(wavedata.FrequencySpectrum/1e6,abs(wavedata.PressureFFT));
%         handles.axes1.UserData.MainPlot.XData = wavedata.FrequencySpectrum/1e6;
%         handles.axes1.UserData.MainPlot.YData = wavedata.PressureFFT;
        handles.axes1.XLabel = xlabel('Frequency (MHz)');
        handles.axes1.YLabel = ylabel('FFT(Pressure) (Pa)');
        handles.axes1.XLim = [min(wavedata.FrequencySpectrum), min([max(wavedata.FrequencySpectrum),100e6])]/1e6;
        if wavedata.UnderSampled
           handles.axes1.UserData.mytext = text(0.05,0.95,'Warning: Undersampled Signal','Units','Normalized','Color','red','FontWeight','bold');
        end
        
end

handles.axes1.YLimMode = 'auto';

function clearstuff(handles)
    if isfield(handles.axes1.UserData,'mytext'); delete(handles.axes1.UserData.mytext); end % Clear out unnecessary text


% --- Executes during object creation, after setting all properties.
function uitable2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1
wavedata = handles.pushbutton1.UserData;

[wavedata.time_derated, wavedata.Pressure_derated] = derate_wave(wavedata.time,wavedata.Pressure,str2double(handles.edit7.String), str2double(handles.edit8.String));
wavedata.Intensity_derated = wavedata.Pressure_derated.^2/(wavedata.rho*wavedata.c);
handles.pushbutton1.UserData = wavedata;


if eventdata.Source.Value 
    switch handles.uibuttongroup2.SelectedObject.Tag
        case 'radiobutton2'
            axes(handles.axes1); hold on
%             derated_plot = plot(wavedata.time_derated, wavedata.Pressure_derated,'r'); hold off
            handles.axes1.UserData.DeratedPlot=plot(wavedata.time_derated*1e6, wavedata.Pressure_derated/1e6,'r'); hold off;

        case 'radiobutton3'
            axes(handles.axes1); hold on
            derated_plot = plot(wavedata.time_derated*1e6,wavedata.Intensity_derated/1e4,'r'); hold off
            handles.axes1.UserData.DeratedPlot = derated_plot;

        otherwise
    end
else
    if isfield(handles.axes1.UserData, 'DeratedPlot')
        delete(handles.axes1.UserData.DeratedPlot);
    end
end
handles.axes1.YLimMode = 'auto';

function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wavedata = handles.pushbutton1.UserData;

% Get the output file
outfname = handles.edit9.String;
[fpath1,fname1,fext1]=fileparts(handles.edit1.String); 

% Is this a valid filename containing .xls, do nothing
if ~isempty(regexp(outfname, '[/\*:?"<>|]', 'once')) && contains('outfname','.xls')

else
    if ~isempty(regexp(handles.edit1.String, '[/\*:?"<>|]', 'once'))
        outfname = sprintf('%s%s-output.xlsx',fpath1,fname1);
    
    % If it's left blank or wrong use the input file to figure it out
    else strcmp(outfname, 'Output Excel (.xlsx) file')        
        outfname = sprintf('wave_analyzer_output_%s.xlsx',datestr(now,'yyyyMMddHHmmss'));    
    end
    handles.text9.String = 'WARNING: Your selected output filename was invalid, so a newone has been chosen for you.';    
end
handles.edit9.String = outfname;

% Make a plot for the spreadsheet
g1=figure('visible','off');
spiffyp(g1);
h1 = subplot(1,3,1);
plot(wavedata.time_micro,wavedata.Pressure_MPa);hold on
xlim([min(wavedata.time_micro),max(wavedata.time_micro)])
xlabel('Time (\mus)')
ylabel('Pressure (MPa)')

h2 = subplot(1,3,2);
plot(wavedata.time_micro,wavedata.Intensity_Wcm2); hold on
xlim([min(wavedata.time_micro),max(wavedata.time_micro)])
xlabel('Time (\mus)')
ylabel('Intensity (W / cm^2)')

h3 = subplot(1,3,3);
plot(wavedata.FrequencySpectrum/1e6,abs(wavedata.PressureFFT)); hold on
[~,fmaxi ]=max(wavedata.PressureFFT);
fmax = wavedata.FrequencySpectrum(fmaxi);
if fmax>0
    xlim([0,fmax*10/1e6])
end
xlabel('Frequency (MHz)');
ylabel('FFT(Pressure) (Pa)');


% spiffyp(g1)%,'aspect_ratio',2)
g1fonts = findall(gcf,'type','text');
FontSize0 = get(g1fonts,'FontSize');
g1FontSize = mat2cell(cell2mat(FontSize0)+10,ones(size(FontSize0)));
[g1fonts.FontSize]=deal(g1FontSize{:});
[h1.FontSize,h2.FontSize,h3.FontSize] = deal(15);

screensizes = get(groot,'MonitorPositions');
g1.Position= screensizes(2,:).*[1,1,1,0.5];

%     g1.Position(3)=1080;
% 
% hiddenhandles = get(0,'showhiddenhandles'); % Make the GUI figure handle visible
% set(0,'showhiddenhandles','on') % Make the GUI figure handle visible
% % h = findobj(gcf,'type','axes') % Find the axes object in the GUI



g2 = figure('visible','off');
s = copyobj(handles.axes1,g2); % Copy axes object h into figure f1
s.Units ='normalized';
s.Position= [0.1300 0.1100 0.7750 0.8150];
spiffyp(g2)

if true
        delete(outfname)
        xlswrite(outfname,{'Time (s)', 'Voltage (V)', '<v>', 'volts-<v>','Calibration (V/MPa)','Pressure (MPa)','Intensity (W/cm^2)','Pulse Intensity Integral','<10%','<90%', 'Time (us)'},1,'A1')
        xlswrite(outfname,{wavedata.time',wavedata.voltage',wavedata.voltage_mean,wavedata.voltage_relative,wavedata.calibration_VoltMPa,wavedata.Pressure_MPa,wavedata.Intensity_Wcm2,wavedata.IntensityIntegral_Wcm2,wavedata.lt10percent,wavedata.lt90percent,wavedata.time_micro},1,'A2')
        xlswrite(outfname,[wavedata.time(:),wavedata.voltage(:)],1,'A2')
        xlswrite(outfname,wavedata.voltage_relative,1,'D2')
        xlswrite(outfname,[wavedata.Pressure_MPa, wavedata.Intensity_Wcm2],1,'F2')
        xlswrite(outfname,wavedata.time_micro,1,'K2')
%         xlswrite(outfname,{sprintf('Pulse Analysis : %s',pulse_notes)},1,'M7')
        xlswrite(outfname,{'TEKFILE:', 'Pulse Durtion (us)', 'P+ (MPa)', 'P- (MPa)','<p>','Ipa (W/cm2)','MI'},1,'M9')
        xlswrite(outfname,{fname1, wavedata.PulseDuration_micro, round(max(wavedata.PulsePressure_MPa),3), round(min(wavedata.PulsePressure_MPa),3), round((max(wavedata.PulsePressure_MPa) - min(wavedata.PulsePressure_MPa))/2,3), round(wavedata.IntensityPulseAverage_Wcm2,3),wavedata.MI},1,'M10')
        xlswritefig(g1,outfname,'Sheet1','M14')
        xlswritefig(g2,outfname,'Sheet1','M45')
%         xlswrite(outfname,{'PROJECT: ACOUSTIC FOUNTAIN'},1,'M1')
%         xlswrite(outfname,{'DATE RECORDED: 2018-05-07'},1,'M3')
%         if strcmp(us_machine,'SSI_ELASTO_cal'); xlswrite(outfname,{'Trandsucer: 6.7 MHz,   SSI,   SL15-4'},1,'M4')
%         elseif strcmp(us_machine,'ACUSONS3000_ELS'); xlswrite(outfname,{'Trandsucer:  9.0 MHz,   ACUSON,   9L4'},1,'M4')
%         end
end
    disp(fname1)



% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file, path] = uiputfile({'*.xlsx';'*.*'},'File Selector');
% edit1_Callback(hObject, eventdata, handles)
handles.edit9.String=sprintf('%s/%s',path,file);



function edit9_Callback(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit9 as text
%        str2double(get(hObject,'String')) returns contents of edit9 as a double



% --- Executes during object creation, after setting all properties.
function edit9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
