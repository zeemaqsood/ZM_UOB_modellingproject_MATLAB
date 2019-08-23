function endpoints = plot_endpoints(model, Type, Var, Plot, Points)

% plot_endpoints:
%
% This function will plot the a endpoints of Model model, with the 
% variation of the 'Type', where Type is either 'IV' or 'K'
%
% See also: change_IV, change_K, ODEs
%
% Author: Sean Watson  Date: 06/08/2019  Version: v0.1

global Plot_Vars Model_names;

% Check whether we are changing the intial value of the k values, then run
% the code. This will output the endpoints of desired models
if Type == "IV"
    endpoints = change_IV(model, Var, Plot, Points, 1000);
elseif Type == "K"
    endpoints = change_K(model, Var, Plot, Points, 1000);
end

% Plot the concentration endpoints against the changing variable
plot(endpoints(:, 1), endpoints(:, 2:length(Plot) + 1));

% Allow more lines to be plotted
hold on;

% If there are more than 2 plot variables, also plot their sum
if length(Plot) >= 2
    plot(endpoints(:, 1), sum(endpoints(:, 2:length(Plot) + 1), 2));
end

% Label the axis depending on the variable we were changing
if Type == "IV"
    xlabel(Plot_Vars(Var));
else
    xlabel(strcat("K", num2str(Var)));
end

% Label the y axis
ylabel("Final concentration");

% Add the variable names to the legend, and "All" for the sum of them all.
legend([Plot_Vars(Plot); "All"]);
title(Model_names(model));

% Don't allow the graph to be added to
hold off;

end