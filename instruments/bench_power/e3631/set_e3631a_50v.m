function [] = set_e3631a_50v(v, imax);
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
halfv = v/2;
p25_str = num2str(halfv);
n25_str = num2str(-halfv);
imax_str = num2str(imax);
fprintf(obj1, strcat('APPL P25V,' ,p25_str , ',', imax_str));
fprintf(obj1, strcat('APPL N25V,' ,n25_str , ',', imax_str));

%% Disconnect and Clean Up

% Disconnect from instrument object, obj1.
fclose(obj1);
end
