function [] = keithly224_set_bias(ibias,vbias)
%SET_BIASCURRENT Summary of this function goes here
%   Detailed explanation goes here
%% Instrument Connection
%% Instrument Connection

if ibias > 100E-3
    error("Bias Too high!");
end

% Find a GPIB object.
obj1 = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', 19, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = gpib('NI', 0, 19);
else
    fclose(obj1);
    obj1 = obj1(1);
end

% Connect to instrument object, obj1.
fopen(obj1);

%% Instrument Configuration and Control
itworked = 0;
errcount = 0;

while ~itworked
    % Communicating with instrument object, obj1.
    
    ibias_str = sprintf("%1.3E",ibias);
    vbias_str = sprintf("%1.3E",vbias);
    control = strcat('I+',ibias_str,'V+',vbias_str,'F1X');
    %disp(control);
    fprintf(obj1, control);
    pause(0.3);
    %NDCI+1.0000E-3
    state = query(obj1,'');
    %disp(state)
    ibias_set = str2num(state(5:14));
    
    sig = round(ibias,1,'significant');
    

    itworked = ((ibias_set * 1.1 > ibias) & (ibias_set * 0.9 < ibias)) | sig == ibias_set;

    if ~itworked
        pause(1);
        warning("Source Metre Error");
        fprintf(strcat("set: ",num2str(ibias_set), " given: ", num2str(ibias), "\n"));
        errcount = errcount + 1;
        if errcount > 5
            itworked = true;
        end
    end
end


%% Disconnect and Clean Up

% Disconnect from instrument object, obj1.
fclose(obj1);

end

