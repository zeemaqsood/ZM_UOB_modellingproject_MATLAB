function win = TicTacTo2(n, user, testing)
    global alpha gamma Q Q_new

    if user
        testing = true;
    end
    
    board = strings(n);
    i = 1;
    j = 1;
    turns = ["x", "o"];

    if rand < 0.5
        if user
            disp(board);
            x = input('Pls say where, you are x: ');
            board(x) = turns(i);
            
        else
            board(ceil(rand * 9)) = turns(i);
        end
        
        i = mod(i, 2) + 1;
        j = j + 1;
    end

    finish = false;

    while ~finish
        test = false;

        k = get_board_num(board(:), n);
        
        Q(k, board ~= "") = NaN;

        if ~testing && rand < 0.05
            x = find(~isnan(Q(k, :)));

        else
            x = find(Q(k, :) == max(max(Q(k, :))));
        end
        
        x = x(ceil(rand * size(x, 2)));

        board(x) = turns(i);
        i = mod(i, 2) + 1;

        [finish, winner] = is_finished(board, n);

        if ~finish
            if user
                disp(board);
                x = input('Where pls: ');
                
            else
                x = one_off(board, i);
                
                if x == 0
                    x = find(board == "");
                    x = x(ceil(rand * size(x, 2)));
                end
            end
            board(x) = turns(i);
            i = mod(i, 2) + 1;
            j = j + 1;
            [finish, winner] = is_finished(board, n);

            if finish && winner ~= ""
                win = "bot";
            else
                win = "";
            end

        elseif winner ~= ""
            win = "AI";
        else
            win = "";
        end

        if win == "AI"
            reward = 0;
        elseif win == "bot"
            reward = -1;
        else
            reward = 0;
        end

        test = false;
        
        if finish
            Q_new(k, x) = (1 - alpha) *  Q_new(k, x) + alpha * reward;
            
        else
            k1 = get_board_num(board(:), n);
            new_state = Q_new(k1, :);
            
            Q_new(k, :) = (1 - alpha) *  Q_new(k, :) + alpha * (reward + gamma * max(max(Q_new(k1, :))));
        end
    end
    
    if user
        disp(board);
    end
    
    if win == "bot"
        sadf = 1;
    end
end