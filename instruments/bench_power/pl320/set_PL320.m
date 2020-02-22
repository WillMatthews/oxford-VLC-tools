function [] = set_PL320(v, i)
%SET_PL320 Sets a requested voltage and current (CVS or CCS) to a PL320
%power supply over GPIB

%% Instrument Connection

% Find a GPIB object.
obj1 = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', 3, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = gpib('NI', 0, 3);
else
    fclose(obj1);
    obj1 = obj1(1);
end

% Connect to instrument object, obj1.
fopen(obj1);

%% Instrument Configuration and Control

% Communicating with instrument object, obj1.
vm = sprintf("%d", round(v * 1000)); % convert to miliamps & milivolts
im = sprintf("%d", round(i * 1000));
fprintf(obj1, strcat('X', vm ,'mV'));
fprintf(obj1, strcat('X', im ,'mA'));

%% Disconnect and Clean Up

% Disconnect from instrument object, obj1.
fclose(obj1);

end

