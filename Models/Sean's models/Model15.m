function Model15

global Model_names Vars Plot_Vars IVs K KD eqns multiples catalysts constants n;

Model_names(11) = "Single L, mouse";

n = 7;

Vars = cell(n, 1);
IVs = zeros(n, 1);
K = zeros(3, 2);

% Variable names and their initial values
Vars{1} = 'L';       IVs(1) = 100; % nM
Vars{2} = 'R';       IVs(2) = 6.445 * 10^-3; % nM
Vars{3} = 'Syk';     IVs(3) = 1; % nM
Vars{4} = 'L_R';     IVs(4) = 0;
Vars{5} = 'L_R_Syk'; IVs(5) = 0;
Vars{6} = 'LAT0';    IVs(6) = 1;
Vars{7} = 'LAT1';    IVs(7) = 0;

n = size(Vars, 1);

% Formal variable names displayed when used to plot graphs. If you would
% like to change any, do so here

Plot_Vars = Create_plot_vars(Vars);

% Define the K values. If no reverse reaction occurs, set the second value
% to zero
K(1, :) = [10^-3, 10^-2]; % nM^-1s^-1, s^-1
K(2, :) = [0.1, 0.1]; % nM^-1s^-1, s^-1
K(3, :) = [0.1, 0.1]; % nM^-1s^-1, s^-1

KD = K(:, 2)./K(:, 1);

% Define the reactions i.e. {[1, 2],  6,  [1, 2]} means variables 1 and 2
% react to make variable 6 with rate constant K(1) and the reverse reaction 
% happens with rate constant K(2)

eqns = cell(1, 2);

%            in           out     k value numbers
eqns{1} = {["L", "R"],  "L_R",  1};
eqns{2} = {["L_R", "Syk"],  "L_R_Syk",  2};
eqns{3} = {"LAT0",  "LAT1",  3};

eqns = vars2nums(eqns);
    

% Reactions which have multiple possibilities
multiples = cell(1, 2);

multiples{1} = zeros(0, 1);
multiples{2} = zeros(0, 1);
      
%                 Eqn No               Mult
% multiples{1}(1) = 1; multiples{2}(1) = 4;


% Variables which are not used in a reaction, just used as a catalyst
catalysts = cell(1, 2);

% How many catlysts occur?
catalysts{1} = zeros(1, 1);
catalysts{2} = cell(1, 1);

%                 Eqn number            Var
catalysts{1}(1) = 3; catalysts{2}{1} = ["L_R_Syk", "L_R"];

catalysts{2} = vars2nums(catalysts{2});
      
% Variables which we assume to stay constant
constants = vars2nums(1);
    
end