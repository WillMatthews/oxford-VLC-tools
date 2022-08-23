%% Instrument Connection

tone = true;
% Find a GPIB object.
obj1 = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', 21, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = gpib('NI', 0, 21);
else
    fclose(obj1);
    obj1 = obj1(1);
end

% Connect to instrument object, obj1.
fopen(obj1);

dt = 0.5;
t = linspace(0,dt,fix(dt*24000));

%% Instrument Configuration and Control

% Communicating with instrument object, obj1.
i=0;
while true
    tic
    i = i+1;
    data_s = query(obj1, 'D?');

    data_c = char(data_s);
    data_c_stripped = data_c(6:end);
    data = str2double(data_c_stripped);

    watts_per_cm2 = data/(0.25*pi * 1.13^2);
    watts_per_m2 = 1E4 * watts_per_cm2;
    
    %watts_per_m2 = data; %only uncomment for crap to do with testing the
    %autorange code.
    log_wpm = log10(watts_per_m2);
    if log_wpm < -6
        power_per_m2_print = watts_per_m2*1E9;
        prefix = 'n';
    elseif log_wpm < -3
        power_per_m2_print = watts_per_m2*1E6;
        prefix = 'u';
    elseif log_wpm < 0
        power_per_m2_print = watts_per_m2*1E3;
        prefix = 'm';
    else
        power_per_m2_print = watts_per_m2*1E0;
        prefix = '';
    end
    
    fprintf("%d:  %3.4f %cW/m2     ",i,power_per_m2_print,prefix);
    fprintf(data_s);
    
    if tone
        if i == 1;
            ref = data;
        end
        %clear sound;
        irrad_adjust = 0.2*log10(data/ref);
        y = sin(2*pi*t*0.7E3*(1+irrad_adjust)).*blackman(numel(t))';
        sound(y,24E3);
        pause(dt-0.1);
        tp = toc;
    end
end

%% Disconnect and Clean Up

% Disconnect from instrument object, obj1.
fclose(obj1);


