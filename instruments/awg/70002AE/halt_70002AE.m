function [] = halt_70002AE(awg)
%70002AE gracefully halts the 70002AE awg

%% turn off output -> stop modulation -> remove loaded waveform
fwrite(awg, sprintf('OUTPut1:STATe 0\n'));
fwrite(awg, sprintf('AWGC:STOP:IMMediate\n'));
fwrite(awg, sprintf('MMEMORY:DELETE "test.wfm"'));

end

