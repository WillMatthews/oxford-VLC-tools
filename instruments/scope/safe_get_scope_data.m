function [dataOut] = safe_get_scope_data(scopename)
%SAFE_GET_SCOPE_DATA does a safe capture from the oscilloscope (retrying if
%the data capture messes up
% returns 'dataOut' which is a structure containing all values returned by oscope


sets = get_scope_set();
if strcmpi(scopename, "33")
    [scope, sets] = get_33ghz_scope(sets);
    pause(3);
elseif strcmpi(scopename, "2.5")
    [scope, sets] = get_2_5ghz_scope(sets);
    pause(3);
else
    error("Invalid scopename")
end


hold = true;
while(hold)
    dataOut = get_scope_data(scope, sets);
    if dataOut.count < 1000
        fprintf("Oscilloscope Fault. Retrying...\n");
        clear dataOut
    else
        fprintf("\n");
        hold = false;
    end
end

fclose(scope.visaObj);
end

