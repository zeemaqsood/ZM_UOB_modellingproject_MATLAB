function Plot(varargin)

% Plot:
%
% This function will plot the models with any specified groups. If no
% groups specified, it will plot all variables. There are also extra
% options.
% 
% inputs: [1, 2]; [1, 2], [2, 4]; {{1, [1, 2]}, {2, [3, 4]}}
%          Variable inputs can be either number or the variables you would
%          like to plot
%
% options: 'T', will plot from 0 to specified time
%          'Proportion', will plot as a proportion of possible number of
%                        each variable could be produced
%          'Concentration', this is the default, where it will just plot
%                           the concentration
%          'Count', will plot the variables multiplied by how many of the
%                   specified variable are in the variable
%
% See also: Models, ODEs, ode15s, Time_to_SS, how_many_in, vars2nums
%
% Author: Sean Watson  Date: 06/08/2019  Version: v0.1

global IVs Model_names Plot_Vars Vars

% If the first input is not a cell, it must contain all the models we wish
% to plot, otherwise it must be a cell of models and variables
if ~iscell(varargin{1})
    Models(varargin{1}(1), 'N');
    
    % If there is a second variable which is numeric, it must be the
    % variables we wish to plot, otherwise plot all variables
    if length(varargin) >= 2 && (isnumeric(varargin{2}) || iscell(varargin{2}) || all(ismember(varargin{2}, Vars)))
        a = {};
        
        % Create a, a cell of every model with all variables 
        for i = 1:length(varargin{1})
            % If the second input is a cell, we have groups of variables we
            % would like to plot the sum of. If not, convert the array to a
            % cell
            if iscell(varargin{2})
                a = [a, {{varargin{1}(i), varargin{2}}}];
                
            else
                a = [a, {{varargin{1}(i), num2cell(varargin{2})}}];
            end
        end
        h = 3;
        
    else
        % Let a be an array of the models we will plot
        a = varargin{1};
        h = 2;
    end
    
else
    % Convert any non cell variable inputs to cell inputs
    a = varargin{1};
    for i = 1:length(a)
        if ~iscell(a{i}{2})
            a{i}{2} = num2cell(a{i}{2});
        end
    end
    h = 2;
end

T = 0;
Style = 0;
% Check for the options
while h <= length(varargin)
    % If there is an option "T", T to the next input
    if varargin{h} == "T"
        T = varargin{h + 1};
        h = h + 2;
        
    % If there is an option "Proportion", let Style be set to 1
    elseif varargin{h} == "Proportion"
        Style = 1;
        h = h + 1;
        
    % If there is an option "Count", let Style be set to 2, and let the
    % next input be the variable we will be counting
    elseif varargin{h} == "Count"
        Count = varargin{h + 1};
        Style = 2;
        h = h + 2;
 
    % If there is an option "Concentration", do nothing as Style is already
    % set to 0
    elseif varargin{h} == "Concentration"
        h = h + 1;
    end
end

% If no time is stated, find the time to plot by finding when all variables
% of all models are close to its steady state.
if T == 0
    if iscell(a)
        for i = 1:length(a)
            Models(a{i}{1}, 'N');
            
            T = max(T, Time_to_SS(a{i}{1}, cell2mat(vars2nums(a{i}{2}))));
        end
    else
        
        T = Time_to_SS(a);
    end
end

Legend = strings(100, 1);
h = 1;
hold on;

% For every model
for i = 1:length(a)
    
    % If we have stated variable inputs
    if iscell(a)
        % Run the model to get the correct parameters
        Models(a{i}{1}, 'N');
        
        groups = vars2nums(a{i}{2});
        
        % Create Groups which is the label for each group in groups
        Groups = string(length(groups));
        for j = 1:length(groups)
            Groups(j) = Plot_Vars(groups{j}(1));
            for k = 2:length(groups{j})
                Groups(j) = strcat(Groups(j), " + ", Plot_Vars(groups{j}(k)));
            end
        end
        
        Model_name = Model_names(a{i}{1});
    else
        % Run the model
        Models(a(i), 'N');
        
        groups = num2cell(1:length(Plot_Vars));
        
        % Create Groups which is the label for each group in groups
        Groups = string(Plot_Vars);
        
        Model_name = Model_names(a(i));
    end
    
    % Run the model using ode15s
    [t, y] = ode15s(@ODEs, [0, T], IVs);
    
    % For each group we want to plot
    for j = 1:length(groups)
        % If we are plotting Proportion
        if Style == 1
            % Find out how many of each variable can be created
            div = min(Write_Final_Eqn("Max_Num", groups{j}), [], 1);
            
            % Divide each variable by the amount that can be created.
            y(:, groups{j}) = y(:, groups{j})./div;
            
        elseif Style == 2
            % Find out how many of variable Count is in each variable
            mult = how_many_in(Count, groups{j});
            
            % Multiply each variable by how many of count is in it
            y(:, groups{j}) = mult .* y(:, groups{j});
        end
        
        % Plot the group
        plot(t, sum(y(:, groups{j}), 2))
        
        % Add the model and group to the legend
        Legend(h) = strcat("Model ", Model_name, ", var ", Groups(j));
        h = h + 1;
    end
end

% Add the legend to the plot
legend(Legend(1:h - 1));

hold off;
end