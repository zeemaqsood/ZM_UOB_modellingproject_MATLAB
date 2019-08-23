function links = create_links

global eqns K catalysts doubles n;

links = zeros(n + 2 * size(eqns, 2));
h = n + 2;

for i = 1:size(eqns, 2)
    b = eqns{i};
    
    if size(b{1}, 2) > 1 || size(b{2}, 2) > 1
        if K(b{3}, 1) ~= 0
            links(b{1}, h - 1) = b{3};
            links(h - 1, b{2}) = b{3};
        end
        
        if K(b{3}, 2) ~= 0
            links(h, b{1}) = - b{3};
            links(b{2}, h) = - b{3};
        end
        
        for j = 1:size(doubles, 2)
            a = doubles{j};
            
            if all(b{1} == a{1}) && all(b{2} == a{2})
                links(b{1}, h - 1) = b{3} + 0.25;
                links(h - 1, b{2}) = b{3} + 0.25;
                
            elseif all(b{1} == a{2}) && all(b{2} == a{1})
                links(b{2}, h) = - b{3} + 0.25;
                links(h, b{1}) = - b{3} + 0.25;
            end
        end
        
        for j = 1:size(catalysts, 2)
            a = catalysts{j};
            
            if all(b{1} == a{2}) && all(b{2} == a{3})
                links(a{1}, h - 1) = b{3} + 0.5;
                links(h, a{1}) = 0;
                
            elseif all(b{1} == a{3}) && all(b{2} == a{2})
                links(a{1}, h) = - b{3} + 0.5;
                links(h - 1, a{1}) = 0;
            end
            
        end
        
        h = h + 2;
        
    else
        if K(b{3}, 1) ~= 0
            links(b{1}(1), b{2}(1)) = b{3};
        end
        
        if K(b{3}, 2) ~= 0
            links(b{2}(1), b{1}(1)) = - b{3};
        end
        
        for j = 1:size(doubles, 2)
            a = doubles{j};
            
            if all(b{1} == a{1}) && all(b{2} == a{2})
                links(b{1}, b{2}) = b{3} + 0.25;
                
            elseif all(b{1} == a{2}) && all(b{2} == a{1})
                links(b{2}, b{1}) = - b{3} + 0.25;
            end
        end
    end
end

links = links(1:h - 2, 1:h - 2);
end
