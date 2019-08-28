function Model18

global Model_names Vars Plot_Vars IVs K K_units units eqns multiples catalysts constants n;

Model_names(18) = "Delay";

% Number of variables
n = 3;

Vars = cell(n, 1);
IVs = zeros(n, 1);

Var_units = strings(n, 1);
units = ''; % Any of the following ["p", "n", "u", "m", "", "K", "M", "G", "T"]

% Variable names and their initial values
Vars{1} = 'L';          IVs(1) = 1;              Var_units(1) = "n"; % 'L', 1, any of the following ["p", "n", "u", "m", "", "K", "M", "G", "T"]
Vars{2} = 'R0';         IVs(2) = 6.445 * 10^-3;  Var_units(2) = "n";
Vars{3} = 'Syk';        IVs(3) = 6.445 * 10^-3;  Var_units(3) = "n";
Vars{4} = 'L_R0';       IVs(4) = 0;              Var_units(4) = "";
Vars{5} = 'L_R0_Syk';   IVs(5) = 0;              Var_units(5) = "";
Vars{6} = 'L_R1_Syk';   IVs(6) = 0;              Var_units(6) = "";

size_change = equiv(units, Var_units);

IVs = IVs .* size_change;

% Formal variable names displayed when used to plot graphs. If you would
% like to change any, do so here

Plot_Vars = Create_plot_vars(Vars);

% Define the reactions i.e. {[1, 2],  6,  [1, 2]} means variables 1 and 2
% react to make variable 6 with rate constant K(1) and the reverse reaction 
% happens with rate constant K(2)

eqns = cell(1, 1);

%            in           out     k value numbers
eqns{1} = {["L", "R0"], "L_R0", 1}; % {["R", "LL_R"], "LL_RR", 2}
eqns{2} = {["L_R0", "Syk"], "L_R0_Syk", 2}; % {["R", "LL_R"], "LL_RR", 2}
eqns{3} = {"L_R0_Syk", "L_R1_Syk", 3}; % {["R", "LL_R"], "LL_RR", 2}

eqns = vars2nums(eqns);   

% Define the K values. If no reverse reaction occurs, set the second value
% to zero
K = zeros(3, 2);
K_units = strings(3, 1);

K(1, :) = [0.1, 0.1];  K_unit(1) = ""; % [0.1, 0.1], any of the following ["p", "n", "u", "m", "", "K", "M", "G", "T"]
K(2, :) = [0.1, 0.1];  K_unit(2) = ""; % [0.1, 0.1], any of the following ["p", "n", "u", "m", "", "K", "M", "G", "T"]
K(3, :) = [0.1, 0.1];  K_unit(3) = ""; % [0.1, 0.1], any of the following ["p", "n", "u", "m", "", "K", "M", "G", "T"]

K_units = K_Var_units(units, K_unit);

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
constants = vars2nums(1); % [1, 2]
    
end