function endpoints = Plot_Change_IV(model, var, groups, Points, T)

% plot_sums_IV:
%
% This function will plot the sums of the groups over time with 
% the a variation of the same model with different initial values
%
% See also: ODEs, Modeln
%
% Author: Sean Watson  Date: 06/08/2019  Version: v0.1

global IVs Plot_Vars Model_names;

% Run the model to make sure you have the correct values
Models(model, 'N');

% If T does not exist as an input value, set T to be 100
if ~exist('T', 'var')
    T = 100;
end

Var = eqn_vars_2_nums(var);

% Allow dummy to be the initial value we will change, so we can return it
% to the correct state at the end
dummy = IVs(Var);

if ~iscell(groups)
    groups = num2cell(groups);
end

% Let m denote the number of groups we will plot, and let n denote the
% number of values we will change the initial value to
m = length(groups);
n = length(Points);

% Let Groups be the names of the variables in each group
Groups = strings(m, 1);
for i = 1:m
    Groups(i) = Plot_Vars(groups{i}(1));
    for j = 2:length(groups{i})
        Groups(i) = strcat(Groups(i), " + ", Plot_Vars(groups{i}(j)));
    end
end

% Set the legend have a space for all plot variables for all steps
Legend = strings(n * m, 1);

% Allow endpoints to be of the size, the number of plot variables by the
% number of steps
endpoints = zeros(n, m + 1);

for i = 1:n
    % Find the value for the next step
    k = Points(i);
    
    % Set the initial value to the value of this step
    IVs(Var) = k;
    
    % Simulate the model using ode15s
    [t, y] = ode15s(@ODEs, [0, T], IVs);
    
    % Set the first collumn of endpoints to be the changing variable
    endpoints(i, 1) = k;   
    
    % Plot the outcome for all plot groups
    for j = 1:length(groups)
        plot(t, sum(y(:, groups{j}), 2));
        
        % Set the endpoints of the lines to the sum of the array endpoints
        endpoints(i, j + 1) = sum(y(end, groups{j}));
        
        % Allow more lines to be plotted on the same plot
        hold on;
    end
    
    % Set the legend name to the group number plus the changing variable
    % name and its value
    Legend((i - 1) * m + 1:i * m) = strcat(Groups, ", ", Plot_Vars(Var), " = ", num2str(k));
end

% Add the legend and label the axis
legend(Legend);
xlabel("Time");
ylabel("Concentration");
title(Model_names(model));

% Allow no more lines to be added to the plot
hold off;

% Reset the initial value
IVs(Var) = dummy;

end