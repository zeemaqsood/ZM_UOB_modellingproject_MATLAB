function all_eqns =  write_eqns(model)

if exist('model', 'var')
    eval(strcat('Model', num2str(model), 'N'));
end

global Vars eqns doubles constants catalysts;

n = size(Vars, 1);
dydt = strings(n, 1);
m1 = size(eqns, 2);
m2 = size(doubles, 2);

% Cycle through every term in the ODE
for i = 1:m1
    % Consider the ith term
    b = eqns{i};
    
    n1 = size(b{1}, 2);
    n2 = size(b{2}, 2);
    
    % Define which k value we are working with
    dum1 = strcat("k", num2str(b{3}(1), 1));
    
    % Multiply by any variables in the term
    for j = 1:n1
        dum1 = strcat(dum1, " * ", Vars(b{1}(j)));
    end

    % Repeat for the reverse reaction
    dum2 = strcat("k-", num2str(b{3}(1), 2));

    for k = 1:n2
        dum2 = strcat(dum2, " * ", Vars(b{2}(k)));
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
        % add what is gained in the reverse reaction
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

for g = 1:length(constants)
    h = constants(g);
    dydt(h) = " 0";
end

for i = 1:n
    dydt(i) = strcat(Vars(i), "' =", dydt(i));
end

final_eqns = Write_final_eqn;
all_eqns = [dydt; final_eqns];

end
