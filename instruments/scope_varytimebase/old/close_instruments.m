function [] = close_instruments(instruments)
%CLOSE_INSTRUMENTS Closes a list of instruments


%% iterate through instruments and close em all
for ins = instruments

    if strcmpi(ins.custName, "scope")
        %% closing Scope
        fclose(ins.visaObj);
        fopen(ins.visaObj); %?

        delete(ins.visaObj);
        clear ins;
    
    elseif strcmpi(ins.custName, "awg")
        %% Closing AWG
        s = sprintf(':OUTP%i OFF \n', 1);
        fprintf(ins, '%s \n',s);
        s = sprintf(':OUTP%i OFF \n', 2);
        fprintf(ins, '%s \n',s);

        fclose(ins);
        fopen(ins); %?

        delete(ins); 
        clear ins;
        
        
    else
        warning("No valid custName to close");
    end
end
end

