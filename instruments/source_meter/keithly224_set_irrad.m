function [] = set_biascurrent(ibias,vbias)
%SET_BIASCURRENT Summary of this function goes here
%   Detailed explanation goes here
%% Instrument Connection

% Connect to instrument object, obj1.
fopen(obj1);

%% Instrument Configuration and Control

% Communicating with instrument object, obj1.
ibias_str = fprintf("%1.3E",ibias);
vbias_str = fprintf("%1.3E",vbias);
control = strcat('I+',ibias_str,'V+',vbias_str,'F1X');
fprintf(obj1, control);

%% Disconnect and Clean Up

% Disconnect from instrument object, obj1.
fclose(obj1);

end

