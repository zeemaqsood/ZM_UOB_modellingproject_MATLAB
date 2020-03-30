function [Board, turn] = moves(Board, position, new_position)
turn = true;

pos(2) = find(char(65:72) == position(1), 1);
pos(1) = 9 - str2double(position(2));
new_pos(2) = find(char(65:72) == new_position(1), 1);
new_pos(1) = 9 - str2double(new_position(2));

piece = Board(pos(1), pos(2));

up = new_pos(1) - pos(1);
right = new_pos(2) - pos(2);

if (up == 0 && right == 0) || piece == ""
    disp("Not a valid move");
    
elseif upper(piece) == "P"
    if piece == "P"
        if pos(1) == 2 && up == 2 && right == 0 && all(Board([3, 4], pos(2)) == "")
            Board(4, pos(2)) = "P";
            Board(2, pos(2)) = "";
            
        elseif up == 1 && right == 0 && Board(new_pos(1), new_pos(2)) == ""
            Board(pos(1), pos(2)) = "";
            if new_pos(2) == 8
                Board(new_pos(1), new_pos(2)) = "Q";
            else
                Board(new_pos(1), new_pos(2)) = "P";
            end
            
        elseif up == 1 && abs(right) == 1 && Board(new_pos(1), new_pos(2)) ~= "" && isstrprop(Board(new_pos(1), new_pos(2)), "Lower")
            Board(pos(1), pos(2)) = "";
            if new_pos(2) == 8
                Board(new_pos(1), new_pos(2)) = "Q";
            else
                Board(new_pos(1), new_pos(2)) = "P";
            end
            
        else
            turn = false;
            disp("Not a valid move");
        end
        
    else
        if pos(1) == 7 && up == -2 && right == 0 && all(Board([3, 4], pos(2)) == "")
            Board(5, pos(2)) = "p";
            Board(7, pos(2)) = "";
            
        elseif up == -1 && right == 0 && Board(new_pos(1), new_pos(2)) == ""
            Board(pos(1), pos(2)) = "";
            if new_pos(2) == 1
                Board(new_pos(1), new_pos(2)) = "q";
            else
                Board(new_pos(1), new_pos(2)) = "p";
            end
            
        elseif up == -1 && abs(right) == 1 && Board(new_pos(1), new_pos(2)) ~= "" && isstrprop(Board(new_pos(1), new_pos(2)), "Upper")
            Board(pos(1), pos(2)) = "";
            
            if new_pos(2) == 1
                Board(new_pos(1), new_pos(2)) = "q";
            else
                Board(new_pos(1), new_pos(2)) = "p";
            end
        else
            disp("Not a valid move");
            turn = false;
        end
    end
    
elseif upper(piece) == "R" && ...
        (right == 0 || up == 0) && ...
        all(Board(pos(1) + 1 * sign(up):1 + 2 * floor(sign(up)/2):new_pos(1) - 1 * sign(up), pos(2) + 1 * sign(right):1 + 2 * floor(sign(right)/2):new_pos(2) - 1 * sign(right)) == "") && ...
        (Board(new_pos(1), new_pos(2)) == "" || (isstrprop(piece, 'upper') == isstrprop(Board(new_pos(1), new_pos(2)), 'lower')))
    
    Board(pos(1), pos(2)) = "";
    Board(new_pos(1), new_pos(2)) = piece;
    
elseif upper(piece) == "KN" && ...
        ((abs(up) == 1 && abs(right) == 2) || (abs(up) == 2 && abs(right) == 1)) && ...
        (Board(new_pos(1), new_pos(2)) == "" || (isstrprop(piece, 'upper') == isstrprop(Board(new_pos(1), new_pos(2)), 'lower')))
    
    Board(pos(1), pos(2)) = "";
    Board(new_pos(1), new_pos(2)) = piece;  
elseif upper(piece) == "B" && ...
        abs(up) == abs(right) && ...
        all(Board((pos(2) - 1) * 8 + pos(1) + (1:abs(up) - 1) * sign(right) * (8 + sign(right) *  sign(up))) == "") && ...
        (Board(new_pos(1), new_pos(2)) == "" || (isstrprop(piece, 'upper') == isstrprop(Board(new_pos(1), new_pos(2)), 'lower')))
    
    Board(pos(1), pos(2)) = "";
    Board(new_pos(1), new_pos(2)) = piece;
    
elseif upper(piece) == "Q" && ...
        ((abs(up) == abs(right) && ...
          all(Board((pos(2) - 1) * 8 + pos(1) + (1:abs(up) - 1) * sign(right) * (8 + sign(right) * sign(up))) == "")) || ...
        ((right == 0 || up == 0) && ...
         all(Board(pos(1) + 1 * sign(up):1 + 2 * floor(sign(up)/2):new_pos(1) - 1 * sign(up), pos(2) + 1 * sign(right):1 + 2 * floor(sign(right)/2):new_pos(2) - 1 * sign(right)) == ""))) && ...
        (Board(new_pos(1), new_pos(2)) == "" || (isstrprop(piece, 'upper') == isstrprop(Board(new_pos(1), new_pos(2)), 'lower')))
    
    Board(pos(1), pos(2)) = "";
    Board(new_pos(1), new_pos(2)) = piece;
     
elseif upper(piece) == "K" && ...
        abs(up) <= 1 && abs(right) <= 1 && ...
        (Board(new_pos(1), new_pos(2)) == "" || (isstrprop(piece, 'upper') == isstrprop(Board(new_pos(1), new_pos(2)), 'lower')))
    
    Board(pos(1), pos(2)) = "";
    Board(new_pos(1), new_pos(2)) = piece;
else
    disp("Not a valid move");
    turn = false;
end

Make_Board(Board);
end