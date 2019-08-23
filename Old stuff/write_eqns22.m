function dydt =  write_eqns22(model)

eval(strcat('Model', num2str(model)));

global Vars IVs K eqns doubles constants catalysts;

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
    dum1 = num2str(K(b{3}(1), 1));
    
    % Multiply by any variables in the term
    for j = 1:n1
        dum1 = strcat(dum1, " * ", Vars(b{1}(j)));
    end
    
    for j = 1:size(catalysts, 2)
        a = catalysts{j};
        if all(b{1} == a{2}) && all(b{2} == a{3})
            for k = 1:size(a{1}, 2)
                dum1 = strcat(dum1, " * ", Vars(a{1}(k)));
            end
        end
    end
    
    % Repeat for the reverse reaction
    dum2 = num2str(K(b{3}(1), 2));
    
    for k = 1:n2
        dum2 = strcat(dum2, " * ", Vars(b{2}(k)));
    end
    
    for j = 1:size(catalysts, 2)
        a = catalysts{j};
        if all(b{1} == a{3}) && all(b{2} == a{2})
            for k = 1:size(a{1}, 2)
                dum2 = strcat(dum2, " * ", Vars(a{1}(k)));
            end
        end
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
        dydt(i) = strcat(dydt(i), " == 0");
    end
end

% If any variables are assumed to be constant, change their dydt to zero
for g = 1:length(constants)
    h = constants(g);
    dydt(h) = strcat(Vars(h), " == ", num2str(IVs(h)));
end

final_eqn = Write_final_eqn;

dydt = [dydt; final_eqn];

end