function Model333

global Model_names Vars Plot_Vars IVs K K_units K_unit T_unit unit eqns multiples catalysts constants n PlotVars;

Model_names(333) = "333";

% Number of variables
n = 8;

Vars = cell(n, 1);
IVs = zeros(n, 1);
unit = "u";
PlotVars = cell(n, 1);

Var_unit = strings(n, 1);

% Variable names and their initial values
Vars{1} = 'LL';                 IVs(1) = 1000;                Var_unit(1) = "u"; % 'L', 1, any of the following ["p", "n", "u", "m", "", "K", "M", "G", "T"]
Vars{2} = 'M';                  IVs(2) = 0.5;                 Var_unit(2) = "u";
Vars{3} = 'D';                  IVs(3) = 0.5;                 Var_unit(3) = "u";
Vars{4} = 'LL_M';               IVs(4) = 0;                   Var_unit(4) = "u";
Vars{5} = 'LL_M_M';             IVs(5) = 0;                   Var_unit(5) = "u";
Vars{6} = 'LL_M_D';             IVs(6) = 0;                   Var_unit(6) = "u";
Vars{7} = 'LL_D';               IVs(7) = 0;                   Var_unit(7) = "u";
Vars{8} = 'LL_D_D';             IVs(8) = 0;                   Var_unit(8) = "u";
Vars{9} = 'LL_M_D_M';           IVs(8) = 0;                   Var_unit(8) = "u";
Vars{10} = 'LL_M_D_D';          IVs(8) = 0;                   Var_unit(8) = "u";
Vars{11} = 'LL_D_D_D';          IVs(8) = 0;                   Var_unit(8) = "u";
Vars{12} = 'LL_D_D_D_D';        IVs(8) = 0;                   Var_unit(8) = "u";

PlotVars{1} = 'LL';
PlotVars{2} = 'M';
PlotVars{3} = 'D';
PlotVars{4} = 'LLM';
PlotVars{5} = 'LLMM';
PlotVars{6} = 'LLMD';
PlotVars{7} = 'LLD';
PlotVars{8} = 'LLDD';
PlotVars{9} = 'LLMDM';
PlotVars{10} = 'LLMDD';
PlotVars{11} = 'LLDDD';
PlotVars{11} = 'LLDDDD';

IVs = equiv(IVs, Var_unit, unit);

% Formal variable names displayed when used to plot graphs. If you would
% like to change any, do so here

Plot_Vars = Create_plot_vars(PlotVars);

% Define the reactions i.e. {[1, 2],  6,  [1, 2]} means variables 1 and 2
% react to make variable 6 with rate constant K(1) and the reverse reaction 
% happens with rate constant K(2)

eqns = cell(1, 2);

%            in           out     k value numbers
eqns{1} = {["LL", "M"], "LL_M", 1}; % {["R", "LL_R"], "LL_RR", 2}
eqns{2} = {["LL_M", "M"], "LL_M_M", 2}; % {["R", "LL_R"], "LL_RR", 2}
eqns{3} = {["LL_M", "D"], "LL_M_D", 3}; % {["R", "LL_R"], "LL_RR", 2}
eqns{4} = {["LL", "D"], "LL_D", 4}; % {["R", "LL_R"], "LL_RR", 2}
eqns{5} = {["LL_D", "M"], "LL_M_D", 5}; % {["R", "LL_R"], "LL_RR", 2}
eqns{6} = {["LL_D", "D"], "LL_D_D", 6}; % {["R", "LL_R"], "LL_RR", 2}
eqns{7} = {["M", "M"], "D", 7}; % {["R", "LL_R"], "LL_RR", 2}
eqns{8} = {["LL_M_D", "M"], "LL_M_D_M", 8}; % {["R", "LL_R"], "LL_RR", 2}
eqns{9} = {["LL_M_D", "D"], "LL_M_D_D", 9}; % {["R", "LL_R"], "LL_RR", 2}
eqns{10} = {["LL_D_D", "M"], "LL_M_D_D", 10}; % {["R", "LL_R"], "LL_RR", 2}
eqns{11} = {["LL_D_D", "D"], "D", 11}; % {["R", "LL_R"], "LL_RR", 2}
eqns{12} = {["LL_D_D_D"], "D", 12}; % {["R", "LL_R"], "LL_RR", 2}
% eqns{3} = {"L_R0_Syk", "L_R1_Syk", 3}; % {["R", "LL_R"], "LL_RR", 2}

eqns = vars2nums(eqns);   

% Define the K values. If no reverse reaction occurs, set the second value
% to zero
K = zeros(12, 2);
K_unit = "u"; % any of the following ["p", "n", "u", "m", "", "K", "M", "G", "T"]
T_unit = "";

K(1, :) = [1, 1];
K(2, :) = [1, 1];
K(3, :) = [1, 1];
K(4, :) = [1, 1];
K(5, :) = [1, 1];
K(6, :) = [1, 1];
K(7, :) = [1, 1];
K(8, :) = [1, 1];
K(9, :) = [1, 1];
K(10, :) = [1, 1];
K(11, :) = [1, 1];
K(12, :) = [1, 1];

% Reactions which have multiple possibilities
multiples = cell(1, 2);

multiples{1} = zeros(0, 1);
multiples{2} = zeros(0, 1);
      
%                 Eqn No               Mult
% multiples{1}(1) =  1; multiples{2}(1) = 2; % 1, 4
% multiples{1}(2) = -2;multiples{2}(2) = 2; % 1, 4
      
% Variables which are not used in a reaction, just used as a catalyst
catalysts = cell(1, 2);

% How many catlysts occur?
catalysts{1} = zeros(0, 1);
catalysts{2} = cell(0, 1);

%                 Eqn number            Var
% catalysts{1}(1) = 3; catalysts{2}{1} = "L_R0_Syk"; % 1, "LL"

catalysts{2} = vars2nums(catalysts{2});
  
K_units = K_Var_units;

% Variables which we assume to stay constant
constants = vars2nums(1); % [1, 2]
    
end