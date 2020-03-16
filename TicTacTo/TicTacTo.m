function win = TicTacTo(n, user, testing)
    global alpha gamma Q Q_new boards whens count

    if user
        testing = true;
    end
    
    board = strings(3);
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

        k = whens(j) - 1;
        while ~test
            k = k + 1;
            [test, r, t] = check(transpose(board(:)), boards(k, :), n);
        end

        if ~testing && rand < 0.05
            newx = find(~isnan(Q(:, :, k)));

        else
            newx = find(Q(:, :, k) == max(max(Q(:, :, k))));
        end
        
        newx = newx(ceil(rand * size(newx, 1)));
        x = newx;
        
        if ismember(x, [2, 4])
            vec = [2, 4];
            [~, y] = ismember(x, vec);
            x = vec(mod(y + t - 1, 2) + 1);

        elseif ismember(x, [3, 7])
            vec = [3, 7];
            [~, y] = ismember(x, vec);
            x = vec(mod(y + t - 1, 2) + 1);

        elseif ismember(x, [6, 8])
            vec = [6, 8];
            [~, y] = ismember(x, vec);
            x = vec(mod(y + t - 1, 2) + 1);
        end

        if ismember(x, [1, 7, 9, 3])
            vec = [1, 7, 9, 3];
            [~, y] = ismember(x, vec);
            x = vec(mod(y + r - 1, 4) + 1);

        elseif ismember(x, [2, 4, 8, 6])
            vec = [2, 4, 8, 6];
            [~, y] = ismember(x, vec);
            x = vec(mod(y + r - 1, 4) + 1);
        end

        board(x) = turns(i);
        i = mod(i, 2) + 1;
        j = j + 1;

        [finish, winner] = is_finished(board, n);

        if ~finish
            if user
                disp(board);
                x = input('Where pls: ');
                
            else
                x = one_off(board, i);
                
                if x == 0
                    x = find(board == "");
                    x = x(ceil(rand * size(x, 1)));
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

        start_state = Q_new(:, :, k);
        
        if finish
            start_state(newx) = (1 - alpha) *  start_state(newx) + alpha * reward;
            
        else
            k1 = whens(j) - 1;
            while ~test
                k1 = k1 + 1;
                [test, r, t] = check(transpose(board(:)), boards(k1, :), n);
            end
            new_state = Q_new(:, :, k1);
            
            start_state(newx) = (1 - alpha) *  start_state(newx) + alpha * (reward + gamma * max(max(new_state)));
        end
        
        Q_new(:, :, k) = start_state;
        
        count(k, 2) = count(k, 2) + 1;
    end
    
    if user
        disp(board);
    end
    
    if win == "bot"
        sadf = 1;
    end
end