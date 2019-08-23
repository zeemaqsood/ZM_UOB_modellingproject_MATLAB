function Model1(Plot)

global Vars Plot_Vars IVs K eqns doubles catalysts constants n;

Vars = cell(4, 1);
IVs = zeros(4, 1);
K = zeros(2, 2);

% Variable names and their initial values
Vars{1} = 'LL';     IVs(1) = 1;
Vars{2} = 'R';      IVs(2) = 1;
Vars{3} = 'LL_R';    IVs(3) = 0;
Vars{4} = 'LL_RR';   IVs(4) = 0;

% Formal variable names displayed when used to plot graphs. If you would
% like to change any, do so here

Plot_Vars = Create_plot_vars(Vars);

% Define the K values. If no reverse reaction occurs, set the second value
% to zero
K(1, :) = [0.1, 0.1];
K(2, :) = [0.1, 0.1];

% Define the reactions i.e. {[1, 2],  6,  [1, 2]} means variables 1 and 2
% react to make variable 6 with rate constant K(1) and the reverse reaction 
% happens with rate constant K(2)

%                         in           out     k value numbers
eqns = eqn_vars_2_nums({{["LL", "R"],  "LL_R",  1}, ...
                        {["R", "LL_R"], "LL_RR", 2}});
    
% Reactions which are twice as likely
%                            in          out
doubles = eqn_vars_2_nums({{["LL", "R"], "LL_R"}, ...
                           { "LL_RR",    ["R", "LL_R"]}});
      
% Variables which are not used in a reaction, just used as a catalyst
%                                var    in          out
% catalysts = eqn_vars_2_nums({});      
catalysts = eqn_vars_2_nums({{"LL", ["LL", "R"], "LL_R"}});
      
% Variables which we assume to stay constant
constants = eqn_vars_2_nums([]);
    
% Number of variables
n = 4;

if ~exist('Plot', 'var')
    % Create the graph of the variables to visualize the reactions
    Graphs;
elseif ismember(Plot, ['y', 'yes', 'Y', 'Yes'])
    % Create the graph of the variables to visualize the reactions
    Graphs;    
end

end