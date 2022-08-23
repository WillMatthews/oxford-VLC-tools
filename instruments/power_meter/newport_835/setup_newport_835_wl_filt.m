function [] = setup_newport_835_wl_filt(wl, filt)
% wl is double
% filt is bool



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

if filt
    filt = 1;
else
    filt = 0;
end

cmd = strcat('A', num2str(filt) ,'W',num2str(round(wl)),'X');

fprintf(obj1, cmd);
data1 = query(obj1, 'U1X');
disp(data1);

%% Disconnect and Clean Up

% Disconnect from instrument object, obj1.
fclose(obj1);




end

