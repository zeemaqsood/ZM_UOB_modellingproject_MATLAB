function Model6

global Model_names Vars Plot_Vars IVs K eqns multiples constants catalysts n;

Model_names(6) = "6";

n = 2;

Vars = cell(n, 1);
IVs = zeros(n, 1);
K = zeros(1, 2);

% Variable names and their initial values
Vars{1} = 'L';              IVs(1) = 1;
Vars{2} = 'LL';            IVs(2) = 0;

% Formal variable names displayed when used to plot graphs. If you would
% like to change any, do so here

Plot_Vars = Create_plot_vars(Vars);

% Define the K values
K(1, :) = [0.1, 0.1];

% Define the reactions i.e. {[1, 2],  6,  [1, 2]} means variables 1 and 2
% react to make variable 6 with rate constant K(1) and the reverse reaction 
% happens with rate constant K(2). If no reverse reaction occurs, set the
% second k value number to zero.

eqns = cell(1, 1);

%                         in                 out           k value numbers
eqns{1} = {["L", "L"], "LL", 1};

eqns = vars2nums(eqns);

% Reactions which are twice as likely
%                            in           out
doubles = vars2nums([]);
    

% Reactions which have multiple possibilities
multiples = cell(1, 2);

multiples{1} = zeros(1, 1);
multiples{2} = zeros(1, 1);
      
%                 Eqn No               Mult
multiples{1}(1) = 1;   multiples{2}(1) = 3;

       
% Variables which are not used in a reaction, just used as a catalyst
%                             var    in              out
    
catalysts = cell(1, 2);

catalysts{1} = zeros(2, 1);
catalysts{2} = strings(2, 1);

catalysts{1}(1) = 1; catalysts{2}(1) = "L";
catalysts{1}(2) = 1; catalysts{2}(2) = "L";

catalysts{2} = vars2nums(catalysts{2});

% Variables which we assume to stay constant
constants = vars2nums([]);
     
% Number of variables

end