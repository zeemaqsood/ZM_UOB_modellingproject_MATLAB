function Time = stoc_test1(model, T)

global K IVs eqns constants multiples catalysts
% global Model_names Plot_Vars Vars unit T_unit PlotVars

Models(model, 'N');

runs = 100;
steps = 100;

number = size(IVs, 1);

Time = zeros(steps + 1, number + 1, runs);
Time(1, :, :) = [0, transpose(IVs)] .* ones(1, number + 1, runs);

Plactivated = zeros(steps, 2);
Plactivated(1, :) = [0, 0];
for i = 1:steps
    if floor(i/10) == i/10
        disp(i);
    end
    
    for r = 1:runs
        Time(i + 1, 1, r) = i * T/steps;
        vars = zeros(sum(Time(i, 2:end, r), 2), 1);
        h = 1;
        
        for j = 1:length(IVs)
            v = Time(i, j + 1, r);
            vars(h:h + v - 1) = j;
            h = h + v;
        end
        vars = vars(~ismember(vars(:, 1), constants), :);
        vars = sortrows([transpose(randperm(size(vars, 1))), vars]);
        vars = vars(:, 2:end);
        
        finalvars = [];
        
        while ~isempty(vars)
            j = ceil(size(vars, 1) * rand);
            js = vars(j, 1);
            ps = nan(size(eqns, 2) * 2, 1);
            
            for k = 1:size(eqns, 2)
                if ismember(js, eqns{k}{1})
                    a = eqns{k}{1};
                    
                    kval = K(eqns{k}{3}, 1);
                    mult = multiples{2}(multiples{1} == k);
                    cats = catalysts{2}(catalysts{1} == k);
                    
                    
                    if isempty(mult)
                        ps(2 * (k - 1) + 1) = kval * T/steps * 2^-(sum(vars(j, :) ~= 0) - 1);
                    else
                        ps(2 * (k - 1) + 1) = kval * mult * T/steps * 2^-(sum(vars(j, :) ~= 0) - 1);
                    end
                    
                    for m = 1:length(a)
                        if a(m) ~= js && ~ismember(a(m), constants)
                            ps(2 * (k - 1) + 1) = ps(2 * (k - 1) + 1) * sum((vars(:, 1) == a(m)) .* 2.^-(sum(vars ~= 0, 2) - 1));
                        elseif ismember(a(m), constants)
                            ps(2 * (k - 1) + 1) = ps(2 * (k - 1) + 1) * Time(i, a(m) + 1, r);
                        end
                    end
                    
                    for m = 1:length(cats)
                        if ismember(a(m), constants)
                            ps(2 * (k - 1) + 1) = ps(2 * (k - 1) + 1) .* Time(i, cats{m} + 1, r);
                        else
                            ps(2 * (k - 1) + 1) = ps(2 * (k - 1) + 1) .* sum(vars(:, 1) == cats{m});
                        end
                    end
                end
                
                if ismember(js, eqns{k}{2})
                    a = eqns{k}{2};
                    
                    kval = K(eqns{k}{3}, 2);
                    mult = multiples{2}(multiples{1} == -k);
                    cats = catalysts{2}(catalysts{1} == -k);
                    
                    if isempty(mult)
                        ps(2 * k) = kval * T/steps * 2^-(sum(vars(j, :) ~= 0) - 1);
                    else
                        ps(2 * k) = kval * mult * T/steps * 2^-(sum(vars(j, :) ~= 0) - 1);
                    end
                    
                    for m = 1:length(a)
                        if a(m) ~= js && ~ismember(a(m), constants)
                            ps(2 * k) = ps(2 * k) * sum((vars(:, 1) == a(m)) .* 2.^-(sum(vars ~= 0, 2) - 1));
                            
                        elseif ismember(a(m), constants)
                            ps(2 * k) = ps(2 * k) * Time(i, a(m) + 1, r);
                        end
                    end
                    
                    for m = 1:length(cats)
                        ps(2 * k) = ps(2 * k) .* Time(i, cats{m} + 1, r);
                    end
                end
            end
            
            ps(~isnan(ps)) = ps(~isnan(ps), 1);
            
            prob = zeros(2 * size(eqns, 2), 1);
            n = sum(~isnan(ps), 1);
            dum = 0;
            
            for k = 1:2 * size(eqns, 2)
                if ~isnan(ps(k))
                    for i1 = 1:n
                        list = perms([zeros(1, n - i1), ones(1, i1 - 1)]);
                        
                        for j1 = size(list, 1)
                            t = (1/i1) * size(list, 1);
                            h = 1;
                            
                            for k1 = 1:2 * size(eqns, 2)
                                g = 1;
                                if k1 ~= k && ~isnan(ps(k1))
                                    if list(j1, g) == 0
                                        t = t .* (1 - min(ps(k1), 1));
                                        g = g + 1;
                                        
                                    else
                                        t = t .* min(ps(k1), 1);
                                        g = g + 1;
                                    end
                                end
                            end
                            
                            prob(k) = prob(k) + t;
                        end
                    end
                    
                    prob(k) = min(ps(k), 1) .* prob(k) * (1 + 2 * (max(ps(k), 1) - 1)) + dum;
                    dum = prob(k);
                else
                    prob(k) = dum;
                end
            end
            
            m = find(max(1, max(prob)) * rand < prob, 1);
            if isempty(m)
                vars(j, :) = [];
                finalvars = [finalvars, js];
                h = 0;
                
            else
                eqn = eqns{ceil(m/2)};
                
                if floor(m/2) == m/2
                    a = eqn{2}(~ismember(eqn{2}, constants));
                    b = eqn{1}(~ismember(eqn{1}, constants));
                    
                else
                    a = eqn{1}(~ismember(eqn{1}, constants));
                    b = eqn{2}(~ismember(eqn{2}, constants));
                end
                
                if js == 4
                    test = 1;
                end
                vars(j, 1:end + 1) = [b(1), vars(j, :)];
                a(find(a == js, 1)) = [];
                b(1) = [];
                
                for k = 1:max(length(a), length(b))
                    if k <= length(a) && k <= length(b)
                        [~, y] = ismember([a(k), zeros(1, size(vars, 2) - 1)], vars, 'rows');
                        vars(y, 1:end + 1) = b(k);
                        
                    elseif k <= length(a)
                        [~, y] = ismember(a(k), vars(:, 1), 'rows');
                        vars(y, :) = [];
                        
                    else
                        q = floor(rand * (size(vars, 1) + 1));
                        vars = [vars(1:q, :); [b(k), vars(j, 2:end)]; vars(q + 1:end, :)];
                    end
                end
            end
        end
        newvals = [transpose(unique(finalvars)), sum(finalvars == transpose(unique(finalvars)), 2)];
        
        Time(i + 1, 2:end, r) = 0;
        
        Time(i + 1, constants + 1, r) =  Time(i, constants + 1, r);
        Time(i + 1, newvals(:, 1) + 1, r) =  newvals(:, 2);
    end
end

t = 1;
