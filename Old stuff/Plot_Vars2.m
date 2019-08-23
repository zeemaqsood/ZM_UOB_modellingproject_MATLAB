function [t, y] = Plot_Vars(model, vars, T)

% Plot_Vars:
%
% This function will plot the Model model, for variable Vars, over a time T
%
% See also: ODEs, Modeln
%
% Author: Sean Watson  Date: 06/08/2019  Version: v0.1

global Plot_Vars IVs Model_names;

% Run Modeln to have the correct values
Models(model, 'N');

% If T does not exist as an input value, set T to be 100
if ~exist('T', 'var')
    T = 100;
end

% Simulate the model using ode15s
[t, y] = ode15s(@ODEs, [0, T], IVs);

% Plot model
plot(t, y(:, vars));
legend(Plot_Vars(vars));
title(Model_names(model));
xlabel("Time");
ylabel("Concetration of variables");

end