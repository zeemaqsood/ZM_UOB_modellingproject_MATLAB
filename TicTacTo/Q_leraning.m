function wins = Q_leraning(n)
    global alpha gamma Q Q_new count boards

    create_boards(n);
    
    alpha = 0.3;
    gamma = 1;
    
    runs = 10000;
    check = 1000;
    tests = 1000;
    
    count = [transpose(1:size(Q, 3)), zeros(size(Q, 3), 1)];
    
    winner = strings(tests, 1);
    wins = zeros(runs/check, 3);
    
    board = strings(3);
    
    for k = size(Q, 3):-1:2
        disp(k);
        board(:) = boards(k, :);
        
        for j = 1:100
            midgame(board, k, n);
        end
    end
            
    for i = 1:runs
        TicTacTo(n, false, false);
        
        if mod(i, check) == 0
            for j = 1:tests
                winner(j) = TicTacTo(n, false, true);
            end
            disp(i/runs);
            Q = Q_new;
            wins(i/check, 1) = sum(winner == "AI");
            wins(i/check, 2) = sum(winner == "bot");
            wins(i/check, 3) = sum(winner == "");
        end
    end
end