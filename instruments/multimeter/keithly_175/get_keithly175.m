function [data] = get_keithly175()
%GET_KEITHLY175 Gets the reading from Keithly 175 over GPIB

%% Instrument Connection

% Find a GPIB object.
obj1 = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', 2, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = gpib('NI', 0, 2);
else
    fclose(obj1);
    obj1 = obj1(1);
end

% Connect to instrument object, obj1.
fopen(obj1);

%% Instrument Configuration and Control

% Communicating with instrument object, obj1.
data_s = string(fscanf(obj1));
data_c = char(data_s);
data = str2double(data_c(6:end));


%% Disconnect and Clean Up

% Disconnect from instrument object, obj1.
fclose(obj1);

end

