       %% closing Scope
        fclose(scope.visaObj);
        fopen(scope.visaObj); %?

        delete(scope.visaObj);
        clear scope;
    
%         %% Closing AWG
%         s = sprintf(':OUTP%i OFF \n', 1);
%         fprintf(ins, '%s \n',s);
%         s = sprintf(':OUTP%i OFF \n', 2);
%         fprintf(ins, '%s \n',s);
% 
%         fclose(ins);
%         fopen(ins); %?
% 
%         delete(ins); 
%         clear ins;

