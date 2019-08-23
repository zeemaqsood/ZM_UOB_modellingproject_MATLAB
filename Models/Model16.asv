function Model16
global Model_names Vars Plot_Vars IVs K eqns multiples catalysts constants n;

Model_names(16) = "Model R, RR, LL";

% Number of variables
m = 1;
n = 7 * m + 2;

Vars = cell(n, 1);
IVs = zeros(n, 1);
K = zeros(4, 2);

% Variable names and their initial values
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
    
    if i ~= m
        base = ['LL', base];
    
        Vars{i * 7 + 3} = base;
        Vars{i * 7 + 4} = [base, '_R'];
        Vars{i * 7 + 5} = [base, '_RR'];
    end
end

IVs(1) = 6.445 * 10^-3; % 'L', 1
IVs(2) = (35/65) * 6.445 * 10^-3;
IVs(3) = 100;

% Formal variable names displayed when used to plot graphs. If you would
% like to change any, do so here

Plot_Vars = Create_plot_vars(Vars);

% Define the K values. If no reverse reaction occurs, set the second value
% to zero
K(1, :) = [10^-3, 10^-2]; % [0.1, 0.1]
K(2, :) = [10^-3, 10^-2]; % [0.1, 0.1]

% Define the reactions i.e. {[1, 2],  6,  [1, 2]} means variables 1 and 2
% react to make variable 6 with rate constant K(1) and the reverse reaction 
% happens with rate constant K(2)


eqns = cell(1, 10 * m - 3);

%            in           out     k value numbers
eqns{1} = {["R", Vars{3}], Vars{4}, 1};
eqns{2} = {["R", Vars{4}], Vars{5}, 1};

for i = 1:m
    eqns{3 * i} = {["R", Vars{i * 7 - 1}], Vars{i * 7 + 2}, 1};
    if i ~= m
        eqns{3 * i + 1} = {["R", Vars{i * 7 + 3}], Vars{i * 7 + 4}, 1};	
        eqns{3 * i + 2} = {["R", Vars{i * 7 + 4}], Vars{i * 7 + 5}, 1};	
    end
end

for i = 0:m - 1
    eqns{3 * m + 4 * i + 1} = {["DR", i * 7 + 3], (i + 1) * 7, 2};
    eqns{3 * m + 4 * i + 2} = {["DR", i * 7 + 3], (i + 1) * 7 - 1, 2};
    eqns{3 * m + 4 * i + 3} = {["DR", (i + 1) * 7 - 1], (i + 1) * 7 + 1, 2};
    eqns{3 * m + 4 * i + 4} = {["DR", i * 7 + 4], (i + 1) * 7 + 2, 2};
end

for i = 1:m - 1
    eqns{3 * m + 4 * m + (i - 1) * 3 + 1} = {["LL", i * 7 - 1], i * 7 + 3, 3};
    eqns{3 * m + 4 * m + (i - 1) * 3 + 2} = {["LL", i * 7 + 2], i * 7 + 4, 3};
    eqns{3 * m + 4 * m + (i - 1) * 3 + 3} = {["LL", i * 7 + 1], (i + 1) * 7 - 1, 3};
end

for i = 1:m
    eqns{3 * m + 4 * m + 3 * (m - 1) + i} = {Vars{i * 7 - 1}, Vars{i * 7}, 4};
end

eqns = vars2nums(eqns(:, 1:11 * m - 3));

% Reactions which have multiple possibilities
multiples = cell(1, 2);

multiples{1} = zeros(0, 1);
multiples{2} = zeros(0, 1);
      
%                 Eqn No               Mult
% multiples{1}(1) = ; multiples{2}(1) = ; % 1, 4
      

% Variables which are not used in a reaction, just used as a catalyst
catalysts = cell(1, 2);

% How many catlysts occur?
catalysts{1} = zeros(0, 1);
catalysts{2} = strings(0, 1);

%                 Eqn number            Var
% catalysts{1}(1) = ; catalysts{2}(1) = ; % 1, "LL"

catalysts{2} = vars2nums(catalysts{2});
      

% Variables which we assume to stay constant
constants = vars2nums(3); % [1, 2]
    
end