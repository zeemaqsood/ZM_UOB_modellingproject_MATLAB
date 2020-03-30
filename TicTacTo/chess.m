function chess

board = strings(8);
board(2, :) = "P";
board(1, [1, 8]) = "R";
board(1, [2, 7]) = "KN";
board(1, [3, 6]) = "B";
board(1, 4) = "Q";
board(1, 5) = "K";
board(7, :) = "p";
board(8, [1, 8]) = "r";
board(8, [2, 7]) = "kn";
board(8, [3, 6]) = "b";
board(8, 4) = "q";
board(8, 5) = "k";
Make_Board(board);

go = 1;

while true
    t = true;
    while t
        position = input('From: ', 's');
        new_position = input('To: ', 's');
        
        if length(position) == 2 && length(new_position) == 2 && ...
                all(ismember([position(1), new_position(1)], char(65:72))) && ...
                str2double(position(2)) <= 8 && str2double(position(2)) >= 1 && ...
                str2double(new_position(2)) <= 8 && str2double(new_position(2)) >= 1 && ...
                board(9 - str2double(position(2)), find(position(1) == char(65:72), 1)) ~= "" && ...
                isstrprop(board(9 - str2double(position(2)), find(position(1) == char(65:72), 1)), "lower") == go
            [board, turn] = moves(board, position, new_position);
            t = ~turn;
            
        else
            disp('You chose invalid co-ordinates, please try again');
        end
    end
    
    
    go = abs(go - 1);
end
end