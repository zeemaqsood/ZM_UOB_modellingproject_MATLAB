function [links, double_edges, thick_edges, dotted_edges] = create_links2

global eqns K catalysts doubles n;

double_edges = [];
thick_edges = [];
dotted_edges = [];

links = zeros(n + 2 * size(eqns, 2));
h = n;

for i = 1:size(eqns, 2)
    b = eqns{i};
    
    if size(b{1}, 2) > 1 || size(b{2}, 2) > 1 || (ismember(i, catalysts) && ismember(-i, catalysts))
        h = h + 2;
        
        if K(b{3}, 1) ~= 0
            links(b{1}, h - 1) = b{3};
            links(h - 1, b{2}) = b{3};
            
            if size(unique(b{1}), 2) ~= size(b{1}, 2)
                [~, c1] = unique(b{1});
                c2 = 1:size(b{1}, 2);
                c2 = c2(~ismember(c2, c1));
                
                for j = 1:size(c2, 2)
                    double_edges = [double_edges; [b{1}(c2(j)), h - 1, b{3}]];
                end
            end
            
            if size(unique(b{2}), 2) ~= size(b{2}, 2)
                [~, c1] = unique(b{2});
                c2 = 1:size(b{2}, 2);
                c2 = c2(~ismember(c2, c1));
                
                for j = 1:size(c2, 2)
                    double_edges = [double_edges; [h - 1, b{2}(c2(j)), - b{3}]];
                end
            end
        end
        
        if K(b{3}, 2) ~= 0
            links(h, b{1}) = - b{3};
            links(b{2}, h) = - b{3};
            
            if size(unique(b{1}), 2) ~= size(b{1}, 2)
                [~, c1] = unique(b{1});
                c2 = 1:size(b{1}, 2);
                c2 = c2(~ismember(c2, c1));
                
                for j = 1:size(c2, 2)
                    double_edges = [double_edges; [h, b{1}(c2(j)), - b{3}]];
                end
            end
            
            if size(unique(b{2}), 2) ~= size(b{2}, 2)
                [~, c1] = unique(b{2});
                c2 = 1:size(b{2}, 2);
                c2 = c2(~ismember(c2, c1));
                
                for j = 1:size(c2, 2)
                    double_edges = [double_edges; [b{2}(c2(j)), h, b{3}]];
                end
            end
        end
        
        
        if ismember(i, doubles)
            thick_edges = [thick_edges; [transpose(b{1}), (h - 1) * ones(size(b{1}, 2), 1)]; [(h - 1) * ones(size(b{2}, 2), 1), transpose(b{2})]];
        end
            
        if ismember(-i, doubles)
            thick_edges = [thick_edges; [transpose(b{2}), h * ones(size(b{2}, 2), 1)]; [h * ones(size(b{1}, 2), 1), transpose(b{1})]];
        end
        
        
        if ismember(i, catalysts{1})
            a = catalysts{2}(catalysts{1}(catalysts{1} == i));
            
            dotted_edges = [dotted_edges; [a, (h - 1) * ones(size(a, 1), 1)]];
            
            for k = 1:size(a, 2)
                if any(ismember(b{1}, a(k)))
                    double_edges = [double_edges; [a(k), h - 1, b{3}]];
                end
            end
        end
        
        if ismember(-i, catalysts{1})
            a = catalysts{2}(catalysts{1}(catalysts{1} == -i));
            
            dotted_edges = [dotted_edges; [a, h * ones(size(a, 1), 1)]];
            
            for k = 1:size(a, 2)
                if any(ismember(b{2}, a(k)))
                    double_edges = [double_edges; [a(k), h, - b{3}]];
                end
            end            
        end
        
    elseif ismember(i, abs(catalysts{1}))
        h = h + 1;
        links(b{1}, b{2}) = b{3};
        links(b{2}, b{1}) = - b{3};
        
        if ismember(i, catalysts{1})
            a = catalysts{2}(catalysts{1}(catalysts{1} == i));
            b = 1;
        else
            a = catalysts{2}(catalysts{1}(catalysts{1} == -i));
            b = -1;
        end
        
        if ismember(i, doubles)
            thick_edges = [thick_edges; [b{1}, h]; [h, b{2}]];
        end
            
        if ismember(-i, doubles)
            thick_edges = [thick_edges; [transpose(b{2}), h * ones(size(b{2}, 2), 1)]; [h * ones(size(b{1}, 2), 1), transpose(b{1})]];
        end
                
    end
        
        g = [0, 0];
                
        for j = 1:size(catalysts, 2)
            a = catalysts{j};
            
            if isequal(b{1}, a{2}) && isequal(b{2}, a{3})
                if g(1) == 0
                    h = h + 1;
                    g(1) = h;
                end
                
                if K(b{3}, 1) ~= 0
                    links(b{1}, g(1)) = b{3};
                    links(g(1), b{2}) = b{3};
                    
                    if size(unique([a{1}, b{1}]), 2) ~= size([a{1}, b{1}], 2)
                        t = [a{1}, b{1}];
                        
                        [~, c1] = unique(t);
                        c2 = 1:size(t, 2);
                        c2 = c2(~ismember(c2, c1));
                        
                        for k = 1:size(c2, 2)
                            double_edges = [double_edges; [t(c2(k)), g(1), b{3}]];
                        end
                    end
                    
                    if size(unique(b{2}), 2) ~= size(b{2}, 2)
                        t = b{2};
                        
                        [~, c1] = unique(t);
                        c2 = 1:size(t, 2);
                        c2 = c2(~ismember(c2, c1));
                        
                        for k = 1:size(c2, 2)
                            double_edges = [double_edges; [g(1), t(c2(k)), - b{3}]];
                        end
                    end
                    
                    dotted_edges = [dotted_edges; [transpose(a{1}), g(1) * ones(size(a{1}, 2), 1)]];
                end
                
            elseif isequal(b{1}, a{3}) && isequal(b{2}, a{2})
                if g(2) == 0
                    h = h + 1;
                    g(2) = h;
                end
                
                if K(b{3}, 2) ~= 0
                    links(b{2}, g(2)) = - b{3};
                    links(g(2), b{1}) = - b{3};
                    
                    if size(unique([a{1}, b{1}]), 2) ~= size([a{1}, b{1}], 2)
                        t = [a{1}, b{1}];
                        
                        [~, c1] = unique(t);
                        c2 = 1:size(t, 2);
                        c2 = c2(~ismember(c2, c1));
                        for k = 1:size(c2, 2)
                            double_edges = [double_edges; [g(2), t(c2(k)), - b{3}]];
                        end
                    end
                    
                    if size(unique(b{2}), 2) ~= size(b{2}, 2)
                        t = b{2};
                        
                        [~, c1] = unique(t);
                        c2 = 1:size(t, 2);
                        c2 = c2(~ismember(c2, c1));
                        for k = 1:size(c2, 2)
                            double_edges = [double_edges; [t(c2(k)), g(2), b{3}]];
                        end
                    end
                    
                    dotted_edges = [dotted_edges; [transpose(a{1}), g(2) * ones(size(a{1}, 2), 1)]];
                end
            end
        end
        
        if any(g ~= [0, 0])
            if g(1) == 0
                links(b{1}, b{2}) = b{3};
            elseif g(2) == 0
                links(b{2}, b{1}) = - b{3};
            end
                
            if ismember(i, doubles)
                if g(1) == 0
                    [p, q] = meshgrid(b{1}, b{2});
                    thick_edges = [thick_edges; [p(:), q(:)]];
                else
                    thick_edges = [thick_edges; [transpose(b{1}), g(1) * ones(size(b{1}, 2), 1)]; [g(1) * ones(size(b{2}, 2), 1), transpose(b{2})]];
                end
            end
            
            if ismember(-i, doubles)
                if g(2) == 0
                    [p, q] = meshgrid(b{2}, b{1});
                    thick_edges = [thick_edges; [p(:), q(:)]];
                else
                    thick_edges = [thick_edges; [transpose(b{2}), g(2) * ones(size(b{2}, 2), 1)]; [g(2) * ones(size(b{1}, 2), 1), transpose(b{1})]];
                    thick_edges = [thick_edges; [b{2}, g(2)]; [g(2), b{1}]];
                end
                
            end
            
        else
            if K(b{3}, 1) ~= 0
                links(b{1}(1), b{2}(1)) = b{3};
            end
            
            if K(b{3}, 2) ~= 0
                links(b{2}(1), b{1}(1)) = - b{3};
            end
            
            if ismember(i, doubles)
                [p, q] = meshgrid(b{1}, b{2});
                thick_edges = [thick_edges; [p(:), q(:)]];
            end
            
            if ismember(-i, doubles)
                [p, q] = meshgrid(b{2}, b{1});
                thick_edges = [thick_edges; [p(:), q(:)]];
            end
        end
    end
    
    links = links(1:h, 1:h);
end
