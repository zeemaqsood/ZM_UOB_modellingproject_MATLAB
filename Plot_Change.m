function endpoints = Plot_Change(Type, models, var, Points, groups, varargin)

% Plot_Change:
%
% This function will change the var specified within the models specified
% and plot the groups specified. There are extra options available
% 
% inputs: Type: one of : "IV", "K", "KD"
%         models: [1, 2]
%         var: 1
%         Points: [1,2,3]; [1,10,100]; 10:10:100
%         groups: [1,2,3]; {[1,2], [3,4]}
%         Variable inputs can be either number or the variables you would
%         like to plot
%
% options: 'T', will plot from 0 to specified time
%          'Proportion', will plot as a proportion of possible number of
%                        each variable could be produced
%          'Concentration', this is the default, where it will just plot
%                           the concentration
%          'Count', will plot the variables multiplied by how many of the
%                   specified variable are in the variable
%
% See also: ODEs, Models, ode15s, Time_to_SS, how_many_in, vars2nums
%
% Author: Sean Watson  Date: 06/08/2019  Version: v0.1

global IVs K Plot_Vars Model_names;

h = 1;
Style = 0;
KDConst = 0;
T = 0;

var = vars2nums(var);
groups = vars2nums(groups);

% Check the options
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
        
    % If there is an option KDConst, set var KDConst to 1
    elseif varargin{h} == "KDConst"
        KDConst = 1;
        h = h + 1;
    end
end

% If the time is not specified, find the time to show all plots
if T == 0
    if KDConst == 0
        T = Time_to_SS(models, "Change", Type, var, Points);
    else
        T = Time_to_SS(models, "Change", Type, var, Points, "KDConst");
    end
end

var = vars2nums(var);
groups = vars2nums(groups);

% Check for if the Type is K or KD, and assign whether it is for the
% forward or backwards reaction
if ismember(Type, ["K", "KD"])
    if var > 0
        b1 = 1;
    else
        var = - var;
        b1 = -1;
    end
end

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
Legend = strings(n * m * length(models), 1);

% Allow endpoints to be of the size, the number of plot variables by the
% number of steps
endpoints = zeros(n, m + 1, length(models));

figure();

hold on;

for k = 1:length(models)
    Models(models(k), 'N');
    
    KD = K(:, 2)./K(:, 1);
    
    for i = 1:n
        % Find the value for the next step
        v = Points(i);
        
        % Set the initial value to the value of this step
        if Type == "IV"
            IVs(var) = v;
            
        elseif Type == "K"
            K(var, 0.5 * (3 - b1)) = v;
            
            % If KDConst equals one, change the other reaction to allow KD
            % to stay the same
            if KDConst == 1
                if b1 == 1
                    K(var, 2) = KD(var) * K(var, 1);
                else
                    K(var, 1) = K(var, 2)/KD(var);
                end
            end
            
        elseif Type == "KD"
            KD(var) = Points(i);
            
            if b1 > 0
                K(var, 1) = K(var, 2)/KD(var);
                
            else
                K(var, 2) = KD(var) * K(var, 1);
            end
        end
        
        % Simulate the model using ode15s
        [t, y] = ode15s(@ODEs, [0, T], IVs);
        
        % Set the first column of endpoints to be the changing variable
        endpoints(i, 1, k) = v;
        
        % If a style was specified, change the values to satisfy this
        for j = 1:length(groups)
           if Style == 1
                div = min(Write_Final_Eqn("Max_Num", groups{j}), [], 1);

                for k1 = 1:length(groups{j})
                    y(:, groups{j}(k1)) = y(:, groups{j}(k1))/div(k1);
                end 
           elseif Style == 2
                mult = how_many_in(Count, groups{j});

                y(:, groups{j}) = mult .* y(:, groups{j});
           end
            
            plot(t, sum(y(:, groups{j}), 2));
            
            % Set the endpoints of the lines to the sum of the array endpoints
            endpoints(i, j + 1, k) = sum(y(end, groups{j}));
        end
        
        % Set the legend name to the group number plus the changing variable
        % name and its value
        if Type == "IV"
            Legend((k - 1) * m * n + (i - 1) * m + 1:(k - 1) * m * n + i * m) = strcat(Model_names(models(k)), ", ", Groups, ", ", Plot_Vars(var), "^{IV} = ", num2str(v));
        elseif Type == "KD"
            Legend((k - 1) * m * n + (i - 1) * m + 1:(k - 1) * m * n + i * m) = strcat(Model_names(models(k)), ", ",Groups, ", k_d = ", num2str(v));
        else
            Legend((k - 1) * m * n + (i - 1) * m + 1:(k - 1) * m * n + i * m) = strcat(Model_names(models(k)), ", ",Groups, ", k_{", num2str(b1 * var), "} = ", num2str(v));
        end
    end
end

% Add the legend and label the axis
legend(Legend);
xlabel("Time");
ylabel("Concentration");
title(Model_names(models));

% Allow no more lines to be added to the plot
hold off;

% Reset the initial value
end