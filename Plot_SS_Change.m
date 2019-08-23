function tab = Plot_SS_Change(model, Type, var, Plot, points)

Models(model, 'N');

global IVs K Vars Plot_Vars Model_names

Var = eqn_vars_2_nums(var);

if Type == "IV"
    dummy = IVs(Var);
else
    if Var > 0
        b1 = 1;
        b2 = 1;
    else
        Var = - Var;
        b1 = -1;
        b2 = 2;
    end
    dummy = K(Var, b2);
end

tab = zeros(length(points), length(Plot) + 1);
tab(:, 1) = points;

for i = 1:length(points)
    if Type == "IV"
       IVs(Var) = points(i);
    else
        K(Var, b2) = points(i);
    end
    
    S = Steady_States(false);
    div = min(Write_Final_Eqn("Max_Num", Plot), [], 1);
        
    for j = 1:length(Plot)
        tab(i, j + 1) = eval(strcat("S.", Vars{Plot(j)}))/div(j);
    end
end

plot(tab(:, 1), tab(:, 2:end));
legend(Plot_Vars(Plot));
if Type == "IV"
    xlabel(strcat("Initial value of ", Plot_Vars(var)));
else
    xlabel(strcat("k_{", num2str(b1 * Var), "} value"));
end
ylabel("Proportion of possible variale created");
title(Model_names(model));

if Type == "IV"
    IVs(Var) = dummy;
else
    K(Var, b2) = dummy;
end
end
