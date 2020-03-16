function [links, pos] = graph_tree(tree)
    i = 1;
    pos = [0, 0];
    
    if ~isempty(tree.left)
        [links1, j, pos1] = sub_graph(tree.left, i + 1, [-1, -1]);
        links1 = [i, i + 1; links1];
        pos1 = [[-1, -1]; pos1];
    else
        links1 = zeros(0, 2);
        pos1 = [];
        j = i + 1;
    end
    
    if ~isempty(tree.right)
        [links2, ~, pos2] = sub_graph(tree.right, j, [-1, 1]);
        links2 = [i, j; links2];
        pos2 = [[-1, 1]; pos2];
    else
        links2 = zeros(0, 2);
        pos2 = [];
    end
    
    pos = [[0, 0]; pos1; pos2];
    links = [links1; links2];
    
    G = graph(links(:, 1), links(:, 2));
    plot(G);
    p = plot(G);
    p.XData = pos(:, 2);
    p.YData = pos(:, 1);
end