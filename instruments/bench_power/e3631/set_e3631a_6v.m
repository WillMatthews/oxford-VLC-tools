function [] = set_e3631a_6v(v, imax);
%% Instrument Connection

% Find a GPIB object.
obj1 = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', 17, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = gpib('NI', 0, 17);
else
    fclose(obj1);
    obj1 = obj1(1);
end

% Connect to instrument object, obj1.
fopen(obj1);

%% Instrument Configuration and Control

% Communicating with instrument object, obj1.
p6_str = num2str(v);
imax_str = num2str(imax);
fprintf(obj1, strcat('APPL 6V,' , p6_str , ',', imax_str));

%% Disconnect and Clean Up

% Disconnect from instrument object, obj1.
fclose(obj1);
end
