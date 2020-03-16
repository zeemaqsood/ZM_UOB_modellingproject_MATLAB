function [finish, winner] = is_finished(board, n)
    if ismember(n, sum(board == "o", 1)) || ismember(n, sum(board == "o", 2)) || sum("o" == board(1:n + 1:n^2), 2) == n || sum("o" == board(n:n - 1:n^2 - n + 1), 2) == n
        finish = true;
        winner = "o";
        
    elseif ismember(n, sum(board == "x", 1)) || ismember(n, sum(board == "x", 2)) || sum("x" == board(1:n + 1:n^2), 2) == n || sum("x" == board(n:n - 1:n^2 - n + 1), 2) == n
        finish = true;
        winner = "x";
        
    elseif sum(sum(board == "")) == 0
        finish = true;
        winner = "";
        
    else
        finish = false;
        winner = "";
    end
end