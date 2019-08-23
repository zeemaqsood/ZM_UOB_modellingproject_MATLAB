function write_to_latex(model)

% write_to_latex:
%
% This function takes the input of a number, and will return, in the
% command window the differential equations which can be copy and pasted
% into latex.
%
% See also: Modeln, Write_final_eqn2, Create_plot_vars
%
% Author: Sean Watson  Date: 06/08/2019  Version: v0.1


% Evaluate the model as in the input
eval(strcat('Model', num2str(model), "('N')"));

% Bring the necessary variable over from the Modeln function
global Plot_Vars IVs K eqns doubles constants catalysts n;

% Create an empty string for where the differential equations will be kept
dydt = strings(n, 1);

% m1 is the number of equations, m2 is the number of equations which are
% twice as likely
m1 = size(eqns, 2);
m2 = size(doubles, 2);

% Cycle through every term in the ODE
for i = 1:m1
    % Consider the ith term
    b = eqns{i};
    
    n1 = size(b{1}, 2);
    n2 = size(b{2}, 2);
    
    % Define which k value we are working with. Work with kval as opposed
    % to k as later we use contains k_ which occurs more than just for k.
    dum1 = strcat('kval(', num2str(2 * b{3}(1)), ')');
    
    % Multiply by any variables in the term. Use val instead of variable
    % name, we will convert val to names later.
    for j = 1:n1
        dum1 = strcat(dum1, " * var(", num2str(b{1}(j)), ')');
    end
    
    % Repeat for the reverse reaction
    dum2 = strcat('kval(', num2str(2 * b{3}(1) - 1), ')');
    
    for k = 1:n2
        dum2 = strcat(dum2, " * var(", num2str(b{2}(k)), ')');
    end
    
    % Check if the term should be doubled as it is twice as likely to occur
    for l = 1:m2
        if b{1} == doubles{l}{1}
            if b{2} == doubles{l}{2}
                dum1 = strcat("2 * ", dum1);
            end
        elseif b{1} == doubles{l}{2}
            if  b{2} == doubles{l}{1}
                dum2 = strcat("2 * ", dum2);
            end
        end
    end
    
    for j = 1:n1
        h = b{1}(j);
        d = 0;
        
        % Check to see if the variable in the reaction is a catalyst
        for f = 1:size(catalysts, 2)
            if h == catalysts{f}{1}
                if b{1} == catalysts{f}{2}
                    if b{2} == catalysts{f}{3}
                        d = 1;
                    end
                    
                elseif b{1} == catalysts{f}{3}
                    if b{2} == catalysts{f}{2}
                        d = 1;
                    end
                end
            end
        end
        
        % If not a catalyst add take away what is lost in the reaction and
        % add what is gained in the reverse reaction. Nothing happens to
        % the catalyst in the reaction
        if d == 0
            dydt(h) = strcat(dydt(h), " - ", dum1, " + ", dum2);
        end
    end
    
    % Repeat for the reverse action
    for k = 1:n2
        h = b{2}(k);
        d = 0;
        
        for f = 1:size(catalysts, 2)
            if h == catalysts{f}{1}
                if b{1} == catalysts{f}{2}
                    if b{2} == catalysts{f}{3}
                        d = 1;
                    end
                    
                elseif b{1} == catalysts{f}{3}
                    if b{2} == catalysts{f}{2}
                        d = 1;
                    end
                end
            end
        end
        
        if d == 0
            dydt(h) = strcat(dydt(h), " + ", dum1, " - ", dum2);
        end
    end
end

% Create var and kval to be sym variables so we can write them as inputs to
% the latex function
var = sym('var', [n, 1]);
IV = sym('IV', [n, 1]);
kval = sym('kval', [2 * size(K, 1), 1]);

% Convert all differential equations to latex form and put them equal to
% d(var)/dt in latex form.
for i = 1:n
    if dydt(i) == ""
        dydt(i) = latex(eval(strcat('var(', num2str(i), ") == ", num2str(IVs(i)))));
    else
        dydt(i) = strcat("\frac{d", Plot_Vars{i}, "}{dt} = ", latex(eval(dydt(i))));
    end
end

% If any variables are assumed to be constant, change their differential to
% zero. This means that the variables is always equal to its initial value.
% Convert the equation to latex form
for g = 1:length(constants)
    h = constants(g);
    dydt(h) = latex(eval(strcat('var(', num2str(h), ") == ", num2str(IVs(h)))));
end

% Create the extra equations formed by there being a limited supply of some
% variables in the system
final_eqn = Write_final_eqn2;

% Convert these equations to latex form
for i = 1:size(final_eqn, 1)
    final_eqn(i) = latex(eval(final_eqn(i)));
end

dydt = [dydt; final_eqn];

% Comvert all variables to formal variables and kval's to k_'s.
for i = 1:size(dydt, 1)
    for j = 1:n
        % If the term still contains {var}_{j}, then replace it with the
        % correct variable name
        while contains(dydt(i), strcat('{var}_{', num2str(j),'}'))
            dydt(i) = strcat(extractBefore(dydt(i), strcat('{var}_{', num2str(j),'}')), '{', Plot_Vars{j}, '}', extractAfter(dydt(i), strcat('{var}_{', num2str(j),'}')));
        end
    end
    
    for j = 1:2 * size(K, 1)
        % If the term still contains kval_{j} then replace it with the
        % correct k_n. If j is even, n = j/2. If n is odd, n = - ceil(j/2).
        % This has been done as arrays do not allow negative indices
        while contains(dydt(i), strcat('{kval}_{', num2str(j),'}'))
            if j/2 == floor(j/2)
                j1 = j/2;
                dydt(i) = strcat(extractBefore(dydt(i), strcat('{kval}_{', num2str(j),'}')), '{k}_{', num2str(j1), '}', extractAfter(dydt(i), strcat('{kval}_{', num2str(j),'}')));
            else
                j1 = - ceil(j/2);
                dydt(i) = strcat(extractBefore(dydt(i), strcat('{kval}_{', num2str(j),'}')), '{k}_{', num2str(j1), '}', extractAfter(dydt(i), strcat('{kval}_{', num2str(j),'}')));
            end
        end
    end
    
    for j = 1:n
        % If the term still contains kval_{j} then replace it with the
        % correct k_n. If j is even, n = j/2. If n is odd, n = - ceil(j/2).
        % This has been done as arrays do not allow negative indices
        while contains(dydt(i), strcat('{IV}_{', num2str(j),'}'))
            dydt(i) = strcat(extractBefore(dydt(i), strcat('{IV}_{', num2str(j),'}')), "{", Plot_Vars{j}, "}_{IV}" , extractAfter(dydt(i), strcat('{IV}_{', num2str(j),'}')));
        end
    end
    
    while contains(dydt(i), '\,\')
        dydt(i) = strcat(extractBefore(dydt(i), '\,\'), '\cdot\', extractAfter(dydt(i), '\,\'));
    end
end

% Display in command window what must be copied to Latex
for i = 1:size(dydt, 1)
    disp("\begin{equation}");
    disp(dydt(i));
    disp("\end{equation}");
end
end