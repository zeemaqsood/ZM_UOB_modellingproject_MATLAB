function create_boards(n)
    global Q Q_new boards whens

    board1 = strings(n);
    boards = strings(0, n^2);
    whens = ones(n^2, 1);
    
    for i = 0:n^2 - 1
        i
        new_boards = strings(0, n^2);  
        
        if i > 0
            list = tuples2(1:n^2, i);
            
            for j = 1:size(list, 1)
                list1 = tuples2(list(j, :), ceil(i/2));
                
                test = strings(size(list1, 1), n^2);
                test(:, list(j, :)) = "o";
                
                for k = 1:size(list1, 1)
                    test(k, list1(k, :)) = "x";
                end
                new_boards = [new_boards; test];
            end
            
        else
            new_boards = strings(1, n^2);
        end
                
        j = 1;
        while j <= size(new_boards, 1) 
            board1(:) = new_boards(j, :);
            
            if is_finished(board1, n)
                new_boards(j, :) = [];
            else
                j = j + 1;
            end
        end
        
        j = 1;
        while j < size(new_boards, 1)
            k = j + 1;
            
            while k <= size(new_boards, 1)
                test = check(new_boards(j, :), new_boards(k, :), n);
                
                if test
                    new_boards(k, :) = [];
                else
                    k = k + 1;
                end
            end
            j = j + 1;
        end
        
        boards = [boards; new_boards];
        
        if i < n^2 - 1
            whens(i + 2) = whens(i + 1) + size(new_boards, 1);
        end
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