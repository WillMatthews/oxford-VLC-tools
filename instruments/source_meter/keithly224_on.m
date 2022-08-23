function [] = keithly224_on()
%SET_BIASCURRENT Summary of this function goes here
%   Detailed explanation goes here
%% Instrument Connection
%% Instrument Connection
for i = 1:15
% Find a GPIB object.
obj1 = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', 19, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = gpib('NI', 0, 19);
else
    fclose(obj1);
    obj1 = obj1(1);
end

% Connect to instrument object, obj1.
fopen(obj1);

%% Instrument Configuration and Control

% Communicating with instrument object, obj1.
control = "F1X";
fprintf(obj1, control);

%% Disconnect and Clean Up

% Disconnect from instrument object, obj1.
fclose(obj1);
end
end

