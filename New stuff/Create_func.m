function varsout = Create_func(model, var, x)

if model
    Models(model, 'N');
end

dydt = Write_Eqns("Stable");

global Vars;

n = size(Vars, 1);

for i = 1:n
    eval(strcat(Vars{i},' = sym(Vars{i})', ';'));
end

eqns = sym('eqns', [1, n + size(dydt, 1)]);

for i = 1:n
    eqns(2 * i - 1) = eval(dydt(i));
    eqns(2 * i) = eval(Vars{i}) >= 0;
end

for i = 1:size(dydt, 1) - n
    eqns(2 * n + i) = eval(dydt(n + i));
end

S = solve(eqns(2:end), Vars, 'ReturnConditions', true);

func = eval(strcat("S.", Vars(var)));
eval(strcat("f = @(z) ", string(func), " - ", num2str(x)));
z = fsolve(f, 0);
varsout = zeros(length(Vars), 1);

for i = 1:length(Vars)    
    func = eval(strcat("S.", Vars(i)));
    eval(strcat("g = @(z) ", string(func), ";"));
    varsout(i) = g(z);
end

end
