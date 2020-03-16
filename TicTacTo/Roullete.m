function End = Roullete(bets)

    Bet = zeros(8, 27);
    
    Bets = "Your bets are: ";
    
    for i = 1:size(bets, 1)
        bet = bets{i};
        if bet{1} == 1
            x = 8;
            y = 1;
            dum = " on Even";
            
        elseif bet{1} == 2
            x = 8;
            y = 2;
            dum = " on Odd";
            
        elseif bet{1} == 3
            x = 8;
            y = 4;
            dum = " on Red";
            
        elseif bet{1} == 4
            x = 8;
            y = 5;
            dum = " on Black";
            
        elseif bet{1} == 5
            x = 8;
            y = 7;
            dum = " on 1to18";
            
        elseif bet{1} == 6
            x = 8;
            y = 8;
            dum = " on 19to36";
            
        elseif bet{1} == 7
            x = 8;
            y = 9 + bet{2};
            l = ["1to12", "13to24", "25to36"];
            dum = strcat(" on ", l(bet{2}));
            
        elseif bet{1} == 8
            y = 1;
            x = 2 * bet{2};
            l = ["1, 4, ..., 34", "2, 5, ..., 35", "3, 6, ..., 36"];
            dum = strcat(" on ", l(bet{2}));
            
        elseif bet{1} == 9
            if bet{2} == 0
                x = 4;
                y = 2;
            else
                x = 2 * mod(bet{2} - 1, 3) + 2;
                y = 2 * ceil(bet{2}/3) + 2;
            end
            dum = strcat(" on ", num2str(bet{2}));
            
        elseif bet{1} == 10
            s = bet{2}(1);
            t = bet{2}(2);
            if abs(s - t) == 1
                x = 2 * mod(min(s, t) - 1, 3) + 3;
                y = 2 * ceil(s/3) + 2;
                
            elseif abs(s - t) == 3
                x = 2 * mod(s - 1, 3) + 2;
                y = 2 * ceil(min(s, t)/3) + 3;
                
            elseif (s == 0 && ismember(t, [1, 2, 3]))
                x = 2 * max(s, t);
                y = 3;
                
            else
                x = 2 * max(s, t);
                y = 3;
            end
        dum = strcat(" on ", num2str(s), " and ", num2str(t));
        
        elseif bet{1} == 11
            x = 1;
            y = 2 * bet{2} + 2;
            l = ["1to3", "4to6", "7to9", "10to12", "13to15", "16to18", "19to21", "22to24", "25to27", "28to30", "31to33", "34to36"];
            dum = strcat(" on ", l(bet{2}));
            
        elseif bet{1} == 12
            x = 1;
            y = 2 * bet{2}(1) + 3;l = ["1to6", "4to9", "7to12", "10to15", "13to18", "16to21", "19to24", "22to27", "25to30", "28to33", "31to36"];
            dum = strcat(" on ", l(min(bet{2})));
            
        elseif bet{1} == 13
            x = 2 * mod(bet{2} - 1, 3) + 3;
            y = 2 * ceil(bet{2}/3) + 3;
            dum = strcat(" on ", num2str(bet{2}), ", ", num2str(bet{2} + 1), ", ", num2str(bet{2} + 3), " and ", num2str(bet{2} + 4));
            
        elseif bet{1} == 14
            x = 1 + 2 * bet{2};
            y = 3;
            l = ["0, 1 and 2", "0, 2 and 3"];
            dum = strcat(" on ", l(bet{2}));
            
        elseif bet{1} == 15
            x = 1;
            y = 3;
            dum = " on 0, 1, 2 and 3";
        end
        
        Bet(x, y) = bet{3};
        
        Bets = strcat(Bets, ", £", num2str(bet{3}), dum);
    end
    
%     disp(Bets);
    
%     disp("No more bets");
    
    Roullette = zeros(8, 27);
    r = floor(rand * 37);
    
    if r == 0
        Roullette(1, 3) = 9;
        Roullette(4, 2) = 36;
        Roullette(2:2:6, 3) = 18;
        Roullette([3, 5], 3) = 12;
        
    else
        Roullette(2 * mod(r - 1, 3) + 2, [2 * ceil(r/3) + 1, 2 * ceil(r/3) + 3]) = 18;
        Roullette([2 * mod(r - 1, 3) + 1, 2 * mod(r - 1, 3) + 3], 2 * ceil(r/3) + 2) = 18;
        if r > 3
            Roullette([2 * mod(r - 1, 3) + 1, 2 * mod(r - 1, 3) + 3], [2 * ceil(r/3) + 1, 2 * ceil(r/3) + 3]) = 9;
            Roullette(1, [2 * ceil(r/3) + 1, 2 * ceil(r/3) + 3]) = 6;
            
        else
            Roullette([2 * mod(r - 1, 3) + 1, 2 * mod(r - 1, 3) + 3], 2 * ceil(r/3) + 3) = 9;
            
            Roullette(1, 3) = 9;
            Roullette(1, 5) = 6;
            
            if ismember(r, [1, 2])
                Roullette(2 * mod(r - 1, 3) + 3, 2 * ceil(r/3) + 1) = 12;
            end
            
            if ismember(r, [2, 3])
                Roullette(2 * mod(r - 1, 3) + 1, 2 * ceil(r/3) + 1) = 12;
            end
        end
        
        Roullette(2 * mod(r - 1, 3) + 2, 1) = 3;
        Roullette(1, 2 * ceil(r/3) + 2) = 12;
        Roullette(2 * mod(r - 1, 3) + 2, 2 * ceil(r/3) + 2) = 36;
        Roullette(8, 1 + mod(r, 2)) = 2;
        
        if ismember(r, [1:2:9, 12:2:18, 19:2:27, 30:2:36])
            Roullette(8, 4) = 2;
        else
            Roullette(8, 5) = 2;
        end
        
        Roullette(8, 6 + ceil(r/18)) = 2;
        Roullette(8, 9 + ceil(r/12)) = 3;
    end
    if ismember(r, [1:2:9, 12:2:18, 19:2:27, 30:2:36])
%         disp(strcat(num2str(r), " red!"));
    else
%         disp(strcat(num2str(r), " black!"));
    end

    End = sum(sum(Bet .* Roullette));
%     disp(strcat("You received £", num2str(sum(sum(Bet .* Roullette)))));
end

