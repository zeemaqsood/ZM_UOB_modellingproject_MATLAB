function Model3

global Model_names Vars Plot_Vars IVs unit K K_units K_unit eqns multiples catalysts constants n T_unit;

Model_names(1) = "Testing";

% Number of variables
n = 6;

%Creating row matrices, with the number of columns beiong dependent on the
%number of species involved in the model

Vars = cell(n, 1);
IVs = zeros(n, 1);
unit = "";

Var_unit = strings(n, 1);

% Variable names and their initial values
Vars{1} = 'L';          IVs(1) = 1;   Var_unit(1) = "u"; % 'L', 1, any of the following ["y", "z", "a", "f", "p", "n", "u", "m", "", "K", "M", "G", "T", "P", "E", "Z", "Y"]
Vars{2} = 'R';          IVs(2) = 1;    Var_unit(2) = "u";
Vars{3} = 'L_R';        IVs(3) = 0;      Var_unit(3) = "";
Vars{4} = 'L_RR';       IVs(4) = 0;      Var_unit(4) = "";
Vars{5} = 'L_RRR';      IVs(5) = 0;      Var_unit(5) = "";
Vars{6} = 'L_RRRR';     IVs(6) = 0;      Var_unit(6) = "";

IVs = equiv(IVs, Var_unit, unit);

% Formal variable names displayed when used to plot graphs. If you would
% like to change any, do so here

Plot_Vars = Create_plot_vars(Vars);

% Define the reactions i.e. {[1, 2],  6,  [1, 2]} means variables 1 and 2
% react to make variable 6 with rate constant K(1) and the reverse reaction 
% happens with rate constant K(2)

eqns = cell(1, 1);

%            in           out     k value numbers
eqns{1} = {["L", "R"], "L_R", 1}; % {["R", "LL_R"], "LL_RR", 2}
eqns{2} = {["L_R", "R"], "L_RR", 2}; % {["R", "LL_R"], "LL_RR", 2}
eqns{3} = {["L_RR", "R"], "L_RRR", 3}; % {["R", "LL_R"], "LL_RR", 2}
eqns{4} = {["L_RRR", "R"], "L_RRRR", 4}; % {["R", "LL_R"], "LL_RR", 2}

% convert character or string array to numbers
eqns = vars2nums(eqns);

% Define the K values. If no reverse reaction occurs, set the second value
% to zero

K = zeros(4, 2);
K_unit = "u";
T_unit = "";

K(1, :) = [1, 1];
K(2, :) = [1, 1];
K(3, :) = [1, 1];
K(4, :) = [1, 1];

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
catalysts{2} = cell(0, 1);

%                 Eqn number            Var
% catalysts{1}(1) = ; catalysts{2}{1} = ; % 1, "LL"

catalysts{2} = vars2nums(catalysts{2});

K_units = K_Var_units;

% Variables which we assume to stay constant
constants = vars2nums([1]); % [1, 2]
    
end