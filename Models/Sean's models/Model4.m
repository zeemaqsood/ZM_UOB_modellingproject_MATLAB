function Model4

global Model_names Vars Plot_Vars IVs K eqns multiples constants catalysts n;

Model_names(4) = "4";

Vars = cell(14, 1);
IVs = zeros(14, 1);
K = zeros(5, 2);

% Variable names and their initial values
Vars{1} = 'LL';             IVs(1) = 1;
Vars{2} = 'R0';              IVs(2) = 1;
Vars{3} = 'R1';             IVs(3) = 0;
Vars{4} = 'Syk';            IVs(4) = 1;
Vars{5} = 'R1_Syk';          IVs(5) = 0;
Vars{6} = 'LL_R0';            IVs(6) = 0;
Vars{7} = 'LL_R1';           IVs(7) = 0;
Vars{8} = 'LL_R1_Syk';        IVs(8) = 0;
Vars{9} = 'LL_R0R0';           IVs(9) = 0;
Vars{10} = 'LL_R0R1';         IVs(10) = 0;
Vars{11} = 'LL_R1R1';        IVs(11) = 0;
Vars{12} = 'LL_R0R1_Syk';      IVs(12) = 0;
Vars{13} = 'LL_R1R1_Syk';     IVs(13) = 0;
Vars{14} = 'LL_R1R1_SykSyk';  IVs(14) = 0;

% Formal variable names displayed when used to plot graphs. If you would
% like to change any, do so here

Plot_Vars = Create_plot_vars(Vars);

% Define the K values
K(1, :) = [0.1, 0.1];
K(2, :) = [0.1, 0.1];
K(3, :) = [0.1, 0.1];
K(4, :) = [0.1, 0.1];
K(5, :) = [0.1, 0.1];

% Define the reactions i.e. {[1, 2],  6,  [1, 2]} means variables 1 and 2
% react to make variable 6 with rate constant K(1) and the reverse reaction 
% happens with rate constant K(2). If no reverse reaction occurs, set the
% second k value number to zero.

eqns = cell(1, 22);

%             in                      out              k value numbers
eqns{1} =  {["LL", "R0"],            "LL_R0",          1};
eqns{2} =  { "R0",                   "R1",             2};
eqns{3} =  {["R1", "Syk"],           "R1_Syk",         4};
eqns{4} =  {["LL", "R1"],            "LL_R1",          4};
eqns{5} =  {["LL", "R1_Syk"],        "LL_R1_Syk",      5};
eqns{6} =  {["R0", "LL_R0"],         "LL_R0R0",        1};
eqns{7} =  {["R1", "LL_R0"],         "LL_R0R1",        3};
eqns{8} =  {["R1_Syk", "LL_R0"],     "LL_R0R1_Syk",    5};
eqns{9} =  { "LL_R0",      	         "LL_R1",          2};
eqns{10} = {["R0", "LL_R1"],         "LL_R0R1",        1};
eqns{11} = {["R1", "LL_R1"],         "LL_R1R1",        3};
eqns{12} = {["R1_Syk", "LL_R1"],     "LL_R1R1_Syk",    5};
eqns{13} = {["Syk", "LL_R1"],        "LL_R1_Syk",      4};
eqns{14} = {["R0", "LL_R1_Syk"],     "LL_R0R1_Syk",    1};
eqns{15} = {["R1", "LL_R1_Syk"],     "LL_R1R1_Syk",    3};
eqns{16} = {["R1_Syk", "LL_R1_Syk"], "LL_R1R1_SykSyk", 5};
eqns{17} = { "LL_R0R0",              "LL_R0R1",        2};
eqns{18} = { "LL_R0R1",              "LL_R1R1",        2};
eqns{19} = {["Syk", "LL_R0R1"],      "LL_R0R1_Syk",    4};
eqns{20} = {["Syk", "LL_R1R1"],      "LL_R1R1_Syk",    4};
eqns{21} = { "LL_R0R1_Syk",          "LL_R1R1_Syk",    2};
eqns{22} = {["Syk", "LL_R1R1_Syk"],  "LL_R1R1_SykSyk", 4};

eqns = vars2nums(eqns);


% Reactions which have multiple possibilities
multiples = cell(1, 2);

multiples{1} = zeros(10, 1);
multiples{2} = zeros(10, 1);
      
%                 Eqn No               Mult
multiples{1}(1) = 1;    multiples{2}(1) = 2;
multiples{1}(2) = 4;    multiples{2}(2) = 2;
multiples{1}(3) = 5;    multiples{2}(3) = 2;
multiples{1}(4) = -6;   multiples{2}(4) = 2;
multiples{1}(5) = -11;  multiples{2}(5) = 2;
multiples{1}(6) = -16;  multiples{2}(6) = 2;   
multiples{1}(7) = 17;   multiples{2}(7) = 2;
multiples{1}(8) = -18;  multiples{2}(8) = 2;
multiples{1}(9) = 20;   multiples{2}(9) = 2;
multiples{1}(10) = -22; multiples{2}(10) = 2;   


% Variables which are not used in a reaction, just used as a catalyst
catalysts = cell(1, 2);

% How many catlysts occur?
catalysts{1} = []; % zeros(2, 1);
catalysts{2} = []; % strings(2, 1);

%                 Eqn number            Var
% catalysts{1}(1) = 1; catalysts{2}(1) = "LL";
% catalysts{1}(2) = 4; catalysts{2}(2) = "LL";
% catalysts{1}(3) = 5; catalysts{2}(3) = "LL";

catalysts{2} = vars2nums(catalysts{2});
       

% Variables which we assume to stay constant
constants = vars2nums(1);
     
% Number of variables
n = 14;

end