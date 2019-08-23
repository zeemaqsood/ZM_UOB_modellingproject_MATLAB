function Graphs

global Vars doubles catalysts constants n IVs K;

% Create a matrix of all connections, with the entry being the k number
links = create_links;

m = size(links, 1);

% Create a list of all colours
colours = ['r', 'b', 'g', 'c', 'm', 'y', 'k', 'w'];

G = digraph(links);

EdgeLabels = cell(size(G.Edges.Weight, 1), 1);
for i = 1:size(G.Edges.Weight, 1)
    EdgeLabels{i} = strcat('k', num2str(floor(G.Edges.Weight(i))));
end

p = plot(G,'EdgeLabel', EdgeLabels, 'ArrowSize', 12, 'Layout', 'layered', 'NodeLabel', {});

new_Vars = Create_plot_vars(Vars);

vars = [new_Vars; cell(m - n, 1)];

for i = n + 1:m
    vars{i} = '';
end

% labelnode(p, 1:m, vars);
text(p.XData, p.YData, vars, 'FontSize', 10, 'FontWeight', 'Bold');

highlight(p, n + 1:m, 'Marker', 'none');

for i = 1:size(G.Edges.EndNodes, 1)
	a = G.Edges.EndNodes(i, :);
    highlight(p, a, 'EdgeColor', colours(abs(floor(G.Edges.Weight(i)))));
end

if ~isempty(doubles)
    Doubles = zeros(n * size(doubles, 2), 2);
    h = 1;
    
    for i = 1:m
        for j = 1:m
            if floor(links(i, j) - 0.25) == links(i, j) - 0.25
                Doubles(h, :) = [i, j];
                
                h = h + 1;
            end
        end
    end
    
    Doubles = Doubles(1:h - 1, :);
    highlight(p, Doubles(:, 1), Doubles(:, 2), 'LineWidth', 2);
end


% No reverse catalyst
if ~isempty(catalysts)
    Catalysts = zeros(n * size(catalysts, 2), 2);
    h = 1;
    
    for i = 1:m
        for j = 1:m
            if floor(links(i, j) - 0.5) == links(i, j) - 0.5
                Catalysts(h, :) = [i, j];
                
                h = h + 1;
            end
        end
    end
    
    Catalysts = Catalysts(1:h - 1, :);
    highlight(p, Catalysts(:, 1), Catalysts(:, 2), 'LineStyle', '--');
end

highlight(p, constants, 'NodeColor', 'r');


IV = table(Vars, IVs);
disp(IV);

k_num = strcat("k", num2str(transpose(1:size(K, 1))));
Forw = K(:, 1);
Rev = K(:, 2);
Ks = table(k_num, Forw, Rev);
disp(Ks);

% Eqns = write_eqns;
% Eqns = table(Eqns);
% disp(Eqns);


end