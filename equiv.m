function [IVs, units] = equiv(IVs, Var_units)

sizes = ["y", "z", "a", "f", "p", "n", "u", "m", "", "K", "M", "G", "T", "P", "E", "Z", "Y"];

[~, b] = ismember(Var_units, sizes);

b = b - 9;

Log = floor(log10(IVs .* 10 .^ (3 * b))/3);

m = min(Log(Log ~= - Inf));
units = sizes(m + 9);

IVs = IVs .* 10 .^ (3 .* (b - m));

end