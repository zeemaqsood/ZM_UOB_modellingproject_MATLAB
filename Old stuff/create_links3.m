function [G, thick_edges, dotted_edges] = create_links2

global eqns K catalysts doubles n;

% Edges will contain all edges and their weights
G = digraph();

dotted_edges = [];
thick_edges = [];
% We will use h as a new node, so we don not want it to override any of the
% n nodes we already have
h = n;

% For every equation in eqns
for i = 1:size(eqns, 2)
    % Consider the ith equation
    b = eqns{i};
    
    % If there are more than 1 elements at the start or finish, or if there
    % is a catalyst in both directions of the reaction, we will need to
    % create 2 new dummy nodes
    if size(b{1}, 2) > 1 || size(b{2}, 2) > 1 || (ismember(i, catalysts{1}) && ismember(-i, catalysts{1}))
        h = h + 2;
        
        % If the forward reaction occurs, add the edges from the start 
        % nodes to the middle node and the middle node to the end nodes
        if K(b{3}, 1) ~= 0
            G = addedge(G, transpose(b{1}), (h - 1) * ones(size(b{1}, 2), 1), b{3} * ones(size(b{1}, 2), 1));
            G = addedge(G, (h - 1) * ones(size(b{2}, 2), 1), transpose(b{2}), b{3} * ones(size(b{2}, 2), 1));
        end
        
        % Check for if forward reaction involve catalysts
        c = 0;
        
        % If the forward reaction has a catalyst
        if ismember(i, catalysts{1})
            % Find out which variables are a catalyst
            a = catalysts{2}(catalysts{1} == i);
            
            % Add the edge from the catalysts to the first middle node
            G = addedge(G, a, (h - 1) * ones(size(a, 1), 1), b{3} * ones(size(a, 1), 1));
            
            % Since it it a catalyst, add it to the dotted edges
            dotted_edges = [dotted_edges; [a, (h - 1) * ones(size(a, 1), 1)]];
            
            % To see that a catalyst is involved in the forward reaction
            c = 1;
        end
        
        % If the forward reaction is a double, add all forward edges to 
        % thick_edges
        if ismember(i, doubles)
            thick_edges = [thick_edges; [transpose(b{1}), (h - 1) * ones(size(b{1}, 2), 1)]; ...
                                        [(h - 1) * ones(size(b{2}, 2), 1), transpose(b{2})]];
                             
            if c == 1
                thick_edges = [thick_edges; [a, (h - 1) * ones(size(a, 1), 1)]];
            end
        end
 
        
        % If the reverse reaction occurs, add the edges from the end nodes
        % to another middle node and that middle node to the start nodes       
        if K(b{3}, 2) ~= 0
            G = addedge(G, transpose(b{2}), h * ones(size(b{2}, 2), 1), - b{3} * ones(size(b{2}, 2), 1));
            G = addedge(G, h * ones(size(b{1}, 2), 1), transpose(b{1}), - b{3} * ones(size(b{1}, 2), 1));
        end        
        
        % Check for if the reverse reaction involve catalysts
        c = 0;
        
        % If the reverse reaction has a catalyst
        if ismember(-i, catalysts{1})
            % Find out which variables are a catalyst
            a = catalysts{2}(catalysts{1} == -i);
            
            % Add the edge from the catalysts to the second middle node
            G = addedge(G, a, h * ones(size(a, 1), 1), - b{3} * ones(size(a, 1), 1));
            
            % Since it it a catalyst, add it to the dotted edges
            dotted_edges = [dotted_edges; [a, h * ones(size(a, 1), 1)]];
            
            % To see that a catalyst is involved in the reverse reaction
            c = 1;
        end
                
        % If the reverse reaction is a double, add all reverse edges to
        % thick_edges
        if ismember(-i, doubles)
            thick_edges = [thick_edges; [transpose(b{2}), h * ones(size(b{2}, 2), 1)]; ...
                          [h * ones(size(b{1}, 2), 1), transpose(b{1})]];
                      
            if c == 1   
                thick_edges = [thick_edges; [a, h * ones(size(a, 1), 1)]];
            end
        end
     
    % If the reaction contain a catakyst, one new node must be created    
    elseif ismember(i, abs(catalysts{1}))
        h = h + 1;
        
        % If the forward reaction contains a catalyst
        if ismember(i, catalysts{1})
            % Find out which variables are a catalyst
            a = catalysts{2}(catalysts{1} == i);
            
            % Add the edges from the first node to the middle node, the
            % middle node to the end node and the catalysts to the middle
            % node
            G = addedge(G, transpose(b{1}), h * ones(size(b{1}, 2), 1), b{3} * ones(size(b{1}, 2), 1));
            G = addedge(G, h * ones(size(b{2}, 2), 1), transpose(b{2}), b{3} * ones(size(b{1}, 2), 1));
            G = addedge(G, a, h * ones(size(a, 1), 1), b{3} * ones(size(a, 1), 1));
                   
            % Add the edges from the catalysts to the middle node            
            dotted_edges = [dotted_edges; [a, h * ones(size(a, 1), 1)]];
                     
            % If the reverse reaction occurs, add edge between end node and
            % start node
            if K(b{3}, 2) ~= 0
                G = addedge(G, b{2}, b{1}, - b{3});
            end
            
            b = 1;
            
        % Repeat for if the catalyst is involved for the reverse direction
        else
            a = catalysts{2}(catalysts{1} == -i);
            G = addedge(G, transpose(b{2}), h * ones(size(b{2}, 2), 1), - b{3} * ones(size(b{1}, 2), 1));
            G = addedge(G, h * ones(size(b{1}, 2), 1), transpose(b{1}), - b{3} * ones(size(b{1}, 2), 1));
            G = addedge(G, a, h * ones(size(a, 1), 1), b{3} * ones(size(a, 1), 1));
               
            dotted_edges = [dotted_edges; [a, h * ones(size(a, 1), 1)]];
                        
            if K(b{3}, 1) ~= 0
                G = addedge(G, b{1}, b{2}, b{3});
            end
            
            b = -1;
        end
        
        % If the forward reaction is a double, then add the forward edges,
        % including the catalyst edge, to the thick_edges
        if ismember(i, doubles)
            % If the forward reaction involves a catalyst
            if b == 1
                thick_edges = [thick_edges; [b{1}, h * ones(size(b{1}, 2), 1)]; ...
                              [h * ones(size(b{2}, 2), 1), b{2}]; ...
                              [a, h * ones(size(a, 1), 1)]];
            else
                thick_edges = [thick_edges; [b{1}, b{2}]];
            end
        end
        
        % If the reverse reaction is a double, then add the reverse edges,
        % including the catalyst edge, to the thick_edges
        if ismember(-i, doubles)
            % If the forward reaction involves a catalyst
            if b == 1
                thick_edges = [thick_edges; [b{2}, b{2}]];
            else
                thick_edges = [thick_edges; [b{2}, h * ones(size(b{2}, 2), 1)]; ...
                              [h * ones(size(b{1}, 2), 1), b{1}]; ...
                              [a, h * ones(size(a, 1), 1), b{3} * ones(size(a, 1), 1)]];
            end
        end
    else
        % If the forward reaction occurs
        if K(b{3}, 1) ~= 0
            G = addedge(G, b{1}, b{2}, b{3});
        end
        
        % If the reverse reaction occurs
        if K(b{3}, 2) ~= 0
            G = addedge(G, b{2}, b{1}, - b{3});
        end
   
        % If the forward reaction is a double
        if ismember(i, doubles)
            thick_edges = [thick_edges; [b{1}, b{2}]];
        end
        
        % If the reverse reaction is a double
        if ismember(- i, doubles)
            thick_edges = [thick_edges; [b{2}, b{1}]]; %#ok<*AGROW>
        end
    end
end
end
