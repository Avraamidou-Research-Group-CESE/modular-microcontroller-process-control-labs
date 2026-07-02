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

% FIRST ORDER MODEL WITH TIME DELAY
iodelay = NaN;
sys = tfest(tt2, 1,0, iodelay);
model_output = lsim(sys, input_interp, new_time - min(new_time));

% VISUALIZATION
figure;
hold on; 
yyaxis left; 
plot(new_time, output_interp, 'b-', 'DisplayName', 'Data'); % plot actual output
plot(new_time, model_output, 'r--', 'DisplayName', 'Model'); % plot model output
ylabel('Chenge in Output'); % label for the output

yyaxis right; 
plot(new_time, input_interp, 'k:', 'DisplayName', 'Input'); % plot input signal
ylabel('Input'); % label for the input
ylim([0 105]);

xlabel('Time (s)'); 
legend('show'); 
hold off; 