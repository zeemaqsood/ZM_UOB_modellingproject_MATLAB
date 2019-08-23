function dydt =  write_eqns3

global Vars IVs eqns doubles constants catalysts;

n = size(Vars, 1);
dydt = strings(n, 1);
m1 = size(eqns, 2);

% Cycle through every term in the ODE
for i = 1:m1
    % Consider the ith term
    b = eqns{i};
    
    n1 = size(b{1}, 2);
    n2 = size(b{2}, 2);
    
    % Define which k value we are working with
    dum1 = strcat('k',num2str(b{3}));
    
    % Multiply by any variables in the term
    for j = 1:n1
        dum1 = strcat(dum1, " * ", Vars(b{1}(j)));
    end
    
    if ismember(i, catalysts{1})
        a = catalysts{2}(catalysts{1} == i);
        
        for k = 1:size(a, 1)
            dum1 = strcat(dum1, " * ", Vars(a(k)));
        end
    end
    
    % Repeat for the reverse reaction
    dum2 = strcat('k',num2str(-b{3}));
    
    for k = 1:n2
        dum2 = strcat(dum2, " * ", Vars(b{2}(k)));
    end
    
    if ismember(- i, catalysts{1})
        a = catalysts{2}(catalysts{1} == - i);
        
        for k = 1:size(a, 1)
            dum1 = strcat(dum1, " * ", Vars(a(k)));
        end
    end

        
    % Check if the term should be doubled as it is twice as likely to occur
    if ismember(i, doubles)
        dum1 = strcat("2 * ", dum1);
    end
    
    if ismember(-i, doubles)
        dum2 = strcat("2 * ", dum2);
    end
    
    for j = 1:n1
        h = b{1}(j);
        dydt(h) = strcat(dydt(h), " - ", dum1, " + ", dum2);
    end
    
    % Repeat for the reverse action
    for k = 1:n2
        h = b{2}(k);
        dydt(h) = strcat(dydt(h), " + ", dum1, " - ", dum2);
    end
end

for i = 1:n
    if dydt(i) == ""
        dydt(i) = strcat(Vars(i), " == ", num2str(IVs(i)));
    else
        dydt(i) = strcat(Vars(i), "' == ", dydt(i));
    end
end

% If any variables are assumed to be constant, change their dydt to zero
for g = 1:length(constants)
    h = constants(g);
    dydt(h) = strcat(Vars(h), " == ", num2str(IVs(h)));
end

final_eqn = Write_final_eqn("Solve");

dydt = [dydt; final_eqn];

end