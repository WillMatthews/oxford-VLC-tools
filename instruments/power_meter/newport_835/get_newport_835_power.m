function [watts] = get_newport_835_power()
%GET_NEWPORT1830C Gets the reading from optical power meter over GPIB

%% Instrument Connection

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

%% Instrument Configuration and Control

% Communicating with instrument object, obj1.
query(obj1, 'D?'); % clear memory and trigger
data_s = query(obj1, 'D?');

data_c = char(data_s);
data_c_stripped = data_c(6:end);
data = str2double(data_c_stripped);

watts = data;

%% Disconnect and Clean Up

% Disconnect from instrument object, obj1.
fclose(obj1);

end

