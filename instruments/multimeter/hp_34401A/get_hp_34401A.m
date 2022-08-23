function [data_out] = get_hp_34401A()
%GET_HP_34401A Summary of this function goes here
%   Detailed explanation goes here


%% Instrument Connection

% Find a GPIB object.
obj1 = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', 22, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = gpib('NI', 0, 22);
else
    fclose(obj1);
    obj1 = obj1(1);
end

% Connect to instrument object, obj1.
fopen(obj1);

%% Instrument Configuration and Control

% Communicating with instrument object, obj1.


numrdg = 4;
fprintf(obj1, 'FUNC "CURR:DC"');
is = zeros(1,numrdg);
for i = 1:numrdg
    response = query(obj1, 'READ?');
    is(i) = str2double(response);
end
data_out = mean(is);


%% Disconnect and Clean Up

% Disconnect from instrument object, obj1.
fclose(obj1);


end

