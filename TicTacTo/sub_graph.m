function [links, k, pos] = sub_graph(tree, i, pos)
links1 = [];
links2 = [];
n = abs(pos(1));

if ~isempty(tree.left)
    [links1, j, pos1] = sub_graph(tree.left, i + 1, [pos(1) - 1, pos(2) - (1/2)^n]);
    links1 = [i, i + 1; links1];
    pos1 = [[pos(1) - 1, pos(2) - (1/2)^n]; pos1];
    
else
    links1 = zeros(0, 2);
    j = i + 1;
    pos1 = [];
end

if ~isempty(tree.right)
    [links2, k, pos2] = sub_graph(tree.right, j, [pos(1) - 1, pos(2) + (1/2)^n]);
    links2 = [i, j; links2];
    pos2 = [[pos(1) - 1, pos(2) + (1/2)^n]; pos2];
    
else
    links2 = zeros(0, 2);
    pos2 = [];
    k = j;
end

links = [links1; links2];
pos = [pos1; pos2];
end