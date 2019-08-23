function position = Racing1(n, m, laps, varargin)

S = struct();

S.Name = strings(20, 1);
S.Position = zeros(20, 1);
S.TrackPos = zeros(20, 1);
S.RacingLine = zeros(20, 1);
S.Skill = zeros(20, 1);
S.Lap = zeros(20, 1);
S.Tyre = zeros(20, 1);
S.TyreWear = zeros(20, 1);
S.LapTime = zeros(20, 1);

for i = 1:m     
    name = ['D', num2str(i)];
    S.Name(i) = strcat("D", num2str(i));
    S.Position(i) = i;
    S.TrackPos(i) = 21 - i;
    S.RacingLine(i) = 1;
    S.Skill(i) = 1 - 0.01 * i;
    S.Lap(i) = 0;
    S.Tyre(i) = 1;
    S.TyreWear(i) = 1;
    S.LapTime(i) = 0;
end

order = transpose(1:m);
Sort = [S.TrackPos, S.RacingLine];

ordertemp = sortrows([order, Sort], [2, 3], {'descend', 'descend'});
order = ordertemp(:, 1);

i = 1;

while i <= length(varargin)
    if varargin{i} == "Tyre"
        S.Tyre(1) = varargin{i + 1};
        i = i + 2;
    end
end

stats = [transpose(1:m), zeros(m, 10000)];

lap = 0;
i = 1;

while lap < laps
    new_S = S;
    Dist = 5 * ones(m, 1);
    r = rand(m, 1);
        
    Dist(r > 0.5) = 4;
    Dist(all([r > 0.5, S.Skill .* S.TyreWear > 2 * r - 1], 2)) = 6;
    
    S.Dist = Dist;
    
    for j = 1:m
        [l, v] = ismember([mod(S.TrackPos(order(j)) + transpose(1:S.Dist(order(j))), n), S.RacingLine(order(j)) * ones(S.Dist(order(j)), 1)], [mod(S.TrackPos(order), n), S.RacingLine(order)], 'rows');
        
        v = v(l);
        
        % Should the car pit
        if S.TrackPos(order(j)) + S.Dist(order(j)) > n && 4 * S.TyreWear(order(j)) < rand
            new_S.RacingLine(order(j)) = 3;
            new_S.TrackPos(order(j)) = n + 1;
            
        % If the car is in the pitlane
        elseif S.RacingLine(order(j)) == 3
            if S.TrackPos(order(j)) == 40
                r = rand;
                
                if r * 3 <= 1
                    new_S.Tyre(order(j)) = 1;
                    new_S.TyreWear(order(j)) = 1;
                    
                elseif r * 3 <= 2
                    new_S.Tyre(order(j)) = 2;
                    new_S.TyreWear(order(j)) = 0.9;
                    
                else
                    new_S.Tyre(order(j)) = 3;
                    new_S.TyreWear(order(j)) = 0.8;
                end
                
                k = 0;
                
                while k >= 0
                    f = S.RacingLine(S.TrackPos == S.TrackPos(order(j)) + S.Dist(order(j)) - k);
                    
                    if length(f) == 2
                        k = k + 1;
                        
                    else
                        new_S.TrackPos(order(j)) = S.TrackPos(order(j)) + S.Dist(order(j)) - k;
                        k = -1;
                        
                        if ~ismember(1, f)
                            new_S.RacingLine = 1;
                            
                        else
                            new_S.RacingLine = 2;
                        end
                    end
                end
                
            else
                new_S.TrackPos = S.TrackPos(order(j), 1) + 1;
            end
            
        % If there is a car right in front and the car is going quicker than the one in front    
        elseif l(1) && S.Dist(order(j)) > S.Dist(v(1))
            
            if S.RacingLine(order(j)) == 1 && ~ismember([S.TrackPos(order(j)), 1], [S.TrackPos, S.RacingLine], 'rows')
                new_S.RacingLine(order(j)) = 2;
                
            else
                new_S.RacingLine(order(j)) = S.RacingLine(order(j));
            end
            
            if Test(j, 1) + S.Dist(j) > n
                new_S.TrackPos(j) = S.TrackPos(j) + S.Dist(j);
                
            else
                new_S.TrackPos(j) = min([new_S.TrackPos(new_S.RacingLine(1:j - 1) == new_S.RacingLine(j)) - 1; Test(j, 1) + S.Dist(j)]);
            end
            
        % Are any cars in front close which the car is going quicker than?
        elseif any(l) && S.Dist(order(j)) > S.Dist(v(1))
            if S.TrackPos(j) + S.Dist(j) > n
                new_S.TrackPos(j) = S.TrackPos(j) + S.Dist(j);
                
            else
                new_S.TrackPos(j) = min(min(new_S.TrackPos(v)) - 1, S.TrackPos(j) + S.Dist(j));
            end
            
            new_S.RacingLine(j) = S.RacingLine(j);
 
        % Are any cars in front close?
        elseif any(ismember([(Test(j, 1) + transpose(1:S.Dist(j))), Test(j, 2) * ones(S.Dist(j), 1)], [new_Test(:, 1), new_Test(:, 2)], 'rows'))
            [~, v] = ismember([(Test(j, 1) + transpose(1:S.Dist(j))), Test(j, 2) * ones(S.Dist(j), 1)], [new_Test(:, 1), new_Test(:, 2)], 'rows');
            
            new_Test(j, 1) = min(min(new_Test(nonzeros(v), 1)) - 1, Test(j, 1) + S.Dist(j));
            new_Test(j, 2) = Test(j, 2);
            
        % Is the car not  on the racing line and are there any cars on the racing line?
        elseif Test(j, 2) ~= 1 && ~any(ismember([Test(j, 1) + transpose(0:S.Dist(j)), ones(S.Dist(j) + 1, 1)], [new_Test(:, 1), new_Test(:, 2)], 'rows'))
            new_Test(j, 1) = Test(j, 1) + S.Dist(j);
            new_Test(j, 2) = 1;
            
        else
            new_Test(j, 1) = Test(j, 1) + S.Dist(j);
            new_Test(j, 2) = Test(j, 2);
        end
    end
    
    new_Test(:, 8) = Test(:, 8) + 1;
    
    f = find(new_Test(:, 1) > n);
    
    for j = 1:length(f)
        Laptimes(Test(f(j), 3), Test(f(j), 5) + 2) = new_Test(f(j), 8) + 1 - ((new_Test(f(j), 1) - n)/S.Dist(f(j)));
        new_Test(f(j), 8) = (new_Test(f(j), 1) - n)/S.Dist(f(j));
        
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
        
%         if Test(j, 7) == 3
%             new_Test(j, 6) = Test(j, 6) * 0.95;
%             
%         elseif Test(j, 7) == 2
%             new_Test(j, 6) = Test(j, 6) * 0.93;
%             
%         else
%             new_Test(j, 6) = Test(j, 6) * 0.91;
%         end
        
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

position = Position(1:m, 1:i - 1);
end
