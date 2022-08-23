function [] = setup_newport_835()
%GET_NEWPORT1830C Gets the reading from optical power meter over GPIB

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
command = "A0C0D0R0X";
fprintf(obj1, command);
query(obj1, 'U1X');
wltest = query(obj1, 'U1X');
if ~ strcmpi(string(wltest(5:7)),"400")
    error(strcat("Wavelength Error - ",...
    "Newport needs the wavelength ",...
    "to be set correctly to 400nm, it is currently set to ",...
    wltest));
end
%% Disconnect and Clean Up

% Disconnect from instrument object, obj1.
fclose(obj1);

end

