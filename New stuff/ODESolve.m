function S = ODESolve(model)

Models(model, 'N');
eval(strcat("Model", num2str(model), "('N')"));

global Vars IVs;

dydt = write_eqns("Solve");

for i = 1:size(Vars, 1)
    eval(strcat("syms ", Vars{i}, "(t)"));
end

odes = eval(dydt(1));
eval(strcat("conds = ", Vars{1}, "(0) == ", num2str(IVs(1)), ";"));

for i = 2:size(Vars, 1)
    odes = [odes; eval(dydt(i))];
    conds = [conds; eval(strcat(Vars{i}, "(0) == ", num2str(IVs(i))))];
end

S = dsolve(odes, conds);
end