function [newbias,newvolt] = newport5005_setbias(current)
%NEWPORT5005_LASERSTATE Summary of this function goes here
%   Detailed explanation goes here
%% Instrument Connection

if current > 45E-3
    error("LASER CURRENT TOO HIGH")
end

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
oldbias = str2double(query(obj1, 'LAS:LDI?'));

pause(0.4);
fprintf(obj1, strcat("LAS:LDI ", num2str(current * 1E3)));

pause(0.2);
discard = str2double(query(obj1, 'LAS:LDI?'));
discard = str2double(query(obj1, 'LAS:LDV?'));
pause(0.2);
newbias = str2double(query(obj1, 'LAS:LDI?'));
newvolt = str2double(query(obj1, 'LAS:LDV?'));

fprintf("Laser Bias %3.2f mA --> %3.2f mA @ %3.2f V\n", oldbias, newbias, newvolt)

newbias = newbias * 1E-3;

pause(0.2);

X = query(obj1, "ERR?");
if contains(X, '501')
    error("Interlock Error");
end


%% Disconnect and Clean Up

% Disconnect from instrument object, obj1.
fclose(obj1);

end

