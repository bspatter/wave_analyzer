function [time,voltage] = read_input_data(filename)
% read input voltage


fid=fopen(sprintf('%s',filename),'r');
if fid<1; fprintf('%s could not be found',filename); return; end

%initialize variables used in readin the file

header_flag = true;
header = '';

% read the file
tline = fgetl(fid);
while ischar(tline)    
    tline = fgetl(fid);
   
    %Check for end of header header
    if strcmp(tline,'TIME,CH1'); header_flag = false; end
    
    % read the data appropriately based on header or not
    if header_flag
        header = sprintf('%s\n%s',header,tline);
    else
        time_voltage_data=textscan(fid,'%f,%f');
        time = time_voltage_data{1};
        voltage = time_voltage_data{2};
        break
    end
end
fclose(fid);

% time
time(isinf(voltage))=[]; %remove unreal values

% remove double time entries (only effects signals with sampling resolutions that exceed what is recorded for the bit depth, so it should be okay)
[time,ia,~] = unique(time);
voltage = voltage(ia);

