function [dataOut] = get_scope_data(scopeIn, sets)
%GET_DATA Summary of this function goes here

scope = scopeIn.visaObj;

hold = true;
while(hold)
    try
        % getting the data
        fprintf(scope,'%s \n',':SINGle'); % single shot
        pause(0.55);

        %digitize the data
        s = [':DIG CHAN' num2str(sets.scope_chan)];
        fprintf(scope,'%s \n',s); pause(0.15);
    catch
        continue
    end
    hold = false;
end
    


%% data aquisition
pause(0.2);
%try
    s = [':WAV:SOURCE CHAN' num2str(sets.scope_chan)];
    fprintf(scope,'%s \n',s); pause(0.15);
    fprintf(scope,'%s \n',':WAV:POIN MAX'); pause(0.15);
    fprintf(scope,'%s \n',':WAV:FORM BYTE'); pause(0.15);
    fprintf(scope,'%s \n',s); pause(0.15);
    
    % flush whatever crap is currently stored
    %fread(scope);
    pause(2);
    %fprintf(scope,'%s \n', ':CLS?'); pause(0.15);
    
    fprintf(scope,'%s \n', ':WAV:DATA?'); % return request
    %     pause(15); %<-- DEFAULT WAS 10
    %pause(2);
    [raw, count, msg] = binblockread(scope, 'uint8');
    %[raw, count, msg] = fread(scope, 'uint8');
    pause(3);
%catch
%     raw = 0;
%     count = 0;
%     msg = "Fatal Error";
%end

%% x-y rescaling
% fprintf(scope,'%s \n',':WAVEFORM:YINCREMENT?');
fscanf(scope,'%e');
try
    yref    = query(scope, ':WAVEFORM:YREFERENCE?','%s \n','%e');pause(0.05);
    yorigin = query(scope, ':WAVEFORM:YORIGIN?'   ,'%s \n','%e');pause(0.05);
    yincr   = query(scope, ':WAVEFORM:YINCREMENT?','%s \n','%e');pause(0.05);
    xref    = query(scope, ':WAVEFORM:XREFERENCE?','%s \n','%e');pause(0.05);
    xorigin = query(scope, ':WAVEFORM:XORIGIN?'   ,'%s \n','%e');pause(0.05);
    xincr   = query(scope, ':WAVEFORM:XINCREMENT?','%s \n','%e');pause(0.05);
    ptcnt   = query(scope, ':WAVEFORM:POINTS?'    ,'%s \n','%e');pause(0.05);
catch
    count=0;
    yref=0;yorigin=0;yincr=0;
    xref=0;xorigin=0;xincr=0;
    ptcnt=0;
end


y1 = ((raw-yref)*yincr) + yorigin;
scale_factor = max(y1)-min(y1);
center_val = max(y1)-scale_factor/2;
index_to_fold_down = find(y1>center_val)';
y1(index_to_fold_down) = y1(index_to_fold_down)-scale_factor;
y = y1;
x = (0:(ptcnt-1)-xref) * xincr ; %+ xorigin;


%fprintf("MESSAGE: %s \n\n", msg);

dataOut.x = x;
dataOut.y = y;
dataOut.yref = yref;
dataOut.yorigin = yorigin;
dataOut.yincr = yincr;
dataOut.xref = xref;
dataOut.xorigin = xorigin;
dataOut.xincr = xincr;
dataOut.ptcnt = ptcnt;

dataOut.count = count;
dataOut.msg = msg;

dataOut.exptime = clock;

end