function reward = Roullette_AI(Start)
    global Q Q_new alpha gamma
    
    BetList = {0;
               [1, 2, 3, 4, 5, 6];
               [7, 8];
                12;
               [13, 15];
               [11, 14];
                10;
                9};
            
    if rand < 0.25
        n = ceil(rand*(size(BetList, 1)));
        perc = ceil(rand * 10);
        
    else
        [a, b] = find(Q_new(2:end, 2:end, 11) == max(Q_new(2:end, 2:end, 11)));
        r = ceil(length(a) * rand);
        perc = a(r) - 1;
        n = b(r);
    end
     
    type = BetList{n}(ceil(rand * length(BetList{n})));
    Bet = Start * (perc/10);
    
    End = Start - Bet;
    
    if type == 0
        reward = Start;
        Max = max(max(Q(2:end, 2:end, floor(log2(Start)) + 8)));
        Q(2, 2, floor(log2(Start)) + 8) = (1 - alpha) * Q(2, 2, floor(log2(Start)) + 8) + alpha * (reward + gamma * Max);
%         disp(strcat("You left the table on £", num2str(Start)));
        
    else
        bets = cell(1, 1);
        
        type = ceil(rand * 15);
        
        Listans = cell(15, 1);
        Listans{7} = [1; 2; 3];
        Listans{8} = [1; 2; 3];
        Listans{9} = transpose(1:36);
        Listans{10} = [transpose([0, floor(0:0.5:33.5), 34, 35]), [1; 2; 3; zeros(68, 1)]];
        Listans{10}([4:2:68, 70, 71], 2) = Listans{10}([4:2:68, 70, 71], 1) + 1;
        Listans{10}(5:2:69, 2) = Listans{10}(5:2:69, 1) + 3;
        Listans{11} = transpose(1:12);
        Listans{12} = transpose([1:11; 2:12]);
        Listans{13} = transpose(1:32);
        Listans{13} = Listans{13}(floor(Listans{13}/3) ~= Listans{13}/3);
        Listans{14} = [1; 2];
        
        if isempty(Listans{type})
            bets{1} = {type, [], Bet};
        else
            bets{1} = {type, Listans{type}(ceil(rand * size(Listans{type}, 1)), :), Bet};
        end
        
        Return = Roullete(bets);
        
        if (perc == 9 || perc == 10) && Return ~= 0
            test = 1;
        end
        
        End = End + Return;
        
        if End < 0.01
            reward = 0;
            Max = 0;
%             disp("You left the table on £0");
            
        else
%             disp(strcat("You have £", num2str(End), "left"));
            reward = Roullette_AI(End);
            Max = max(max(Q(2:end, 2:end, floor(log2(End)) + 8)));
        end
        
        Q(perc + 2, n, floor(log2(Start)) + 8) = (1 - alpha) * Q(perc + 2, n, floor(log2(Start)) + 8) + alpha * (reward + gamma * Max);
    end
end