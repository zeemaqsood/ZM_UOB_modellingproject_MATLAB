function position = Racing(n, m, laps, varargin)

i = 1;

while i <= length(varargin)
    if varargin{i} == "Tyre"
        STyre = varargin{i + 1};
        i = i + 2;
    end
end

Tyre = zeros(m, 1);

r = rand(m, 1);
Tyre(:) = 3;
Tyre(3 * r <= 2) = 2;
Tyre(3 * r <= 1) = 1;

if exist('STyre', 'var')
    Tyre(1) = STyre;
end

Wear = ones(m, 1);
Wear(Tyre == 2) = 0.9;
Wear(Tyre == 3) = 0.8;


Test = [transpose(m:-1:1), 2 * ones(m, 1), transpose(1:m), 0.25 * (3 + rand(m, 1)), zeros(m, 1), Wear, Tyre];

stats = [transpose(1:m), zeros(m, 10000)];
Position = [transpose(1:m), zeros(m, 10000)];

lap = 0;
i = 1;
while lap < laps
    new_Test = Test;
    dist = 5 * ones(m, 1);
    r = rand(m, 1);
    dist(Test(:, 6) .* Test(:, 4) > r) = 6;
    dist(Test(:, 6) .* Test(:, 4) < 0.5 * r) = 4;
    
    for j = 1:size(Test, 1)
        [l, v] = ismember([mod((Test(j, 1) + transpose(1:dist(j))), n), Test(j, 2) * ones(dist(j), 1)], [mod(Test(:, 1), n), Test(:, 2)], 'rows');
        
        v = v(l);
        
        if 4 * Test(j, 6) < rand && Test(j, 1) + dist(j) > n
            new_Test(j, 2) = 4;
            new_Test(j, 1) = n + 2;
            
            
        elseif new_Test(j, 2) == 4
            if Test(j, 1) == 40
                r = rand;
                if r * 3 <= 1
                    new_Test(j, 7) = 1;
                    new_Test(j, 6) = 1;
                    
                elseif r * 3 <= 2
                    new_Test(j, 7) = 2;
                    new_Test(j, 6) = 0.9;
                    
                else
                    new_Test(j, 7) = 3;
                    new_Test(j, 6) = 0.8;
                end
                
                k = 0;
                
                while k >= 0
                    f = new_Test(new_Test(:, 1) == Test(j, 1) + dist(j) - k, 2);
                    
                    if length(f) == 3
                        k = k + 1;
                        
                    else
                        new_Test(j, 1) = Test(j, 1) + dist(j) - k;
                        
                        k = -1;
                        if ~ismember(2, f)
                            new_Test(j, 2) = 2;
                            
                        elseif ~ismember(3, f)
                            new_Test(j, 2) = 3;
                            
                        else
                            new_Test(j, 2) = 1;
                        end
                    end
                end
            else
                new_Test(j, 1) = Test(j, 1) + 2;
            end
            
            
        elseif l(1) && dist(j) > dist(v(1))
            
            if Test(j, 2) ~= 1 && ~ismember([Test(j, 1), Test(j, 2) - 1], [Test(:, 1), Test(:, 2)], 'rows')
                new_Test(j, 2) = Test(j, 2) - 1;
                
            elseif Test(j, 2) ~= 3 && ~ismember([Test(j, 1), Test(j, 2) + 1], [Test(:, 1), Test(:, 2)], 'rows')
                new_Test(j, 2) = Test(j, 2) + 1;
                
            else
                new_Test(j, 2) = Test(j, 2);
            end
            
            if Test(j, 1) + dist(j) > n
                new_Test(j, 1) = Test(j, 1) + dist(j);
            else
                
                new_Test(j, 1) = min([new_Test(new_Test(1:j - 1, 2) == new_Test(j, 2)) - 1; Test(j, 1) + dist(j)]);
            end
            
        elseif any(l) && dist(j) > dist(v(1))
            if Test(j, 1) + dist(j) > n
                new_Test(j, 1) = Test(j, 1) + dist(j);
            else
                
                new_Test(j, 1) = min(new_Test(v, 1)) - 1;
            end
            
            new_Test(j, 2) = Test(j, 2);
            
        elseif any(ismember([(Test(j, 1) + transpose(1:dist(j))), Test(j, 2) * ones(dist(j), 1)], [new_Test(:, 1), new_Test(:, 2)], 'rows'))
            [~, v] = ismember([(Test(j, 1) + transpose(1:dist(j))), Test(j, 2) * ones(dist(j), 1)], [new_Test(:, 1), new_Test(:, 2)], 'rows');
            
            new_Test(j, 1) = min(new_Test(nonzeros(v), 1)) - 1;
            new_Test(j, 2) = Test(j, 2);
            
        elseif Test(j, 2) ~= 2 && ~any(ismember([Test(j, 1) + transpose(0:dist(j)), 2 * ones(dist(j) + 1, 1)], [new_Test(:, 1), new_Test(:, 2)], 'rows'))
            new_Test(j, 1) = Test(j, 1) + dist(j);
            new_Test(j, 2) = 2;
            
        else
            new_Test(j, 1) = Test(j, 1) + dist(j);
            new_Test(j, 2) = Test(j, 2);
        end
    end
    
    f = find(new_Test(:, 1) > n);
    
    for j = 1:length(f)
        if new_Test(f(j), 2) == 4
            new_Test(f(j), 1) = 2;
        else
            
            g = n;
            row = new_Test(f(j), 2);
            g = min(new_Test(new_Test(:, 2) == new_Test(f(j), 2)) - 1);
            
            new_Test(f(j), 1) = min(mod(new_Test(f(j), 1), n), g);
        end
        
        if new_Test(f(j), 1) < Test(f(j), 1)
            new_Test(f(j), 5) = Test(f(j), 5) + 1;
            lap = max(lap, new_Test(f(j), 5));
        end
        
        if Test(j, 7) == 3
            new_Test(j, 6) = Test(j, 6) * 0.95;
            
        elseif Test(j, 7) == 2
            new_Test(j, 6) = Test(j, 6) * 0.93;
            
        else
            new_Test(j, 6) = Test(j, 6) * 0.91;
        end
    end
    
    Test = sortrows(new_Test, 'descend');
    %     Draw(Test, n)
    
    dum = Test(:, [1, 2, 3, 5]);
    dum(:, 5) = dum(:, 1) + n * dum(:, 4);
    dum = [sortrows(dum, 5, 'descend'), transpose(1:m)];
    dum = sortrows(dum, 3);
    
    stats(:, 1 + i) = dum(:, 5);
    Position(:, i + 1) = dum(:, 6);
    
    i = i + 1;
end

for j = 1:m
    plot(1:i - 1, stats(j, 2:i))
    hold on;
end

for j = 0:n:max(max(stats))
    plot(1:i - 1, j * ones(1, i - 1), 'LineStyle', '--');
end

legend(string(1:m))
hold off;

position = Position(1, end);
end
