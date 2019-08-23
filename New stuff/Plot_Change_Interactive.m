function Plot_Change_Interactive

model = input('Which models would you like to run? ');
Type = input('What type of variable would you like to change, IV or K? ', 's');
var = input('Which variable would you like to change? ');
groups = input('Which variables would you like to plot? ');
Points = input('What values would you like the changing variable to have? ');
T = input('For how long would you like to plot the model? ');

Plot_Change(model, Type, var, groups, Points, T)

end
