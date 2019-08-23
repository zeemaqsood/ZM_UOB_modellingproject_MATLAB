function [edges, thick_edges, dotted_edges] = create_links1

global eqns K catalysts doubles n;

edges = [];
edges = [];
thick_edges = [];
dotted_edges = [];

links = zeros(n + 2 * size(eqns, 2));
h = n;

for i = 1:size(eqns, 2)
    b = eqns{i};
    
    if size(b{1}, 2) > 1 || size(b{2}, 2) > 1 || (ismember(i, catalysts{1}) && ismember(-i, catalysts{1}))
        h = h + 2;
        
        if K(b{3}, 1) ~= 0
            edges = [edges; [transpose(b{1}), (h - 1) * ones(size(b{1}, 2), 1), b{3} * ones(size(b{1}, 2), 1)]; ...
                            [(h - 1) * ones(size(b{2}, 2), 1), transpose(b{2}), b{3} * ones(size(b{2}, 2), 1)]];
        end
        
        if K(b{3}, 2) ~= 0
            edges = [edges; [transpose(b{2}), h * ones(size(b{2}, 2), 1), - b{3} * ones(size(b{2}, 2), 1)]; ...
                            [h * ones(size(b{1}, 2), 1), transpose(b{1}), - b{3} * ones(size(b{1}, 2), 1)]];
        end
        
        if ismember(i, doubles)
            thick_edges = [thick_edges; [transpose(b{1}), (h - 1) * ones(size(b{1}, 2), 1)]; ...
                          [(h - 1) * ones(size(b{2}, 2), 1), transpose(b{2})]];
        end
        
        if ismember(-i, doubles)
            thick_edges = [thick_edges; [transpose(b{2}), h * ones(size(b{2}, 2), 1)]; ...
                          [h * ones(size(b{1}, 2), 1), transpose(b{1})]];
        end
        
        
        if ismember(i, catalysts{1})
            a = catalysts{2}(catalysts{1} == i);
            
            dotted_edges = [dotted_edges; [a, (h - 1) * ones(size(a, 1), 1)]];
            edges = [edges; [a, (h - 1) * ones(size(a, 1), 1), b{3} * ones(size(a, 1), 1)]];
        end
        
        if ismember(-i, catalysts{1})
            a = catalysts{2}(catalysts{1} == -i);
            
            dotted_edges = [dotted_edges; [a, h * ones(size(a, 1), 1)]];
            edges = [edges; [a, h * ones(size(a, 1), 1), - b{3} * ones(size(a, 1), 1)]];
        end
        
    elseif ismember(i, abs(catalysts{1}))
        h = h + 1;
        
        [p, q] = meshgrid(b{1}, b{2});
        
        if ismember(i, catalysts{1})
            a = catalysts{2}(catalysts{1} == i);
            dotted_edges = [dotted_edges; [a, h * ones(size(a, 1), 1)]];
            
            edges = [edges; [transpose(b{1}), h * ones(size(b{1}, 2), 1), b{3} * ones(size(b{1}, 2), 1)]; ...
                            [h * ones(size(b{2}, 2), 1), transpose(b{2}), b{3} * ones(size(b{1}, 2), 1)]; ...
                            [a, h * ones(size(a, 1), 1), b{3} * ones(size(a, 1), 1)]];
                        
            if K(b{3}, 2) ~= 0
                edges = [edges; [q(:), p(:), - b{3} * ones(size(p(:), 1), 1)]];
            end
            
            b = 1;
        else
            a = catalysts{2}(catalysts{1} == -i);
            dotted_edges = [dotted_edges; [a, h * ones(size(a, 1), 1)]];
               
            edges = [edges; [transpose(b{2}), h * ones(size(b{2}, 2), 1), - b{3} * ones(size(b{1}, 2), 1)]; ...
                            [h * ones(size(b{1}, 2), 1), transpose(b{1}), - b{3} * ones(size(b{1}, 2), 1)]; ...
                            [a, h * ones(size(a, 1), 1), b{3} * ones(size(a, 1), 1)]];
                        
            if K(b{3}, 1) ~= 0
                edges = [edges; [p(:), q(:), b{3} * ones(size(p(:), 1), 1)]]
            end
            
            b = -1;
        end
        
        if ismember(i, doubles)
            if b == 1
                thick_edges = [thick_edges; [b{1}, h * ones(size(b{1}, 2), 1)]; [h * ones(size(b{2}, 2), 1), b{2}]];
            else
                thick_edges = [thick_edges; [p(:), q(:)]];
            end
        end
        
        if ismember(-i, doubles)
            if b == 1
                thick_edges = [thick_edges; [q(:), p(:)]];
            else
                thick_edges = [thick_edges; [b{2}, h * ones(size(b{2}, 2), 1)], [h * ones(size(b{1}, 2), 1), b{1}]];
            end
        end
    else
        [p, q] = meshgrid(b{1}, b{2});
        
        if K(b{3}, 1) ~= 0
            edges = [edges; [p(:), q(:), b{3} * ones(size(p(:), 1), 1)]];
        end
        
        if K(b{3}, 2) ~= 0
            edges = [edges; [q(:), p(:), - b{3} * ones(size(p(:), 1), 1)]];
        end
   
        if ismember(i, doubles)
            thick_edges = [thick_edges; [p(:), q(:)]];
        end
        
        if ismember(- i, doubles)
            thick_edges = [thick_edges; [q(:), p(:)]];
        end
    end
end
end
