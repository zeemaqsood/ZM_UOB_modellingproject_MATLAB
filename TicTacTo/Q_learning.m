function wins = Q_learning(n)
    global alpha gamma Q Q_new
    
    alpha = 0.3;
    gamma = 1;
    
    Q = zeros(3^(n^2), n^2);
    Q_new = Q;
    
    runs = 1000000;
    check = 1000;
    tests = 1000;
    
    winner = strings(tests, 1);
    wins = zeros(runs/check, 3);
                    
    for i = 1:runs
        TicTacTo2(n, false, false);
        
        if mod(i, check) == 0
            for j = 1:tests
                winner(j) = TicTacTo2(n, false, true);
            end
            
            disp(i/runs);
            Q = Q_new;
            wins(i/check, 1) = sum(winner == "AI");
            wins(i/check, 2) = sum(winner == "bot");
            wins(i/check, 3) = sum(winner == "");
        end
    end
end