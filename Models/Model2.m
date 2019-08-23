function Model2

global Model_names Vars Plot_Vars IVs K eqns multiples constants catalysts n;

Model_names(2) = "2";

Vars = cell(8, 1);
IVs = zeros(8, 1);
K = zeros(3, 2);

% Variable names and their initial values
Vars{1} = 'LL';             IVs(1) = 1;
Vars{2} = 'R0';             IVs(2) = 1;
Vars{3} = 'R1';             IVs(3) = 0;
Vars{4} = 'LL_R0';           IVs(4) = 0;
Vars{5} = 'LL_R1';           IVs(5) = 0;
Vars{6} = 'LL_R0R0';         IVs(6) = 0;
Vars{7} = 'LL_R0R1';         IVs(7) = 0;
Vars{8} = 'LL_R1R1';         IVs(8) = 0;

% Formal variable names displayed when used to plot graphs. If you would
% like to change any, do so here

Plot_Vars = Create_plot_vars(Vars);

% Define the K values
K(1, :) = [0.1, 0.1];
K(2, :) = [0.1, 0.1];
K(3, :) = [0.1, 0.1];

% Define the reactions i.e. {[1, 2],  6,  [1, 2]} means variables 1 and 2
% react to make variable 6 with rate constant K(1) and the reverse reaction 
% happens with rate constant K(2). If no reverse reaction occurs, set the
% second k value number to zero.

eqns = cell(1, 10);
%           in                 out        k value numbers
eqns{1} =  {["LL", "R0"],     "LL_R0",    1};
eqns{2} =  { "R0",            "R1",       2};
eqns{3} =  {["LL", "R1"],     "LL_R1",    3};
eqns{4} =  {["R0", "LL_R0"],  "LL_R0R0",  1};
eqns{5} =  {["R1", "LL_R0"],  "LL_R0R1",  3};
eqns{6} =  { "LL_R0",         "LL_R1",    2};
eqns{7} =  {["R0", "LL_R1"],  "LL_R0R1",  1};
eqns{8} =  {["R1", "LL_R1"],  "LL_R1R1",  3};
eqns{9} =  { "LL_R0R0",       "LL_R0R1",  2};
eqns{10} = { "LL_R0R1",       "LL_R1R1",  2};

eqns = vars2nums(eqns);


% Reactions which have multiple possibilities
multiples = cell(1, 2);

multiples{1} = zeros(6, 1);
multiples{2} = zeros(6, 1);
      
%                 Eqn No               Mult
multiples{1}(1) = 1;   multiples{2}(1) = 2;
multiples{1}(2) = 3;   multiples{2}(2) = 2;
multiples{1}(3) = -4;  multiples{2}(3) = 2;
multiples{1}(4) = -8;  multiples{2}(4) = 2;
multiples{1}(5) = 9;   multiples{2}(5) = 2;
multiples{1}(6) = -10; multiples{2}(6) = 2;


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
n = 8;

end