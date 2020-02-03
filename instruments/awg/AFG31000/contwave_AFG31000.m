function [] = halt_AFG31000()

%% MATLAB script to generate custom waveform from Tektronix AFG31000 - Ravinder Singh 19 Dec 2019

% % Clear MATLAB workspace of any previous instrument connections
% instrreset;
%% Instrument Connection
% Find a VISA-USB object.
awg = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x0699::0x035D::C010637::0::INSTR', 'Tag', ''); % CHECK THIS ADDRESS BEFORE YOU BEGIN!!
% Create the VISA-USB object if it does not exist, otherwise use the object that was found.
if isempty(awg)
    awg = visa('KEYSIGHT', 'USB0::0x0699::0x035D::C010637::0::INSTR'); % CHECK THIS ADDRESS BEFORE YOU BEGIN!!
else
    fclose(awg);
    awg = awg(1);
end
% Change the |OutputBufferSize| depending on the size of the custom waveform being transfered.
buffer = 200*2^12;
awg.OutputBufferSize = buffer; 
% Set the |ByteOrder| to match the requirement of the instrument
awg.ByteOrder = 'littleEndian';
% Open the connection to the function generator
fopen(awg);
% Reset the function generator to a know state
fprintf(awg, '*RST');
fprintf(awg, '*CLS;'); 



% Turn on Channel 1 output
fprintf(awg, ':OUTP1 OFF');

% Clean up - close the connection and clear the object
fclose(awg);
clear awg;

end