function [] = set_dc_81150A(v, iface)
%set_81150A_gipb sends a gpib command to the 81150a to set a DC bias

%% Instrument Connection

send_81150A(":APPL:DC DEF, DEF, " + string(v), iface);

end

