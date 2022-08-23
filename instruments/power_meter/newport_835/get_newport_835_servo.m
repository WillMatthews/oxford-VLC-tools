function [watts_per_m2] = get_newport_835_servo()
%GET_NEWPORT1830C Gets the reading from optical power meter over GPIB

engage_boomarm;
pause(1)
engage_boomarm;
pause(1);

watts_per_m2 = get_newport_835();

park_boomarm;
pause(1);
park_boomarm;



end

