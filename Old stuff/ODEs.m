function dydt = ODEs(t, v)

global K Vars eqns doubles constants catalysts;

n = size(Vars, 1);
dydt = zeros(n, 1);
m1 = size(eqns, 2);
m2 = size(doubles, 2);

% Cycle through every term in the ODE
for i = 1:m1
    % Consider the ith term
    b = eqns{i};
    
    n1 = size(b{1}, 2);
    n2 = size(b{2}, 2);
    
    % Define which k value we are working with
    dum1 = K(b{3}(1), 1);
    
    % Multiply by any variables in the term
    for j = 1:n1
        dum1 = dum1 * v(b{1}(j));
    end

    % Repeat for the reverse reaction
    dum2 = K(b{3}(1), 2);

    for k = 1:n2
        dum2 = dum2 * v(b{2}(k));
    end

    % Check if the term should be doubled as it is twice as likely to occur
    for l = 1:m2
        if b{1} == doubles{l}{1}
            if b{2} == doubles{l}{2}
                dum1 = dum1 * 2;
            end
        elseif b{1} == doubles{l}{2} 
            if  b{2} == doubles{l}{1}
                dum2 = dum2 * 2;
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
            dydt(h) = dydt(h) - dum1 + dum2;
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
            dydt(h) = dydt(h) + dum1 - dum2;
        end
    end
    
    % If any variables are assumed to be constant, change their dydt to zero
    for g = 1:length(constants)
        h = constants(g);
        dydt(h) = 0;
    end
end