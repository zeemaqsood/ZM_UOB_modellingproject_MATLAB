m = 1;
n = 3 * m + 2;

Vars = cell(n, 1);

Vars{1} = 'R';
Vars{2} = 'DR';
Vars{3} = 'LL';
Vars{4} = 'LL_R';
Vars{5} = 'LL_RR';

base = 'LL_';

for i = 1:m
    base = [base, 'DR'];
    
    Vars{i * 7 - 1} = base;
    Vars{i * 7} = [base, '_loop'];
    Vars{i * 7 + 1} = [base, 'DR'];
    Vars{i * 7 + 2} = [base, '_R'];
    
    base = ['LL', base];
    
    Vars{i * 7 + 3} = base;
    Vars{i * 7 + 4} = [base, '_R'];
    Vars{i * 7 + 5} = [base, '_RR'];
end



eqns = cell(1, 10 * m + 6);

%            in           out     k value numbers
eqns{1} = {["R", 3], 4, 1};
eqns{2} = {["R", 4], 5, 1};

for i = 1:m
    eqns{3 * i} = {["R", i * 7 - 1], i * 7 + 2, 1};	
    eqns{3 * i + 1} = {["R", i * 7 + 3], i * 7 + 4, 1};	
    eqns{3 * i + 2} = {["R", i * 7 + 4], i * 7 + 5, 1};	
end

for i = 0:m - 1
    eqns{3 * (m + 1) + 4 * i + 1} = {["DR", i * 7 + 3], (i + 1) * 7, 1};
    eqns{3 * (m + 1) + 4 * i + 2} = {["DR", i * 7 + 3], (i + 1) * 7 - 1, 1};
    eqns{3 * (m + 1) + 4 * i + 3} = {["DR", (i + 1) * 7 - 1], (i + 1) * 7 + 1, 1};
    eqns{3 * (m + 1) + 4 * i + 4} = {["DR", i * 7 + 4], (i + 1) * 7 + 2, 1};
end

for i = 1:m
    eqns{3 * (m + 1) + 4 * m + i * 3 + 1} = {["LL", i * 7 - 1], i * 7 + 3, 1};
    eqns{3 * (m + 1) + 4 * m + i * 3 + 2} = {["LL", i * 7 + 2], i * 7 + 4, 1};
    eqns{3 * (m + 1) + 4 * m + i * 3 + 3} = {["LL", i * 7 + 1], (i + 1) * 7 - 1, 1};
end

eqns = vars2nums(eqns(:, 10 * m + 5));
