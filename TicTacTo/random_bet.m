function End = random_bet(Start)
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
    
    Bet = Start * (ceil(rand * 10)/10);
    End = Start - Bet;
    
    if isempty(Listans{type})
        bets{1} = {type, [], Bet};        
    else
        bets{1} = {type, Listans{type}(ceil(rand * size(Listans{type}, 1)), :), Bet};
    end
        
    Return = Roullete(bets);
    
    End = End + Return;
end