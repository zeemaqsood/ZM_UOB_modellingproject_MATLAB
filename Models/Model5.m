function Model5

global Model_names Vars Plot_Vars IVs K eqns multiples constants catalysts n;

Model_names(5) = "5";

Vars = cell(4, 1);
IVs = zeros(4, 1);
K = zeros(1, 2);

% Variable names and their initial values
Vars{1} = 'L';               IVs(1) = 1;
Vars{2} = 'RR';              IVs(2) = 1;
Vars{3} = 'L_RR';             IVs(3) = 0;
Vars{4} = 'LL_RR';            IVs(4) = 0;

% Formal variable names displayed when used to plot graphs. If you would
% like to change any, do so here

Plot_Vars = Create_plot_vars(Vars);

% Define the K values
K(1, :) = [0.1, 0.1];

% Define the reactions i.e. {[1, 2],  6,  [1, 2]} means variables 1 and 2
% react to make variable 6 with rate constant K(1) and the reverse reaction 
% happens with rate constant K(2). If no reverse reaction occurs, set the
% second k value number to zero.

eqns = cell(1, 2);

%                         in                 out           k value numbers
eqns{1} = {["L", "RR"],  "L_RR",  1};
eqns{2} = {["L", "L_RR"], "LL_RR", 1};

eqns = vars2nums(eqns);
    

% Reactions which have multiple possibilities
multiples = cell(1, 2);

multiples{1} = zeros(2, 1);
multiples{2} = zeros(2, 1);
      
%                 Eqn No               Mult
multiples{1}(1) = 1;    multiples{2}(1) = 2;
multiples{1}(2) = -2;   multiples{2}(2) = 2;
          

% Variables which are not used in a reaction, just used as a catalyst
catalysts = cell(1, 2);

% How many catlysts occur?
catalysts{1} = []; % zeros(2, 1);
catalysts{2} = []; % strings(2, 1);

%                 Eqn number            Var
% catalysts{1}(1) = 1; catalysts{2}(1) = "LL";

catalysts{2} = vars2nums(catalysts{2});
        
       
% Variables which we assume to stay constant
constants = vars2nums(1);
     
% Number of variables
n = 4;

end