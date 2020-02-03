function [obj1] = get_81150A(iface)
%GET_81150A_GPIB returns an instrument object of the 81150A AWG
% over GPIB or USB (iface)

%% Instrument Connection
if strcmpi(iface, "gpib")
    % Find a GPIB object.
    obj1 = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', 10, 'Tag', '');
    
    % Create the GPIB object if it does not exist
    % otherwise use the object that was found.
    if isempty(obj1)
        obj1 = gpib('NI', 0, 10);
    else
        fclose(obj1);
        obj1 = obj1(1);
    end
    
    
elseif strcmpi(iface, "usb")
    %% remote variables
    visa_vendor = 'TEK';
    visa_address = 'USB::0x0957::0x4108::MY47C01509::INSTR';
    
    obj1 = visa(visa_vendor, visa_address); %, 'OutputBuffer', buffer); 
    
    
else
    error("Specify valid IFACE for get_81150A(iface)");
    
    
end

% Connect to instrument object, obj1.
fopen(obj1);

%% Instrument Configuration and Control

% Communicating with instrument object, obj1.
%data1 = query(obj1, command);

%fclose(obj1);


%% notes




%fprintf(awg, cmd);
%fclose(awg);

% %% basic io
% r = query(dcawg, '*idn?');
% fprintf(1, '%s', r);
% fwrite(dcawg, '*cls');
% fprintf(1, 'event status register cleared\n');
% %fwrite(awg, '*rst')
%  
% %% status check
% r = query(dcawg, '*esr?', '%s', '%d');
% fprintf(1, 'event status register: %d\n', r);
% % read all messages until No error
% fprintf(1, 'messages:\n');
% while 1
%     r = query(dcawg, 'syst:err?');
%     fprintf(1, 'DCAWG: * %s', r);
%     if strcmp(r, ['0,"No error"' 10])
%         break
%     end
% end


end

