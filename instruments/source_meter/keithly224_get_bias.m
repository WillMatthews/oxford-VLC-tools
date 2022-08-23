function [ibias_set,vbias_set] = keithly224_get_bias()
%SET_BIASCURRENT Summary of this function goes here
%   Detailed explanation goes here
%% Instrument Connection
%% Instrument Connection

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
    state = query(obj1,'');
    ibias_set = str2num(state(5:14));
    vbias_set = str2num(state(12+(5:14)));

%% Disconnect and Clean Up

% Disconnect from instrument object, obj1.
fclose(obj1);

end

