function x = one_off(board, i)
    j = mod(i, 2) + 1;
    turns = ["x", "o"];

    if ismember(2, sum([sum(board == turns(i), 1); -sum(board == turns(j), 1)], 1))
        [~, z] = ismember(2, sum([sum(board == turns(i), 1); -sum(board == turns(j))], 1));
        y = find(board(:, z) == "");
        x = (z - 1) * 3 + y;
        
    elseif ismember(2, sum([sum(board == turns(i), 2), -sum(board == turns(j), 2)], 2))
        [~, y] = ismember(2, sum([sum(board == turns(i), 2), -sum(board == turns(j), 2)], 2));
        z = find(board(y, :) == "");
        x = (z - 1) * 3 + y;
        
    elseif all(sum([turns(i); turns(j)] == [board(1, 1), board(2, 2), board(3, 3)], 2) == [2; 0])
        [~, y] = ismember("", [board(1, 1), board(2, 2), board(3, 3)]);
        x = 4 * y - 3;
        
    elseif all(sum([turns(i); turns(j)] == [board(3, 1), board(2, 2), board(1, 3)], 2) == [2; 0])
        [~, y] = ismember("", [board(3, 1), board(2, 2), board(1, 3)]);
        x = 2 * y + 1;
        
    else
        if ismember(2, sum([sum(board == turns(j), 1); -sum(board == turns(i), 1)], 1))
            [~, z] = ismember(2, sum([sum(board == turns(j), 1); -sum(board == turns(i))], 1));
            y = find(board(:, z) == "");
            x = (z - 1) * 3 + y;

        elseif ismember(2, sum([sum(board == turns(j), 2), -sum(board == turns(i), 2)], 2))
            [~, y] = ismember(2, sum([sum(board == turns(j), 2), -sum(board == turns(i), 2)], 2));
            z = find(board(y, :) == "");
            x = (z - 1) * 3 + y;

        elseif all(sum([turns(j); turns(i)] == [board(1, 1), board(2, 2), board(3, 3)], 2) == [2; 0])
            [~, y] = ismember("", [board(1, 1), board(2, 2), board(3, 3)]);
            x = 4 * y - 3;

        elseif all(sum([turns(j); turns(i)] == [board(3, 1), board(2, 2), board(1, 3)], 2) == [2; 0])
            [~, y] = ismember("", [board(3, 1), board(2, 2), board(1, 3)]);
            x = 2 * y + 1;
            
        else
            x = 0;
        end
    end
end