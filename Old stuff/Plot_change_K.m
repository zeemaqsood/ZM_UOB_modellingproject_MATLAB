function endpoints = Plot_change_K(model, Var, Plot, Points, T)

% change_K:
%
% This function will plot the a variation of the same model with different
% k values
%
% See also: ODEs, Modeln
%
% Author: Sean Watson  Date: 06/08/2019  Version: v0.1

global IVs K Plot_Vars Model_names;

% Check whether we are changing the forward or backwards reaction
if Var > 0
    r = 1;
    Varr = Var;
else
    r = 2;
    Varr = - Var;
end

% Run the model to make sure you have the correct values
Models(model, 'N');

% If T does not exist as an input value, set T to be 100
if ~exist('T', 'var')
    T = 100;
end

% Allow dummy to be the initial k value we will change, so we can return it
% to the correct state at the end
dummy = K(Varr, r);

% Let m denote the number of variables we will plot, and let n denote the
% number of values we will change the k value to
m = length(Plot);
n = length(Points);

% Set the legend have a space for all plot variables for all steps
Legend = strings(n * m, 1);

% Allow endpoints to be of the size, the number of plot variables by the
% number of steps
endpoints = zeros(n, m + 1);

for i = 1:n
    % Find the value for the next step
    k = Points(i);
    
    % Set the k value to the value of this step    
    K(Varr, r) = k;

    % Simulate the model using ode15s
    [t, y] = ode15s(@ODEs, [0, T], IVs);
    
    % Plot the outcome for all plot variable
    plot(t, y(:, Plot));
    
    % Allow for more lines to be placed on the same graph
    hold on;
    
    % Set the endpoints of the lines to the array endpoints
    endpoints(i, :) = [k, y(end, Plot)];
    
    % Set the legend name to the variable name plus the changing variable
    % name and its value    
    Legend((i - 1) * m + 1:i * m) = strcat(Plot_Vars(Plot), ", k_{", num2str(Var), "}=", num2str(k));
end

% Add the legend and label the axis
legend(Legend);
xlabel("Time");
ylabel("Concentration");
title(Model_names(model));

% Allow no more lines to be added to the plot
hold off;

% Reset the initial k value
K(Varr, r) = dummy;
end