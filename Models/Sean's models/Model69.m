function Model69

global Model_names Vars Plot_Vars IVs units K K_units T_units eqns multiples catalysts constants n;

Model_names(69) = "test";

% Number of variables
n = 2;

Vars = cell(n, 1);
IVs = zeros(n, 1);
unit = "";

Var_unit = strings(n, 1);

% Variable names and their initial values
Vars{1} = 'L0';        IVs(1) = 0.9;      Var_unit(1) = "";
Vars{2} = 'L1';        IVs(2) = 0.1;      Var_unit(2) = "";

IVs = equiv(IVs, Var_unit, unit);

% Formal variable names displayed when used to plot graphs. If you would
% like to change any, do so here

Plot_Vars = Create_plot_vars(Vars);

% Define the reactions i.e. {[1, 2],  6,  [1, 2]} means variables 1 and 2
% react to make variable 6 with rate constant K(1) and the reverse reaction 
% happens with rate constant K(2)

eqns = cell(1, 1);

%            in           out     k value numbers
eqns{1} = {"L0", "L1", 1}; % {["R", "LL_R"], "LL_RR", 2}

eqns = vars2nums(eqns);

% Define the K values. If no reverse reaction occurs, set the second value
% to zero

K = zeros(1, 2);
K_unit = strings(1, 1);
T_unit = "";

K(1, :) = [1, 0.1];  K_unit(1) = ""; % [0.1, 0.1], any of the following ["y", "z", "a", "f", "p", "n", "u", "m", "", "K", "M", "G", "T", "P", "E", "Z", "Y"]
  

% Reactions which have multiple possibilities
multiples = cell(1, 2);

multiples{1} = zeros(0, 1);
multiples{2} = zeros(0, 1);
      
%                 Eqn No               Mult
% multiples{1}(1) = ; multiples{2}(1) = ; % 1, 4
      

% Variables which are not used in a reaction, just used as a catalyst
catalysts = cell(1, 2);

% How many catlysts occur?
catalysts{1} = zeros(1, 1);
catalysts{2} = cell(1, 1);

%                 Eqn number            Var
catalysts{1}(1) = 1; catalysts{2}{1} = "L1"; % 1, "LL"

catalysts{2} = vars2nums(catalysts{2});

K_units = K_Var_units;
% Variables which we assume to stay constant
constants = vars2nums([]); % [1, 2]
    
end