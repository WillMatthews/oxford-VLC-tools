function [dataOut] = pairB_get(timebase_range)
%SAFE_GET_SCOPE_DATA does a safe capture from the oscilloscope (retrying if
%the data capture messes up

% Provide the Resource name of the oscilloscope - Note you will have to
% change this to match your oscilloscope.
myScope = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x0699::0x0528::B011571::0::INSTR', 'Tag', '');

% Create the VISA-USB object if it does not exist
% otherwise use the object that was found.
if isempty(myScope)
    myScope = visa('NI', 'USB0::0x0699::0x0528::B011571::0::INSTR');
else
    fclose(myScope);
   myScope = myScope(1);
end

%timebase_range = 100e-6;

% Create a VISA object and set the |InputBufferSize| to allow for transfer
% of waveform from oscilloscope to MATLAB. Tek VISA needs to be installed.
%myScope = visa('tek', visaAddress);
myScope.InputBufferSize = 2e6;

% Set the |ByteOrder| to match the requirement of the instrument
myFgen.ByteOrder = 'littleEndian';

% Open the connection to the oscilloscope
fopen(myScope);

% Reset the oscilloscope to a known state
%fprintf(myScope, '*RST');
fprintf(myScope, '*CLS');

pause(0.1);
%Setting channel
s=sprintf(':DATa:SOUrce CH4');
fprintf(myScope, '%s \n',s);
pause(0.1);
%fprintf(myScope, ':FPAnel:PRESS AUTO');
pause(3);
busy = true;
while busy == true
    s = query(myScope, "BUSY?");
    busy = logical(str2num(s));
    pause(1);
    %disp(busy);
end

% Turn headers off, this makes parsing easier
fprintf(myScope, 'HEADER OFF');
pause(0.1);
% Autoset the oscilloscope 
% fprintf(myScope, 'AUTOS EXECute');
% 
% pause(2)

%setting X-axis scale
%timebase_range=1e-6;
timebase=timebase_range/10; %value per division
s=sprintf('HORizontal:MODE:SCAle %e',timebase);
fprintf(myScope, '%s \n',s);
pause(2)
% Get record length value

recordLength = query(myScope, 'HOR:RECO?');

% Ensure that the start and stop values for CURVE query match the full
% record length
fprintf(myScope, ['DATA:START 1;DATA:STOP ' recordLength]);

% Read YOFFSET to calculate the vertical values
yOffset = query(myScope, 'WFMO:YOFF?');

% Read YMULT to calculate the vertical values
verticalScale  = query(myScope,'WFMOUTPRE:YMULT?');

% Request 8 bit binary data on the CURVE query
fprintf(myScope, 'DATA:ENCDG RIBINARY;WIDTH 1');

% Request the CURVE
fprintf(myScope, 'CURVE?');

% Read the captured data as 8-bit integer data type
data = (str2double(verticalScale) * (binblockread(myScope,'int8')))' + str2double(yOffset);

%% Calculating X values
pause(1)
xinc = query(myScope, 'WFMOutpre:XINcr?','%s \n','%e'); 
xref = query(myScope, 'WFMOutpre:XZEro?','%s \n','%e');
length_data=length(data);
x = (0:(length_data)-xref) * xinc ;
 if length(x)~=length(data) %forcing to adjust length of x because of diff xref values, 
    x = (0:(length_data-1)-xref) * xinc ;
 end
 
 
 fprintf("Capture completed with %d points\n", length_data);
% Clean up Close the connection
fclose(myScope);
% Clear the variable
clear myScope;


dataOut.x = x;
dataOut.y = data;
dataOut.xref = xref;
dataOut.xincr = xinc;
dataOut.ptcnt = length_data;

dataOut.count = length_data;

dataOut.exptime = clock;



end

