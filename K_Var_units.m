function K_units = K_Var_units(units, K_unit)

global eqns K catalysts

sizes = ["p", "n", "u", "m", "", "K", "M", "G", "T"];

[~, b] = ismember([units; K_unit], sizes);

K_units = strings(size(K));

for i = 1:length(eqns)
    eqn = eqns{i};
    
    k = eqn{3};
    
    mult = 10 ^ (3 * (b(k + 1) - b(1)));
    
    if K(k, 1) ~= 0 && K_units(k, 1) == ""
        f = catalysts{2}(catalysts{1} == i);
         
        s = 1 - length(eqn{1}) - length(f);
        
        K(k, 1) = K(k, 1) * mult^s;
        
        if s ~= 0
            K_units(k, 1) = strcat(units, "M^{", num2str(s), "}s^{-1}");
        else
            K_units(k, 1) = "s^{-1}";
        end
    end
    
    if K(k, 2) ~= 0 && K_units(k, 2) == ""
        f = catalysts{2}(catalysts{1} == -i);
        
        s = 1 - length(eqn{2})- length(f);
        
        K(k, 2) = K(k, 2) * mult^s;
        
        if s ~= 0
            K_units(k, 2) = strcat(units, "M^{", num2str(s), "}s^{-1}");
        else
            K_units(k, 2) = "s^{-1}";
        end
    end
end