function [scopeOut, set] = get_33ghz_scope(set)
%GET_SCOPE Initialises and connects to an oscilloscope


set.scope.name="null";
set.scope.addr="00::00::00::00::0::00";

%% Locate the Scope
% Find a VISA-USB object. (already exists - reconnect)
try
%%% 2.5 GHz Scope Visa address
    %scope = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x2A8D::0x900E::MY52460101::0::INSTR', 'Tag', '');
    %set.scope.name="2.5GHzVisa";
    %set.scope.addr="USB0::0x2A8D::0x900E::MY52460101::0::INSTR";
   
end
try
%%% 33 GHz Scope Visa address
    scope = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x2A8D::0x9032::MY55170109::0::INSTR', 'Tag', '');
    set.scope.name="33GHzVisa";
    set.scope.addr="USB0::0x2A8D::0x9032::MY55170109::0::INSTR";
end

% Create the VISA-USB object if it does not exist
% otherwise use the object that was found.
if isempty(scope)
    try
        %%% 2.5 GHz Scope Visa address
        %scope = visa('AGILENT', 'USB0::0x2A8D::0x900E::MY52460101::0::INSTR');
        %set.scope.name="2.5GHzVisaN";
        %set.scope.addr="USB0::0x2A8D::0x900E::MY52460101::0::INSTR";

    end
    
    try
        %%% 33 GHz Scope Visa address
        scope = visa('TEK', 'USB0::0x2A8D::0x9032::MY55170109::0::INSTR');
        set.scope.name="33GHzVisaN";
        set.scope.addr="USB0::0x2A8D::0x9032::MY55170109::0::INSTR";

    end
    
else
    %disp(scope)
    fclose(scope);
    scope = scope(1);
end


if isempty(scope)
    error("No 'scope' instrument connected");
end



% Connect to instrument object, obj1.
% fopen(scope);
% 
% scope=visa('agilent','USB0::0x2A8D::0x900E::MY52460101::0::INSTR');
% 
% 
% if isempty(scope)
%     scope = tcpip(IPAddress, scopePort);
% else
%     fclose(scope);
%     scope = scope(1);
% end


%% Scope Specific Initialisation


% % Set the buffer size. Change this buffer size to slightly over the number
% % of bytes you get back in each read
% set(scope,'EOSMode','read&write')
% set(scope,'EOSCharCode','LF')
% % set the buffer size
% set(scope,'InputBufferSize',4096*2^10*16); %set by instr data



if strcmpi(set.scope.name,"2.5GHzVisa")
%     % 2.5 GHz scope size
%     scope.InputBufferSize = 1024*2^10*16;
%     scope.OutputBufferSize = 1024*2^10*16;

elseif strcmpi(set.scope.name,"33GHzVisa")
    % 33 GHz scope size
    scope.InputBufferSize = 4096*2^12*16;
    scope.OutputBufferSize = 4096*2^10*16;
end
    
% Set the timeout value
scope.Timeout = 10;

% Set the Byte order
scope.ByteOrder = 'littleEndian';

% Open the connection
fopen(scope);

%% Generic Initialise

IDN = query(scope, '*IDN?'); %% This is to return values

fprintf("Connected to %s \n", IDN);


if set.reset_scope % typ. false
    % Reset the instrument and autoscale and stop
    fprintf(scope,'*RST; :AUTOSCALE'); pause(0.05);
    fprintf(scope,':STOP'); pause(0.05);
end


% %% SCOPE OPERATION MODE

if strcmpi(set.mode, "continuous") %typ. continuous
    fprintf(scope,'%s \n',':AUT'); pause(0.05); %%autoscale with continuous triggering

else
    
    fprintf(scope,'*TRG'); %%single with trigger
    
    s=[':TRIGGER:EDGE:SOURCE ' num2str(set.trigger_chan)];
    fprintf(scope, '%s \n',s);pause(0.05);
    s=sprintf(':TRIGGER:EDGE:LEV %e',set.trigger_lev);
    fprintf(scope, '%s \n',s);pause(0.05);
    fprintf(scope,'%s \n',':TRIGGER:EDGE:SOURCE CHAN1');pause(0.05); %% triggering with any channel
    fprintf(scope,'%s \n',':TRIG:SWEEP NORMAL');pause(0.05);
    fprintf(scope,'%s \n',':TRIGGER:EDGE:LEV 0.02');pause(0.05); %% triggering level [V]
    fprintf(scope,'%s \n',':ACQ:MODE ETIME');pause(0.05); %% RTIME = real time ETIME = equivalent time
    fprintf(scope,'%s \n',':ACQ:TYPE NORMAL');pause(0.05);
    fprintf(scope,'%s \n',':ACQUIRE:COMPLETE 100');pause(0.05);
    
    fprintf(scope,'%s \n',':ACQuire:POINts:ANALog 20e6');pause(0.05);
    
    fprintf(scope,'%s \n',':AUToscale:VERTical CHAN2');pause(0.05); % Zubair
    fprintf(scope,'%s \n',':AUToscale:VERTical CHAN1');pause(0.05); % Zubair
    
    fprintf(scope,'%s \n',':AUToscale:OVERlay ON');pause(0.05);
    
    fprintf(scope,'%s \n',':CHANnel1:RANGe 1.2');pause(0.05);

end

s=sprintf(':TIM:RANG %e', set.timebase_range);
fprintf(scope, '%s \n', s);pause(0.05);



% fprintf(scope,':TIM:DEL 0'); % time delay (sec).
% fprintf(scope,':TIM:REF LEFT'); %set reference (0sec)to the Left



scopeOut.custName = "scope";
scopeOut.visaObj = scope;

%fread(scope); % ensure output buffer is empty before start

end

