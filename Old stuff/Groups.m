function [groups, start_vars] = Groups

% Groups:
% 
% This function group all available variables into groups of which the base
% elements are limited.
% 
% See also:
%
% Author: Sean Watson  Date: 06/08/2019  Version: v0.1

global eqns catalysts Vars constants;

% n is the number of Variables, m is the number of equations
n = size(Vars, 1);
m = size(eqns, 2);

% Let start_vars be a vector numbers corresponding to all variables
start_vars = 1:n;

% If a variables is constant, remove it as the supply of that variable is
% 'unlimited'
start_vars = start_vars(~ismember(start_vars, constants));

% Remove any elements which can be produced from other variables. These are
% not base elements. All other variables are start variables and cannot be
% produced
for j = 1:m
    b = eqns{j};
    start_vars = start_vars(~ismember(start_vars, b{2}));
end

groups = num2cell(start_vars);
unused = eqns;
j = 1;

for k = 1:size(unused, 2)
    unused{k}{3} = unused{k}{1}(~ismember(unused{k}{1}, constants));
end

while ~isempty(unused)
    n1 = size(groups, 2);
    b = unused{j};
    keep = b{3};
    
    for k = 1:n1
        ins = b{1}(ismember(b{1}, groups{k}));
        if any(ismember(b{1}, groups{k}))
            
            for k1 = 1:size(catalysts, 2)
                if all(catalysts{k1}{2} == b{1}) && all(catalysts{k1}{3} == b{2})
                    ins = ins(ins ~= catalysts{k1}{1});
                end
            end
            
            if any(ismember(ins, groups{k}))
                outs = b{2};
                outs = outs(~ismember(outs, groups{k}));
                outs = outs(~ismember(outs, constants));
                groups{k} = [groups{k}, outs];
            end
            
            keep = keep(~ismember(keep, groups{k}));            
        end
    end
    
    if isempty(keep)
        unused(j) = [];
        j = j - 1;
    else
        unused{j}{3} = keep;
    end
    
    if j + 1 <= size(unused, 2)
        j = j + 1;
    else
        j = 1;
    end
end
end