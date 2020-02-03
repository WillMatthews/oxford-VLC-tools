function [awg, buffer] = get_70002AE()
%GET_70002AE returns a 30020AEAWG object


%% remote variables
visa_vendor = 'TEK';
visa_address = 'USB::0x0699::0x0503::B010200::INSTR'; % Repair
% visa_address = 'USB::0x0699::0x0503::B030555::INSTR'; % loan one
buffer = 200 * 2^10; % 20 KiB
linefeed = 10;

%% connect to instrument
if exist('awg', 'var')
    fclose(awg);
    delete(awg);
    clear awg;
end

awg = visa(visa_vendor, visa_address, 'OutputBuffer', buffer);

fopen(awg);

%% basic io

r = query(awg, '*idn?');
fprintf(1, '%s', r);
fwrite(awg, '*cls');
%fwrite(awg, '*rst')

%% status check
r = query(awg, '*esr?', '%s', '%d');
fprintf(1, 'event status register: %d\n', r);
% read all messages until No error
fprintf(1, 'messages:\n');
while 1
    r = query(awg, 'syst:err?');
    fprintf(1, '70002AE:  %s', r);
    if strcmp(r, ['0,"No error"' linefeed])
        break
    end
end



end

