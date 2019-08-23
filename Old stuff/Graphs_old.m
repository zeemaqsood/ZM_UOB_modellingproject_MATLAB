function links = Graphs

global Vars eqns doubles catalysts constants n IVs K;

% Create a matrix of all connections, with the entry being the k number
links = create_links(eqns, catalysts, n);

% Create a list of all colours
colours = ['r', 'b', 'g', 'c', 'm', 'y', 'k', 'w'];

G = digraph(links);

EdgeLabels = cell(size(G.Edges.Weight, 1), 1);
for i = 1:size(G.Edges.Weight, 1)
    EdgeLabels{i} = strcat('k', num2str(G.Edges.Weight(i)));
end

p = plot(G,'EdgeLabel', EdgeLabels, 'ArrowSize', 8);
labelnode(p, 1:n, Vars);

for i = 1:size(G.Edges.EndNodes, 1)
	a = G.Edges.EndNodes(i, :);
    highlight(p, a, 'EdgeColor', colours(abs(G.Edges.Weight(i))));
end

if ~isempty(doubles)
    Doubles = [];
    for i = 1:size(doubles, 2)
        b = doubles{i};
        
        for j = 1:size(b{1}, 2)
            for k = 1:size(b{2}, 2)
                Doubles = [Doubles; [b{1}(j), b{2}(k)]];
            end
        end
    end
    highlight(p, Doubles(:, 1), Doubles(:, 2), 'LineWidth', 2);
end


% No reverse catalyst
if ~isempty(catalysts)
    Catalysts = [];
    for i = 1:size(catalysts, 2)
        b = catalysts{i};

        for j = 1:size(b{2}, 2)
            for k = 1:size(b{3}, 2)
                if ismember(b{2}(j), b{1})
                    Catalysts = [Catalysts; [b{2}(j), b{3}(k)]];
                end
            end
        end
    end
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

Eqns = write_eqns;
Eqns = table(Eqns);
disp(Eqns);


end