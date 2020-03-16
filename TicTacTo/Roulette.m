function End = Roulette(Start)
    
    List = ["Even", "Odd", "Red", "Black", "1to18", "19to36", "Dozen", "Column", ...
        "Single", "Double", "Street", "Double Street", "Corner", "Trio", "First Four"];
    
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
    
    vec = zeros(3, 12);
    vec(:) = 1:36;
    
    
    g = 'n';
    
    h = 0;
    
    CurrBal = Start;
    
    Bet = zeros(8, 27);
    
    Bets = "Your bets are: ";
    
    while g == 'n'
        h = 0;
        
        CurrBal = Start;
        
        Bet = zeros(8, 27);
        
        Bets = "Your bets are: ";
        
        while h == 0 && CurrBal > 0
            Type = input('What kind of bet would you like to make? ', 's');
            %     Type = input('What kind of bet would you like to make? 1: Even 2: Odd 3: Red 4: Black 5: 1to18 6: 19to36 7: Dozen 8: Column 9: Single 10: Double 11: Street 12: Double Street 13: Corner 14: Trio 15: First Four');
            
            while ~ismember(Type, List)
                Type = input('Sorry, I didnt understand that. What kind of bet would you like to make? ', 's');
                %         Type = input('Sorry, I didnt understand that. What kind of bet would you like to make? 1: Even 2: Odd 3: Red 4: Black 5: 1to18 6: 19to36 7: Dozen 8: Column 9: Single 10: Double 11: Street 12: Double Street 13: Corner 14: Trio 15: First Four');
            end
            
            if Type == "Even" % % || Type == 1
                x = 8;
                y = 1;
                dum = " on Even";
                
            elseif Type == "Odd" % || Type == 2
                x = 8;
                y = 2;
                dum = " on Odd";
                
            elseif Type == "Red" % || Type == 3
                x = 8;
                y = 4;
                dum = " on Red";
                
            elseif Type == "Black" % || Type == 4
                x = 8;
                y = 5;
                dum = " on Black";
                
            elseif Type == "1to18" % || Type == 5
                x = 8;
                y = 7;
                dum = "1to18";
                
            elseif Type == "19to36" % || Type == 6
                x = 8;
                y = 8;
                dum = "19to36";
                
            elseif Type == "Dozen" % || Type == 7
                x = 8;
                Do = input('Which Dozen: 1: 1to12, 2: 13to24, 3: 25to36 ', 's');
                y = 9 + Do;
                l = ["1to12", "13to24", "25to36"];
                dum = strcat(" on ", l(Do));
                
            elseif Type == "Column" % || Type == 8
                disp([[1;2;3], vec]);
                Do = input('Which Dozen: ');
                y = 1;
                x = 2 * Do;
                l = ["1, 4, ..., 34", "2, 5, ..., 35", "3, 6, ..., 36"];
                dum = strcat(" on ", l(Do));
                
            elseif Type == "Single" % || Type == 9
                Do = input('Which single? [0, 36] ');
                if Do == 0
                    x = 4;
                    y = 2;
                else
                    x = 2 * mod(Do - 1, 3) + 2;
                    y = 2 * ceil(Do/3) + 2;
                end
                dum = strcat(" on ", num2str(Do));
                
            elseif Type == "Double" % || Type == 10
                x = 0;
                y = 0;
                while x == 0
                    disp(vec);
                    s = input('First number? ');
                    t = input('Sec ond number? ');
                    if abs(s - t) == 1
                        x = 2 * mod(min(s, t) - 1, 3) + 3;
                        y = 2 * ceil(s/3) + 2;
                        
                    elseif abs(s - t) == 3
                        x = 2 * mod(s - 1, 3) + 2;
                        y = 2 * ceil(min(s, t)/3) + 3;
                        
                    elseif (s == 0 && ismember(t, [1, 2, 3])) % || (t == 0 && ismember(s, [1, 2, 3]))
                        x = 2 * max(s, t);
                        y = 3;
                    end
                end
                dum = strcat(" on ", num2str(s), " and ", num2str(t));
                
            elseif Type == "Street" % || Type == 11
                disp([1:12; vec]);
                Do = input('Which Street? ');
                x = 1;
                y = 2 * Do + 2;
                l = ["1to3", "4to6", "7to9", "10to12", "13to15", "16to18", "19to21", "22to24", "25to27", "28to30", "31to33", "34to36"];
                dum = strcat(" on ", l(Do));
                
            elseif Type == "Double Street" % || Type == 12
                disp([1:12; vec]);
                Do = input('Which Double Street? (1:2, ..., 11:12) ');
                x = 1;
                y = 2 * Do(1) + 3;l = ["1to6", "4to9", "7to12", "10to15", "13to18", "16to21", "19to24", "22to27", "25to30", "28to33", "31to36"];
                dum = strcat(" on ", l(min(Do)));
                
            elseif Type == "Corner" % || Type == 13
                disp(vec);
                Do = input('Top Left ');
                x = 2 * mod(Do - 1, 3) + 3;
                y = 2 * ceil(Do/3) + 3;
                dum = strcat(" on ", num2str(Do), ", ", num2str(Do + 1), ", ", num2str(Do + 3), " and ", num2str(Do + 4));
                
            elseif Type == "Trio" % || Type == 14
                Do = input('Which trio: 1:[0, 1, 2], 2:[0, 2, 3] ');
                x = 1 + 2 * Do;
                y = 3;
                l = ["0, 1 and 2", "0, 2 and 3"];
                dum = strcat(" on ", l(Do));
                
            elseif Type == "First Four" % || Type == 1
                x = 1;
                y = 3;
                dum = " on 0, 1, 2 and 3";
            end
            
            v = input('How much? ');
            if Start - v < 0
                v = input('Sorry, you do not seem to have enough funds for this, how much would you like to bet?');
            end
            
            CurrBal = CurrBal - v;
            Bet(x, y) = v;
            
            Bets = strcat(Bets, ", £", num2str(v), dum);
            
            if CurrBal > 0
                t = input('Would you like to make another bet? (y or n) ', 's');
                if t == 'n'
                    h = 1;
                end
            end
        end
        
        disp(Bets);
        
        g = input('Are you happy with your bets? If n, then we will restart the bets. (y or n) ', 's');
    end
    
    disp("No more bets");
    
    pause(3);
    
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
        disp(strcat(num2str(r), " red!"));
    else
        disp(strcat(num2str(r), " black!"));
    end
    pause(3);
    End = CurrBal + sum(sum(Bet .* Roullette));
    disp(strcat("You received ", num2str(sum(sum(Bet .* Roullette))), " and now have ", num2str(End)));
end

