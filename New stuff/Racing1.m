function position = Racing1(n, m, laps, varargin)

S = struct();

S.Name = strings(m, 1);
S.Position = zeros(m, 1);
S.TrackPos = zeros(m, 1);
S.RacingLine = zeros(m, 1);
S.Skill = zeros(m, 1);
S.Lap = zeros(m, 1);
S.Tyre = zeros(m, 1);
S.TyreWear = zeros(m, 1);
S.LapTime = zeros(m, 1);

for i = 1:m
    name = ['D', num2str(i)];
    S.Name(i) = strcat("D", num2str(i));
    S.Position(i) = i;
    S.TrackPos(i) = m + 1 - i;
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
LapTimes = [transpose(1:m), zeros(m, laps)];

lap = 0;
i = 1;
new_S = S;

while lap < laps
    Dist = 5 * ones(m, 1);
    r = rand(m, 1);
    
    Dist(r > 0.5) = 4;
    Dist(all([r > 0.5, S.Skill .* S.TyreWear > 2 * r - 1], 2)) = 6;
    
    S.Dist = Dist;
    
    for j = 1:m
        car = order(j);
        
        [l, v] = ismember([mod(S.TrackPos(car) + transpose(1:S.Dist(car)), n), S.RacingLine(car) * ones(S.Dist(car), 1)], [mod(S.TrackPos, n), S.RacingLine], 'rows');
        
        v = v(l);
        
        % Should the car pit
        if S.TrackPos(car) + S.Dist(car) > n && 4 * S.TyreWear(car) < rand
            new_S.RacingLine(car) = 3;
            new_S.TrackPos(car) = n + 1;
            
        % If the car is in the pitlane
        elseif S.RacingLine(car) == 3
            if S.TrackPos(car) == 40
                r = rand;
                
                if r * 3 <= 1
                    new_S.Tyre(car) = 1;
                    new_S.TyreWear(car) = 1;
                    
                elseif r * 3 <= 2
                    new_S.Tyre(car) = 2;
                    new_S.TyreWear(car) = 0.9;
                    
                else
                    new_S.Tyre(car) = 3;
                    new_S.TyreWear(car) = 0.8;
                end
                
                k = 0;
                
                while k >= 0
                    f = S.RacingLine(S.TrackPos == S.TrackPos(car) + S.Dist(car) - k);
                    
                    if length(f) == 2
                        k = k + 1;
                        
                    else
                        new_S.TrackPos(car) = S.TrackPos(car) + S.Dist(car) - k;
                        k = -1;
                        
                        if ~ismember(1, f)
                            new_S.RacingLine(car) = 1;
                            
                        else
                            new_S.RacingLine(car) = 2;
                        end
                    end
                end
                
            else
                new_S.TrackPos(car) = S.TrackPos(car) + 1;
            end
            
        % If there is a car right in front and the car is going quicker than the one in front
        elseif l(1) && S.Dist(car) > S.Dist(v(1))
            
            if S.RacingLine(car) == 1 && ~ismember([S.TrackPos(car), 2], [S.TrackPos, S.RacingLine], 'rows')
                new_S.RacingLine(car) = 2;
                
            else
                new_S.RacingLine(car) = S.RacingLine(car);
            end
            
            if S.TrackPos(car) + S.Dist(car) > n
                new_S.TrackPos(car) = S.TrackPos(car) + S.Dist(car);
                
            else
                new_S.TrackPos(car) = min([new_S.TrackPos(order(new_S.RacingLine(order(1:j - 1)) == new_S.RacingLine(car))) - 1; S.TrackPos(car) + S.Dist(car)]);
            end
            
        % Are any cars in front close which the car is going quicker than?
        elseif any(l) && S.Dist(car) > S.Dist(v(1))
            if S.TrackPos(car) + S.Dist(car) > n
                new_S.TrackPos(car) = S.TrackPos(car) + S.Dist(car);
                
            else
                new_S.TrackPos(car) = min(min(new_S.TrackPos(v)) - 1, S.TrackPos(car) + S.Dist(car));
            end
            
            new_S.RacingLine(car) = S.RacingLine(car);
            
        % Are any cars in front close?
        elseif any(ismember([(S.TrackPos(car) + transpose(1:S.Dist(car))), S.RacingLine(car) * ones(S.Dist(car), 1)], [new_S.TrackPos, new_S.RacingLine], 'rows'))
            [~, v] = ismember([(S.TrackPos(car) + transpose(1:S.Dist(car))), S.RacingLine(car) * ones(S.Dist(car), 1)], [new_S.TrackPos, new_S.RacingLine], 'rows');
            
            new_S.TrackPos(car) = min(min(new_S.TrackPos(nonzeros(v))) - 1, S.TrackPos(car) + S.Dist(car));
            new_S.RacingLine(car) = S.RacingLine(car);
            
            % Is the car not on the racing line and are there any cars on the racing line?
        elseif S.RacingLine(car) ~= 1 && ~any(ismember([S.TrackPos(car) + transpose(0:S.Dist(car)), ones(S.Dist(car) + 1, 1)], [new_S.TrackPos, new_S.RacingLine], 'rows'))
            new_S.TrackPos(car) = S.TrackPos(car) + S.Dist(car);
            new_S.RacingLine(car) = 1;
            
        else
            new_S.TrackPos(car) = S.TrackPos(car) + S.Dist(car);
            new_S.RacingLine(car) = S.RacingLine(car);
        end
    end
    
    new_S.LapTime = S.LapTime + 1;
    
    f = find(new_S.TrackPos > n);
    
    [b1, b2] = ismember(order, f);
    
    b2 = b2(b1);
    
    for j = 1:length(b2)
        car = f(b2(j));
        
        LapTimes(car, S.Lap(car) + 2) = new_S.LapTime(car) + (1 - ((new_S.TrackPos(car) - n)/S.Dist(car)));
        new_S.LapTime(car) = (new_S.TrackPos(car) - n)/S.Dist(car);
        
        new_S.TrackPos(car) = mod(new_S.TrackPos(car), n);
        
        if new_S.RacingLine(car) ~= 3
            g = mod(new_S.TrackPos(car), n);
            g = min(g, min(new_S.TrackPos(new_S.RacingLine == new_S.RacingLine(car))));
            new_S.TrackPos(car) = g;
        end
        
        new_S.Lap(car) = S.Lap(car) + 1;
        lap = max(lap, new_S.Lap(car));
        
        if S.Tyre(car) == 3
            new_S.TyreWear(car) = S.TyreWear(car) * 0.95;
            
        elseif S.Tyre(car) == 2
            new_S.TyreWear(car) = S.TyreWear(car) * 0.93;
            
        else
            new_S.TyreWear(car) = S.TyreWear(car) * 0.91;
        end
        
    end
    
    stats(:, 1 + i) = new_S.Lap * n + new_S.TrackPos;
    
    if any(stats(:, 1 + i) <= stats(:, i))
        hi = 1;
    end
    
    S = new_S;
    
    order = transpose(1:m);
    Sort = [S.TrackPos, S.RacingLine];

    ordertemp = sortrows([order, Sort], [2, 3], {'descend', 'descend'});
    order = ordertemp(:, 1);
    
    Position = sortrows([sortrows([transpose(1:m), stats(:, 1 + i), S.RacingLine], [2, 3], {'descend', 'descend'}), transpose(1:m)], 1);    
    S.Position = Position(:, 4);
   
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
end
