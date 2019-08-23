function Prop_of_poss(inputs, T)

% Comparing_models:
%
% This function will plot the outcome of all the models in models, and for
% the variable vars. This function works best if the input models have the
% same models
%
% Author: Sean Watson  Date: 06/08/2019  Version: v0.1
%
% See also: ODEs, Modeln

global Plot_Vars IVs Model_names;

% Allow len_mods be the number of models and len_vars be the number of
% variables
len = length(inputs);
% Set the legend to have a string for each variable in each model
Legend = strings(1, 100);

if ~exist('T', 'var')
    T = 100;
end

h = 0;
% For each model
for i = 1:len
    % Run the Modeln code to get the right values globally
    Models(inputs{i}{1}, 'N');
    
    % Simulate the model
    [t, y] = ode15s(@ODEs, [0, T], IVs);
    
    div = max_num_of(inputs{i}{2});
    
    for j = 1:length(inputs{i}{2})
        y(:, inputs{i}{2}(j)) = y(:, inputs{i}{2}(j))/div(j);
    end   
    % Plot the model for all vars
    plot(t, y(:, inputs{i}{2}));
    
    % Set the legend equal to the Model number and the variables
    Legend(h + 1:h + length(inputs{i}{2})) = strcat("Model ", Model_names(inputs{i}{1}), ", Var ", Plot_Vars(inputs{i}{2}));
    
    h = h + length(inputs{i}{2});
    
    % Allow more lines to be plotted on the same plot
    hold on;
end

Legend = Legend(1:h);

% Label the axis'
xlabel("Time");
ylabel("Proportion of possible number of such element being created");

% Add the legend
legend(Legend);

% Allow no more changes to the plot
hold off;

end