close all

% ELAPSED TIME
elapsed_time_time = out.real_time{1}.Values.Time(:); % get simulation time for the real time values
elapsed_time = out.real_time{1}.Values.Data(:); % get elapsed_time

% SCALE VALUES
scale_time = out.scale_reading{1}.Values.Time(:); % get time for scale measurements
scale_values = out.scale_reading{1}.Values.Data(:); % get scale measurements

% FILTER SCALE VALUES
max_scale = 100; % adjust as needed
min_scale = 0; % adjust as needed

filtered_scale_values = scale_values(scale_values >= min_scale & scale_values <= max_scale); % filter out sensor errors
filtered_scale_time = scale_time(scale_values >= min_scale & scale_values <= max_scale); % do the same for the time
filtered_scale_elapsed_time = filtered_scale_time * elapsed_time(end)/elapsed_time_time(end); % convert from simulation time to real time

% INLET PUMP
pump_time = out.pump_setpoint{1}.Values.Time(:); % get time when pump values changed
pump_values = out.pump_setpoint{1}.Values.Data(:); % get pump set point data
pump_elapsed_time = pump_time * elapsed_time(end)/elapsed_time_time(end); % convert from simulation time to real time

% SMAPLING RATES
Ts = median(diff(elapsed_time));
time = min(elapsed_time) : Ts : max(elapsed_time);
output = interp1(filtered_scale_elapsed_time, filtered_scale_values, time);
input = interp1(pump_elapsed_time, pump_values, time, 'previous');

% VISUALIZATION
figure; % create a new figure
plot(time, output, 'b-'); % plot scale data in blue
xlabel('Time (s)'); % label for x-axis
ylabel('Beaker Fullness [%]'); % label for primary y-axis
ylim([0 105])

yyaxis right; % Activate the secondary y-axis on the right
plot(time, input, 'r--'); % plot pump values in red with dashed lines
ylabel('Inlet Pump Power Setpoint (%)'); % label for secondary y-axis
ylim([0 105])

% SAVE DATA
save_output = true;
if save_output
    dataToWrite = [time', input', output']; %#ok<*UNRCH> % concatenate arrays column-wise
    writematrix(dataToWrite, 'Lab_2_Data.csv'); % save data
end