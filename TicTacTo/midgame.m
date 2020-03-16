function midgame(board, k, n)
    global Q Q_new boards whens alpha gamma

    turns = ["x", "o"];
    j = sum(sum(board ~= ""));
    i = mod(j, 2) + 1;

    test = false;

    x = find(~isnan(Q(:, :, k)));
    x = x(ceil(rand * size(x, 1)));

    board(x) = turns(i);
    i = mod(i, 2) + 1;
    j = j + 1;

    [finish, winner] = is_finished(board, n);

    if ~finish
        y = one_off(board, i);

        if y == 0
            y = find(board == "");
            y = y(ceil(rand * size(y, 1)));
        end

        board(y) = turns(i);
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
        reward = 1;
    elseif win == "bot"
        reward = -1;
    else
        reward = 0;
    end

    test = false;
    
    start_state = Q_new(:, :, k);

    if finish
        start_state(x) = (1 - alpha) *  start_state(x) + alpha * reward;

    else
        k1 = whens(j) - 1;
        while ~test
            k1 = k1 + 1;
            test = check(transpose(board(:)), boards(k1, :), n);
        end
        new_state = Q_new(:, :, k1);
        
        if max(Q_new(:, :, k1)) ~= 0
           fadsf =123;
        end

        start_state(x) = (1 - alpha) *  start_state(x) + alpha * (reward + gamma * max(max(new_state)));
    end

    Q_new(:, :, k) = start_state;
end