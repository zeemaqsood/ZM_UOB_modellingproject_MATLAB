function Plot_interactive

model = input('Which models would you like to run? ');
plot = input('Which variables would you like to plot? ');
T = input('For how long would you like to plot the model? ');
s = input('How would you like to plot the outcome? As a Proportion, as a Count or just as the Concentration? ', 's');

if s == "Count"
    Style = 2;
    Count = input('What variable would you like to count? ');
    Plot(model, plot, "T", T, s, Count)
elseif s == "Proportion"
    Plot(model, plot, "T", T, s)
else
    Plot(model, plot, "T", T)
end

end
