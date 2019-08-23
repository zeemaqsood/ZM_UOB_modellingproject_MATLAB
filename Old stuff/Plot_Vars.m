function [t, y] = Plot_Vars(model, vars, T)

global Vars IVs;

eval(strcat("Model", num2str(model), "('N')"));

if ~exist('T', 'var')
    T = 100;
end

% Run model to find output over time
[t, y] = ode15s(@ODEs1, [0, T], IVs);

% Plot model
plot(t, y(:, vars));
legend(Vars(vars));

end