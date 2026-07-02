close all

% PI VLAUES
P = input('P = ');
I = input('I = ');

% ELAPSED TIME
elapsed_time_time = out.real_time{1}.Values.Time(:); % get simulation time for the real time values
elapsed_time = out.real_time{1}.Values.Data(:); % get elapsed_time

% FULLNESS VALUES
fullness_time = out.fullness{1}.Values.Time(:); % get time for fullness measurements
fullness_values = out.fullness{1}.Values.Data(:); % get fullness measurements

% SETPOINT VALUES
setpoint_time = out.setpoint{1}.Values.Time(:); % get time for setpoints
setpoint_values = out.setpoint{1}.Values.Data(:); % get setpoint values
setpoint_elapsed_time = setpoint_time * elapsed_time(end)/elapsed_time_time(end); % convert from simulation time to real time

% FILTER SCALE VALUES
max_fullness = 100; % adjust as needed
min_fullness = 0; % adjust as needed

filtered_scale_values = fullness_values(fullness_values >= min_fullness & fullness_values <= max_fullness); % filter out sensor errors
filtered_scale_time = fullness_time(fullness_values >= min_fullness & fullness_values <= max_fullness); % do the same for the time
filtered_scale_elapsed_time = filtered_scale_time * elapsed_time(end)/elapsed_time_time(end); % convert from simulation time to real time

% INLET PUMP
pump_time = out.manipulated{1}.Values.Time(:); % get time for pump
pump_values = out.manipulated{1}.Values.Data(:); % get pump set point data
pump_elapsed_time = pump_time * elapsed_time(end)/elapsed_time_time(end); % convert from simulation time to real time

% SMAPLING RATES
Ts = median(diff(elapsed_time));
time = min(elapsed_time) : Ts : max(elapsed_time);
setpoint = interp1(setpoint_elapsed_time, setpoint_values, time,'previous','extrap');
controlled = interp1(filtered_scale_elapsed_time, filtered_scale_values, time,'linear','extrap');
manipulated = interp1(pump_elapsed_time, pump_values, time,'linear','extrap');

% VISUALIZATION
figure; % create a new figure
hold on
plot(time, controlled, 'r-'); % plot controlled variable in blue
plot(time, setpoint, 'k--') % plot setpoint in black
xlabel('Time (s)'); % label for x-axis
ylabel('Fullness (%)'); % label for primary y-axis
ylim([0 105])
ax = gca; % get the current axes
ax.YColor = 'k'; % set the color of the y-axis to black

yyaxis right; % Activate the secondary y-axis on the right
plot(time, manipulated, 'b-'); % plot manipulated values in blue 
ylabel('Inlet Pump Power (%)'); % label for secondary y-axis
ylim([0 105])
ax = gca; % get the current axes
ax.YColor = 'b'; % set the color of the y-axis to blue

legend('Fullness','Setpoint','Pump Power')
hold off

% CUTOFF STARTUP
cutoff = input('Look at the plot and input time to startup: ');
cut_time = time(time >= cutoff);
cut_setpoint = setpoint(time >= cutoff);
cut_controlled = controlled(time >= cutoff);
cut_manipulated = manipulated(time >= cutoff);

% ERROR
cut_error = setpoint - controlled;
RMSE = sqrt(mean(cut_error.^2));

% VISUALIZATION
close all
figure; % create a new figure
hold on
plot(cut_time, cut_controlled, 'r-'); % plot controlled variable in blue
stairs(cut_time, cut_setpoint, 'k--') % plot setpoint in black
xlabel('Time (s)'); % label for x-axis
ylabel('Controlled'); % label for primary y-axis
ylim([0 105])
ax = gca; % get the current axes
ax.YColor = 'k'; % set the color of the y-axis to black

yyaxis right; % Activate the secondary y-axis on the right
plot(cut_time, cut_manipulated, 'b-'); % plot manipulated values in blue 
ylabel('Manipulated'); % label for secondary y-axis
ylim([0 105])
ax = gca; % get the current axes
ax.YColor = 'b'; % set the color of the y-axis to blue

title(sprintf('RMSE = %.2f, P = %.2f, I = %.2f', RMSE,P,I));
legend('Controlled','Setpoint','Manipulated')
hold off
saveas(gcf,sprintf('Lab_3_Plot_P_%0.2f_I_%0.2f.png',P,I))

% SAVE DATA
save_output = true;
if save_output
    dataToWrite = [cut_time', cut_setpoint', cut_controlled', cut_manipulated']; %#ok<*UNRCH> % concatenate arrays column-wise
    writematrix(dataToWrite, sprintf('Lab_3_Data_P_%0.2f_I_%0.2f.csv',P,I)); % save data
end