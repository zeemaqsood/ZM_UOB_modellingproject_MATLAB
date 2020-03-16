function create_boards1(n)
    global Q Q_new boards whens

    board1 = strings(n);
    boards = strings(1, n^2);
    whens = ones(n^2, 1);
    whens(2) = 2;
    turns = ["x", "o"];
    m = 1;
    
    for i = 1:n^2 - 1
        i
        
        for j = whens(i):whens(i + 1) - 1
            board = boards(j, :);
            
            for k = 1:n^2
                board1(:) = board(:);
                
                if board1(k) == ""
                    board1(k) = turns(mod(i - 1, 2) + 1);
                    
                    if ~is_finished(board1, n)
                        ij = whens(i + 1);
                        test = false;
                        
                        while ~test && ij <= m
                            test = check(transpose(board1(:)), boards(ij, :), n);
                            ij = ij + 1;
                        end
                        
                        if ~test
                            m = m + 1;
                            boards(m, :) = board1(:);
                        end
                    end
                end
            end
        end
        
        whens(i + 2) = m + 1;
    end
    
    Q = nan(3, 3, size(boards, 1));
    
    test = transpose(boards);
    board = strings(n);
    
    for i = 1:size(boards, 1)
        test = checkplace(boards(i, :), n);
        test1 = nan(n);
        test1(unique(test(test ~= 0))) = 0;
        
        Q(:, :, i) = test1;
    end
    
    Q_new = Q;
end