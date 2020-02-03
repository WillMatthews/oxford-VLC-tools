function [] = set_keithly195(varargin)
%GET_KEITHLY195 Sets up a Keithly 195


%% Instrument Connection

% Find a GPIB object.
obj1 = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', 16, 'Tag', '');

% Create the GPIB object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = gpib('NI', 0, 16);
else
    fclose(obj1);
    obj1 = obj1(1);
end

% Connect to instrument object, obj1.
fopen(obj1);

%% command generation / sending
%https://doc.xdevs.com/doc/Keithley/196/196_903_01A.pdf
%https://neurophysics.ucsd.edu/Manuals/Keithley/195a%20multimeter%20instructions.pdf


%X = Execute other device-dependant commands

% Operation Mode
%F0 = DC Volt 
%F1 = AC Volts
%F2 = Ohms
%F3 = DC current
%F4 = AC current
%F5 = ACV dB
%F6 = ACA dB
%F7 = Offset compensated ohms

defcmd = "";
autorange = true;
command = defcmd;
if strcmpi(varargin{1}, "DCV")
    command = strcat(command, "F0X");
elseif strcmpi(varargin{1}, "ACV")
    command = strcat(command, "F1X");
elseif strcmpi(varargin{1}, "DCA")
    command = strcat(command, "F3X");
elseif strcmpi(varargin{1}, "ACA")
    command = strcat(command, "F4X");
elseif strcmpi(varargin{1}, "OHM")
    command = strcat(command, "F2X");
elseif strcmpi(varargin{1}, "DISP")
    % Display
    %Da = Display up to 10 char message (a = message)
    %D = cancel display mode
    command = strcat(command, "D", varargin{2}, " X");
    autorange = false;
elseif strcmpi(varargin{1}, "DISPOFF")
    command = strcat(command, "DX");
    autorange = false;
end

fprintf(obj1, command); % Communicating with instrument object, obj1.

% Ranging
%R0 = Autorange
%R1 Min (3V.. 300uA.. 300ohm)
%...
%R7 MAX (300V.. 3A... 300Mohm)

% Resolution
%S0 = 3.5 digit resolution
%...
%S3 = 6.5 / 5.5 digit resolution

%S9 (only for 195)

if autorange % autorange and go for max. digits of resolution
    command = strcat(defcmd, "R0X");
    fprintf(obj1, command); pause(0.05);
    command = strcat(defcmd, "S9X");
    fprintf(obj1, command);
end
command = defcmd;


% Data store interval
%Q0 = one shot into buffer
%Qn = n=interval in miliseconds (1msec to 999999msec)

% Reading mode
%B0 = readings from A/D
%B1 = readings from data store

% Status
%U0 = send machine status word
%U1 = send error conditions
%U2 = send translator word
%U3 = send buffer size
%U4 = send average reading in buffer
%U5 = send lowest reading in buffer
%U6 = send highest reading in buffer
%U7 = ? (send current value)
%U8 = send input switch status (front/rear)

% Press button!
%Hn = Hit front panel button number n


%% Disconnect and Clean Up

% Disconnect from instrument object, obj1.
fclose(obj1);

end

