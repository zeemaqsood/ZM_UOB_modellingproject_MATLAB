function L = rand_lay(L, alph, n)
Alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"];
Alphabet = Alphabet(1:n);

k = find(alph == L.nodes, 1);
node = L.pos(:, k);
letters = [];

for j = 1:4
    nodes = Alphabet(~ismember(Alphabet, L.nodes));
    
    if eval(['L.layout.', char(alph), '{j} == ""']) && rand < 0.6
        node1 = node + [mod(j + 1, 2) * (3 - j); mod(j, 2) * (2 - j)];
        i = find(all(node1 == L.pos, 1));
        
        if ~isempty(i)
            L.conns = [L.conns, [i; k]];
            eval(['L.layout.', char(alph), '{j} = "', char(L.nodes(i)), '";']);
            eval(['L.layout.', char(L.nodes(i)), '{mod(j + 1, 4) + 1} = "', char(alph), '";']);
            
        elseif ~isempty(nodes)
            L.pos = [L.pos, node1];
            letter = nodes(ceil(rand*length(nodes)));
            L.nodes = [L.nodes, letter];
            m = find(letter == L.nodes, 1);
            L.conns = [L.conns, [k; m]];
            
            eval(['L.layout.', char(alph), '{j} = "', char(letter), '";']);
            eval(['L.layout.', char(letter), ' = {"", "", "", ""};']);
            eval(['L.layout.', char(letter), '{mod(j + 1, 4) + 1} = "', char(alph), '";']);
            
            letters = [letters, letter];
        end
    end
end

letters = letters(randperm(size(letters, 2)));

for i = 1:size(letters, 2)
    L = rand_lay(L, letters(i), n);
end
end