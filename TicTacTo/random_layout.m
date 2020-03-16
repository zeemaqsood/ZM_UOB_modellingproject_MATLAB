function L = random_layout(n)
    Alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"];
    
    A = struct();
    A.a = {"", "", "", ""};
    
    L = struct();
    L.nodes = {};
    
    while length(L.nodes) < n
        A = struct();
        letter = Alphabet(ceil(rand * n));
        eval(['A.', char(letter), ' = {"", "", "", ""};']);
        
        L = struct();
        L.layout = A;
        
        L.nodes = letter;
        L.pos = [0; 0];
        L.conns = zeros(2, 0);
        L = rand_lay(L, letter, n);
    end
    
    G = graph(L.conns(1, :), L.conns(2, :));
    dist = distances(subgraph(G, 1:n), find(L.nodes == "a"));
    fin = sortrows(transpose([dist;1:n]), 'descend');
    
    L.nodes = [L.nodes, Alphabet(n + 1)];
    
    i = 0;
    j = 5;
    f = randperm(n);
    f = f(f ~= fin(1, 2));
    
    while i < n - 1 && j == 5
        i = i + 1;
        eval(['a = L.layout.', char(L.nodes(f(i))), ';']);
        
        v = randperm(4);
        
        j = 1;
        while j <= 4
            if a{v(j)} == ""
                secret_node_pos = L.pos(:, f(i)) + [mod(v(j) + 1, 2) * (3 - v(j)); mod(v(j), 2) * (2 - v(j))];
                L.pos = [L.pos, secret_node_pos];
                j = 6;
            else
                j = j + 1;
            end
        end
    end
     
    
    eval(['L.layout.', char(Alphabet(n + 1)), ' = {"", "", "", ""};']);
    for j = 1:4
        vec = all(L.pos(:, n + 1) + [mod(j + 1, 2) .* (3 - j); mod(j, 2) .* (2 - j)] == L.pos, 1);
        
        if any(vec, 2)
            L.conns = [L.conns, [find(vec, 1); n + 1]];
            
            eval(['L.layout.', char(L.nodes(find(vec, 1))), '{mod(j + 1, 4) + 1} = "', char(Alphabet(n + 1)), '";']);
            eval(['L.layout.', char(Alphabet(n + 1)), '{j} = "', char(L.nodes(find(vec, 1))), '";']);
        end
    end
    
    dist = distances(subgraph(G, 1:n), find(L.nodes == "a"));

    G = graph(L.conns(1, :), L.conns(2, :));
    p = plot(G);
    p.XData = L.pos(1, :);
    p.YData = L.pos(2, :);
    
    highlight(p, n + 1, L.conns(1, any(L.conns == n + 1, 1)), 'LineStyle', '--');
end