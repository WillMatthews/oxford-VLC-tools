function [sets] = get_scope_set()
%GET_SET returns settings

sets.scopename = "33";
%sets.scopename = "2.5";

sets.mode = "continuous";
%set.mode = "trigger";

sets.scope_chan = 1; % to acquire..
sets.timebase_range = 500e-6;


sets.trigger_chan = "CHAN1";
sets.trigger_lev = 0.54;

sets.reset_scope = true; % Reset the instrument and autoscale and stop

end

