function Comparing_models(models, vars)

% Comparing_models:
%
% This function will plot the outcome of all the models in models, and for
% the variable vars. This function works best if the input models have the
% same models
%
% See also: ODEs, Modeln
%
% Author: Sean Watson  Date: 06/08/2019  Version: v0.1

global Plot_Vars Model_names IVs;

% Allow len_mods be the number of models and len_vars be the number of
% variables
len_mods = length(models);
len_vars = length(vars);

% Set the legend to have a string for each variable in each model
Legend = strings(1, len_mods * len_vars);

% For each model
for i = 1:len_mods
    % Run the Modeln code to get the right values globally
    Models(models(i), 'N');
    
    % Simulate the model
    [t, y] = ode15s(@ODEs, [0, 100], IVs);
    
    % Plot the model for all vars
    plot(t, y(:, vars));
    
    % Allow more lines to be plotted on the same plot
    hold on;
    
    % Set the legend equal to the Model number and the variables
    Legend((i - 1) * len_vars + 1:i * len_vars) = strcat("Model ", Model_names(models(i)), ", Var ", Plot_Vars(vars));  
end

% Create the title

% Set name1 equal to a sentance of all variable names. This will be
% assigned due to the last Model ran
name1 = Plot_Vars(vars(1));
if len_vars >= 2
    for j = 2:len_vars
        if j == len_vars
            name1 = strcat(name1, " and ",  Plot_Vars(vars(j)));
        else
            name1 = strcat(name1, ", ",  Plot_Vars(vars(j)));
        end
    end
end

% Set name2 to a sentance of all Model numbers
name2 = Model_names(models(1));
if len_mods >= 2
    for j = 2:len_mods
        if j == len_mods
            name2 = strcat(name2, " and ", Model_names(models(j)));
        else
            name2 = strcat(name2, ", ", Model_names(models(j)));
        end
    end
end

% Depending on the number of models involved, create the title
if len_mods == 1
    title(strcat("The difference between ", name1, " on model ", name2));
else
    title(strcat("The difference of ", name1, " between models ", name2));  
end

% Label the axis'
xlabel("Time");
ylabel("Concentration");

% Add the legend
legend(Legend);

% Allow no more changes to the plot
hold off;

end