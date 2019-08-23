function [groups, start_vars] = Groups(Var)

% Groups:
% 
% This function group all available variables into groups of which the base
% elements are limited.
% 
% See also:
%
% Author: Sean Watson  Date: 06/08/2019  Version: v0.1

global eqns Vars constants;

% n is the number of Variables, m is the number of equations
n = size(Vars, 1);
m = size(eqns, 2);

% Let start_vars be a vector numbers corresponding to all variables
start_vars = 1:n;

% If a variables is constant, remove it as the supply of that variable is
% 'unlimited'
start_vars = start_vars(~ismember(start_vars, constants));

% Produce an array of all start variables, i.e. only variables used to
% create products
for j = 1:m
    b = eqns{j};
    if size(b{1}, 2) >= 2
        start_vars = start_vars(~ismember(start_vars, b{2}));
    end
    
    if size(b{2}, 2) >= 2
        start_vars = start_vars(~ismember(start_vars, b{1}));
    end
    
    if size(b{1}, 2) == 1 && size(b{2}, 2) == 1 && all(ismember([b{1}, b{2}], start_vars))
        start_vars = start_vars(~ismember(start_vars, b{2}));
    end
end

% The base elements will each have a group
if exist('Var', 'var')
    groups = num2cell([Var, start_vars]);
else
    groups = num2cell(start_vars);
end
% Let unused be all equations
j = 1;

% Let dum be an array of every reaction
dum = [1:m; -1:-1:-m];
dum = dum(:);

% Let unused be a cell where each element is the start of every reaction
unused = cell(2 * m, 1);
for k = 1:m
    % Only add reaction where there are more elements at the start than at
    % the end, i.e. where elements bind together. Remove any reactions
    % where this is not the case
    if size(eqns{k}{1}, 2) >= size(eqns{k}{1}, 2)
        unused{m + k + 1} = eqns{k}{1}(~ismember(eqns{k}{1}, constants));
    else
        dum = dum(dum~= k);
    end
    
    % Repeat for the reverse reaction
    if size(eqns{k}{1}, 2) <= size(eqns{k}{2}, 2)
        unused{m - k + 1} = eqns{k}{2}(~ismember(eqns{k}{2}, constants));
    else
        dum = dum(dum ~= - k);
    end
end

n1 = size(groups, 2);

% While there are still reactions which have been unused
while ~isempty(dum)
    % let i be the reaction we check
    i = dum(j);
    
    % Let keep be the variables at the start of the reaction
    keep = unused{m + i + 1};
    
    % Check whether it is a forward or backwards reaction
    if i > 0
        g = 1;
        h = 2;
        b = eqns{i};
    else
        g = 2;
        h = 1;
        b = eqns{- i};
    end
    
    % Add any of the elements in the end of the reaction to any of the
    % groups which have an element in the start of the reaction
    for k = 1:n1
        ins = b{g}(ismember(b{g}, groups{k}));
        if any(ismember(b{g}, groups{k}))            
            if any(ismember(ins, groups{k}))
                outs = b{h};
                outs = outs(~ismember(outs, groups{k}));
                outs = outs(~ismember(outs, constants));
                groups{k} = [groups{k}, outs];
            end
            
            % Remove any variables from keep which get used here
            keep = keep(~ismember(keep, groups{k}));            
        end
    end
    
    % If keep is empty, remove reaction. Otherwise change the values of
    % unused to keep
    if isempty(keep)
        unused{m + i + 1} = [];
        dum = [dum(1:j - 1); dum(j + 1:end)];
        j = j - 1;
    else
        unused{m + i + 1} = keep;
    end
    
    % if j is bigger than the size of dum, set j = 1. Otherwise cycle j up
    % by 1
    if j + 1 <= size(dum, 1)
        j = j + 1;
    else
        j = 1;
    end
end

if exist('Var', 'var')
    groups = groups{1};
    start_vars = Var;
end
end