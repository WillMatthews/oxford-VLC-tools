function [watts_per_m2] = get_newport_1830c()
%GET_NEWPORT1830C Gets the reading from optical power meter over GPIB

%% Instrument Connection

% Find a GPIB object.
obj1 = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', 4, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = gpib('NI', 0, 4);
else
    fclose(obj1);
    obj1 = obj1(1);
end

% Connect to instrument object, obj1.
fopen(obj1);

%% Instrument Configuration and Control

% Communicating with instrument object, obj1.
data_s = query(obj1, 'D?');

data_c = char(data_s);
data = str2double(data_c);

watts_per_cm2 = data/(0.25*pi * 1.13^2);
watts_per_m2 = 1E4 * watts_per_cm2;


%% Disconnect and Clean Up

% Disconnect from instrument object, obj1.
fclose(obj1);

end

