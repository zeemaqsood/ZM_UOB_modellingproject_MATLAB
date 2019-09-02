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

sizes = ["y", "z", "a", "f", "p", "n", "u", "m", "", "K", "M", "G", "T", "P", "E", "Z", "Y"];

global IVs Model_names Plot_Vars Vars units T_units

m = 0;

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
                m = m + length(varargin{2});
                
            else
                a = [a, {{varargin{1}(i), num2cell(varargin{2})}}];
                m = m + length(varargin{2});
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
            m = m + length(a{i}{2});
        else
            m = m + length(a{i}{2});
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
        
        if ismember(varargin{h + 1}, sizes)
            T_unit = varargin{h + 2};
            h = h + 3;
            
        else
            T_unit = "";
            h = h + 2;
        end
        
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
    b = inf;
    
    for i = 1:length(a)
        Models(a{i}{1}, 'N');

        [new_T, T_unit] = Time_to_SS(a{i}{1}, cell2mat(vars2nums(a{i}{2})));
        T = max(T, new_T);
        
        [~, new_b] = ismember(T_unit, sizes);
        b = min(b, new_b);
    end
    
    T_unit = sizes(b);
end

Legend = strings(100, 1);
h = 1;

plots = zeros(100, m + 1, length(a));
uns = strings(length(a), 1);

figure();

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
    
    [~, b] = ismember([T_units, T_unit], sizes);
    
    % Run the model using ode15s
    [t, y] = ode15s(@ODEs, [0, T * 10 ^ (3 * (b(2) - b(1)))], IVs);
    plots(1:length(t), 1, i) = t * 10 ^ (3 * (b(1) - b(2)));
    
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
        plots(1:length(t), j + 1, i) = sum(y(:, groups{j}), 2);
        
        % Add the model and group to the legend
        Legend(h) = strcat("Model ", Model_name, ", var ", Groups(j));
        h = h + 1;
    end
    
    plots(length(t) + 1:end, :, i) = NaN;
    plots(:, length(groups) + 2:end, i) = NaN;
    
    uns(i) = units;
end

if Style == 0
    [~, b] = ismember(uns, sizes);

    v = max(max(plots(:, 2:end, :)));
    
    m = min(v(:) .* 10 .^ (3 * (b - 9)));

    Log = floor(log10(m)/3);
    
    for i = 1:length(b)
        plots(:, 2:end, i) = plots(:, 2:end, i) .* 10 ^ (3 * ((b(i) - 9) - Log));
    end

    unit = sizes(9 + Log);
end

for i = 1:length(a)
    plot(plots(:, 1, i), plots(:, 2:end, i));
end

% Add the legend to the plot
legend(Legend(1:h - 1));

% Add the legend and label the axis

xlabel(strcat("Time, ", T_unit, "s"));
ylabel(strcat("Concentration, ", unit, "M"));

hold off;
end
