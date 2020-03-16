function tree = make_tree(varargin)

tree = struct();

if isempty(varargin)
    n = 0;
else
    n = varargin{1};
end

if rand < 0.99 ^ n
    tree.right = make_tree(n + 1);
else
    tree.right = [];
end

if rand < 0.99 ^ n
    tree.left = make_tree(n + 1);
else
    tree.left = [];
end
end