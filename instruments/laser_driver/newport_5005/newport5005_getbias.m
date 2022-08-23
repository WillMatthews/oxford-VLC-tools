function [ibias,volt] = newport5005_getbias()
%NEWPORT5005_LASERSTATE Summary of this function goes here
%   Detailed explanation goes here
%% Instrument Connection

% Find a GPIB object.
obj1 = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', 6, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = gpib('NI', 0, 6);
else
    fclose(obj1);
    obj1 = obj1(1);
end

% Connect to instrument object, obj1.
fopen(obj1);
pause(0.2);
%% Instrument Configuration and Control


% Communicating with instrument object, obj1.
discard = query(obj1, 'LAS:LDI?');

ibias = str2double(query(obj1, 'LAS:LDI?'));
volt = str2double(query(obj1, 'LAS:LDV?'));

ibias = ibias * 1E-3;

pause(0.2);

X = query(obj1, "ERR?");
if contains(X, '501')
    error("Interlock Error");
end


%% Disconnect and Clean Up

% Disconnect from instrument object, obj1.
fclose(obj1);

end

