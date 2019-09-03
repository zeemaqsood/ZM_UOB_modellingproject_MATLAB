function vals = equiv(vals, Var_units, units, powers)

sizes = ["y", "z", "a", "f", "p", "n", "u", "m", "", "K", "M", "G", "T", "P", "E", "Z", "Y"];

if ~exist('powers', 'var')
    powers = ones(size(Var_units));
end

[~, a] = ismember(units, sizes);
[~, b] = ismember(Var_units, sizes);

vals = vals .* 10 .^ (3 .* (powers .* (b - a)));

end