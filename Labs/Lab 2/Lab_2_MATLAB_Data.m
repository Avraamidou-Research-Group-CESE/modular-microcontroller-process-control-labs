close all

% DATA
arduino_data = readtable('Lab_2_Data.csv'); % load in data

time = table2array(arduino_data(:, 1));
input = table2array(arduino_data(:, 2));
output = table2array(arduino_data(:, 3));

output = output - output(1); % normalize the output

% SAMPLING RATE
Ts = median(diff(time)); % get sampling time
new_time = min(time) : Ts : max(time); % make new time
output_interp = interp1(time, output, new_time); % interpolate for the new time    
input_interp = interp1(time, input, new_time,'previous'); 

% TRASNFER TO SYSTEM IDENTIFICATION TOOLBOX
new_duration = seconds(new_time);
tt2 = timetable(new_duration(:), input_interp(:), output_interp(:), 'VariableNames', {'input', 'output'});