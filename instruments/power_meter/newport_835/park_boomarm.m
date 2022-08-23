function [] = park_boomarm()
%PARK_BOOMARM Summary of this function goes here


obj2 = get_boomarm();
% Connect to instrument object, obj2.
fopen(obj2);



%% Disconnect and Clean Up
fprintf(obj2, 'GOTO:70');

pause(0.1)
fprintf(obj2, 'DETATCH');
% Disconnect from instrument object, obj1.
pause(0.3);
fclose(obj2);
end

