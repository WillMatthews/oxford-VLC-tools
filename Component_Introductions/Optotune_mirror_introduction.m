%{
Author: Ravinder Singh and Andy Schreier
E-Mail: {ravinder.singh},{andy.schreier}@eng.ox.ac.uk
Copyright: optical wireless communication group
Status: alpha-testing
Version: 0.1
Versionupdate: 19/02/2020

The given script represents a mini introduction in the initalisation and
steering of the Optotune dual-axis mirror. The code is divided into 3 
sections: (i) Connect and initalise to the mirror, (ii) steering to
specific angles and (iii) close the session.

This script is written for a USB connection to the mirror driver operating
at the logical port 'COM3'. Please, check your logical port prior to any
operation of this script and adopt the given code in the section 'Connect 
and inititalise the Optotune mirror',accordingly.

According to the manual, each command send to the mirror controller 
requires an unspecified pause in order to process the command. In this 
script a pause duration of 2 ms is used and successfully tested. Shorter 
pause durations are subject to further investigations. 

The maximum steering angles are +30 deg and -30deg for AngleA and AngleB,
respectively. A controlling instance checking the maximum steering angles 
is not included in this script. Further mirror control commands can be 
found in the mirror driver operation manual (4.2 List of commands available
in "simple mode").
%}

%% *% Connect and inititalise the Optotune mirror
% Find a serial port objects
% Check and adopt the COM port prior to the first run!
otmTx = instrfind('Type', 'serial', 'Port', 'COM3', 'Tag', '');

% Create the serial port object if it does not exist
% otherwise use the object that was found.
if isempty(otmTx)
    otmTx = serial('COM3');

else
    fclose(otmTx);
    otmTx = otmTx(1);
end

%open connection
fopen(otmTx);

% Configure instrument object, obj1.
set(otmTx, 'Terminator', {'CR/LF','CR/LF'}); %define end of line byte
set(otmTx, 'BaudRate', 115200); %define the baudrate
%For the sake of completeness: No parity bit, 1 stop bit, ASCII encoded
%strings as commands

%Reset the current position to AngleA=0deg and AngleB=0deg
fprintf(otmTx, 'reset');pause(2e-3);

%% *% Mirror steering to given angles
% test Steer:

%centre position
fprintf(otmTx, 'angleA = -0.35deg');pause(2e-3);
fprintf(otmTx, 'angleB = -0.088deg');pause(2e-3);



%% *% close connection
fclose(otmTx);