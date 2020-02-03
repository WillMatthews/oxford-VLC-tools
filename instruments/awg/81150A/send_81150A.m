function [] = send_81150A(cmd, iface)
%send_81150A_usb sends a command "cmd" to the 81150A

awg = get_81150A_usb(iface);

fprintf(awg, cmd);

fclose(awg);

end

