function links = create_links(eqns, catalysts, n)

global K;

links = zeros(n);

for i = 1:size(eqns, 2)
    b = eqns{i};
    k_end = b{2};
    
    for j = 1:size(b{1}, 2)
        k_start = b{1}(j);
        
        if K(b{3}(1), 1) ~= 0
            links(k_start, k_end) = b{3}(1);
        end
        if K(b{3}(1), 2) ~= 0
            links(k_end, k_start) =  - b{3}(1);
        end
        
        for k = 1:size(catalysts, 2)
            a = catalysts{k};
            for k1 = 1:size(a{1}, 2)
                if ismember(a{1}(k1), a{2})
                    for k2 = 1:size(a{3}, 1)
                        links(a{3}(k2), a{1}(k1)) = 0;
                    end
                end
                if ismember(a{1}(k1), a{3})
                    for k2 = 1:size(a{2}, 1)
                        links(a{2}(k2), a{1}(k1)) = 0;
                    end
                end
            end
        end
    end
end
end
