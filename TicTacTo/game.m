function game(n)

Alphabet = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'};
L = random_layout(n);

G = graph(L.conns(1, :), L.conns(2, :), size(L.conns, 2), Alphabet(1:n + 1));

dist = distances(subgraph(G, 1:n), find(L.nodes == "a"));
fin = sortrows(transpose([dist;1:n]), 'descend');
finalnode = char(L.nodes(fin(1, 2)));
m = find(L.nodes == "a", 1);

locked = findedge(G, fin(1, 2), 1:n);
checked = zeros(0, 2);

vec = 1:n;
vec(ismember(vec, [m, fin(1, 2), n + 1])) = [];
key = vec(ceil(rand * (n - 2)));
havekey = false;
map = vec(ceil(rand * (n - 2)));
havemap = false;
HP = 100;
Shield = false;
Sword = false;

% disp(['You are looking for node ', finalnode]);

currstate = 'a';
compass = {'North', 'East', 'South', 'West'};

conns = unique(L.conns(:, any(L.conns == m, 1)));
conns = conns(conns ~= n + 1);
SG = subgraph(G, conns);

p = plot(SG, 'NodeLabel', {});
p.XData = L.pos(1, conns);
p.YData = L.pos(2, conns);

p.Parent.XLim = [min(L.pos(1, conns)) - 1, max(max(L.pos(1, conns))) + 1];
p.Parent.YLim = [min(L.pos(2, conns)) - 1, max(max(L.pos(2, conns))) + 1];

hold on;
plot(L.pos(1, m), L.pos(2, m), 'marker', '.', 'MarkerEdgeColor', 'r', 'MarkerSize', 25);
g = plot(1, 1, 'b');
lgd = legend(g, "Doors");
lgd.Title.String = ["No Key", "No Map", strcat("HP - ", num2str(HP)), "No Shield", "No Sword"];
hold off;

for i = 1:4
    text(L.pos(1, m) - 0.5 * mod(i - 1, 2) * (i - 3), L.pos(2, m) - 0.5 * mod(i, 2) * (i - 2), [compass{i}, ' (', num2str(i), ')'], 'HorizontalAlignment', 'center')
end
see = m;
seen = m;

while currstate ~= finalnode && HP ~= 0
    b = eval(['L.layout.', currstate]);
    
    if ismember(n + 1, see)
        vec = find(~ismember([b{:}], ""));
    else
        vec = find(~ismember([b{:}], ["", Alphabet{n + 1}]));
    end
    
    say = ['You are at ', currstate(end), '. Which way would you like to go: '];
    say2 = '(';
    
    for i = 1:length(vec)
        if i == length(vec)
            say = [say, compass{vec(i)}, ' ', say2, num2str(vec(i)), '): '];
        elseif i == length(vec) - 1
            say = [say, compass{vec(i)}, ' or '];
            say2 = [say2, num2str(vec(i)), ' or '];
            
        else
            say = [say, compass{vec(i)}, ', '];
            say2 = [say2, num2str(vec(i)), ', '];
        end
    end
    
    t = true;
    while t
        direc = input(say);
        
        if direc <= 4 && direc > 0
            newstate = char(b{direc});
            if isempty(newstate)
                disp("There is no door here");
                HP = max(0, HP - 100);
                lgd.Title.String{3} = ['HP - ', num2str(HP)];
                if HP == 0
                    break;
                end
                
            else
                newm = find(newstate(end) == L.nodes, 1);
                if ismember(findedge(G, newm, m), locked)
                    newm = find(newstate(end) == L.nodes, 1);
                    checked = [checked; m, newm];
                    disp("There is a locked door");
                    if havekey
                        disp("You have the key and have unlocked the door!");
                        t = false;
                    else
                        disp("You do not have the key, so you must find the key first");
                        highlight(p, checked(:, 1), checked(:, 2), 'EdgeColor', 'r');
                    end
                else
                    newm = find(newstate(end) == L.nodes, 1);
                    t = false;
                end
            end
        end
    end
    
    if HP == 0
        break
    end
    
    currstate = newstate;
    m = newm;
    
    if ismember(m, key)
        disp("You have found the key!");
        havekey = true;
        key(key == m) = [];
    end
    
    if ismember(m, map)
        t = input('You have found the map! Would you like to buy it for 10 HP? (1 or 0): ');
        if t
            havemap = true;
            map(map == m) = [];
            see = 1:n + 1;
            HP = HP - 10;
        end
    end
    
    if currstate == Alphabet{n + 1} && ~ismember(m, seen)
        t = input('You found the secret room!. Would you like max HP(1), a Shield(2) or a Sword(3): ');
        if t == 1
            HP = 100;
            lgd.Title.String{3} = 100;
        elseif t == 2
            Shield = true;
            lgd.Title.String{4} = "Have Shield";
        else
            Sword = true;
            lgd.Title.String{5} = "Have Sword";
        end
    end
    
    see = unique([see, m]);
    seen = unique([seen, m]);
    conns = unique(L.conns(:, any(ismember(L.conns, see), 1)), 'sorted');
    
    if ~ismember(n + 1, see)
        conns = conns(conns ~= n + 1);
        vec = find(any(ismember(L.conns, see), 1) .* ~any(L.conns == n + 1, 1));
    else
        vec = find(any(ismember(L.conns, see), 1));
    end
    
    SG = subgraph(graph(L.conns(1, vec), L.conns(2, vec)), conns);
    
    p = plot(SG, 'NodeLabel', {});
    highlight(p, find(checked(:, 1) == vec), find(checked(:, 2) == vec), 'EdgeColor', 'r');
    p.XData = L.pos(1, conns);
    p.YData = L.pos(2, conns);
    
    p.Parent.XLim = [min(L.pos(1, conns)) - 1, max(max(L.pos(1, conns))) + 1];
    p.Parent.YLim = [min(L.pos(2, conns)) - 1, max(max(L.pos(2, conns))) + 1];
    
    if ismember(n + 1, see)
        [a, b] = findedge(SG);
        highlight(p, a(any([a, b] == length(conns), 2)), b(any([a, b] == length(conns), 2)), 'LineStyle', '--');
    end
    
    hold on;
    plot(L.pos(1, seen), L.pos(2, seen), '.', 'MarkerEdgeColor', 'g', 'MarkerSize', 25);
    plot(L.pos(1, m), L.pos(2, m), '.', 'MarkerEdgeColor', 'r', 'MarkerSize', 25);
    g = plot(1, 1, 'b');
    lgd = legend(g, "Doors");
    
    if currstate ~= finalnode
        HP = max(HP - 5, 0);
    end
    
    lgd.Title.String = ["No Key", "No Map", strcat("HP - ", num2str(HP)), "No Shield", "No Sword"];
    
    if havekey
        lgd.Title.String{1} = "Have Key";
    end
    
    if havemap
        lgd.Title.String{2} = "Have Map";
    end
    
    if Shield
        lgd.Title.String{4} = "Have Shield";
    end
    
    if Sword
        lgd.Title.String{5} = "Have Sword";
    end
    hold off;
    
    for i = 1:4
        text(L.pos(1, m) - 0.5 * mod(i - 1, 2) * (i - 3), L.pos(2, m) - 0.5 * mod(i, 2) * (i - 2), [compass{i}, ' (', num2str(i), ')'], 'HorizontalAlignment', 'center')
    end
end

if HP == 0
    disp("GAME OVER, you ran out of HP");
    
else
    disp("Congratulations, you made it to the end!");
end

end