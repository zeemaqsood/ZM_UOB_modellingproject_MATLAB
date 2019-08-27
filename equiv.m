function size_change = equiv(units, Var_units)

sizes = ["p", "n", "u", "m", "", "K", "M", "G", "T"];

 [~, b] = ismember([units; Var_units], sizes);

size_change = zeros(size(Var_units));

for i = 1:length(Var_units)
    size_change(i) = 10^(3 * (b(i + 1) - b(1)));
end
end