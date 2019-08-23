function eqns_nums = eqn_vars_2_nums(eqns_vars)

% eqn_vars_2_nums:
%
% This function takes a cell of variables and returns them to their number
% equivalents as defined in the Modeln function
%
% See also: Moeln
%
% Author: Sean Watson  Date: 06/08/2019  Version: v0.1

global Vars;

% Let n be the number of equations
n = size(eqns_vars, 2);

% For every variable in Vars, set that variable equal to the number when it
% occurs
for i = 1:size(Vars, 1)
    eval(strcat(Vars(i), " = ", num2str(i), ";"));
end

% If the eqns_vars is a string, change all variables to their number
% equivalent
if isstring(eqns_vars)
    eqns_nums = zeros(size(eqns_vars));
    
    for i = 1:size(eqns_vars, 1)
        for j = 1:size(eqns_vars, 2)
            eqns_nums(i, j) = eval(eqns_vars(i, j));
        end
    end
    
% If the number is not numeric or string
elseif ~isnumeric(eqns_vars)
    % Create the eqns_nums the same size of eqns_vars
    eqns_nums = cell(size(eqns_vars));
    
    % Replace every element
    for i = 1:n 
        for j = 1:size(eqns_vars{i}, 2)
            for k = 1:size(eqns_vars{i}{j}, 2)
                % If the variable is already number, leave as it is
                % otherwise change the string to its number equivalent
                if isnumeric(eqns_vars{i}{j}(k))
                    eqns_nums{i}{j}(k) = eqns_vars{i}{j}(k);
                else
                    eqns_nums{i}{j}(k) = eval(eqns_vars{i}{j}(k));
                end
            end
        end
    end
% When already all numbers, leave as is 
else
    eqns_nums = eqns_vars;
end

end
