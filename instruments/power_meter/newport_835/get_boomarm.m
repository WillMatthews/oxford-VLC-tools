function [obj2] = get_boomarm()
%% SERVO CONNECTION
% Find a serial port object.
obj2 = instrfind('Type', 'serial', 'Port', 'COM5', 'Tag', '');

% Create the serial port object if it does not exist
% otherwise use the object that was found.
if isempty(obj2)
    obj2 = serial('COM5');
else
    fclose(obj2);
    obj2 = obj2(1);
end

end

