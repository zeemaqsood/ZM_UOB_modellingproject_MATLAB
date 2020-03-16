function test = checkplace(board, n)

test = zeros(n);
test(:) = 1:n^2;
test(board ~= "") = 0;
v = test(test ~= 0);
i = 1;

while i < size(v, 1)
    board1 = board;
    board1(v(i)) = "t";
    j = i + 1;
    
    while j <= size(v, 1)
        board2 = board;
        board2(v(j)) = "t";
        
        checks = check(board1, board2, n);
        
        if checks
            test(v(j)) = v(i);
            v(j) = [];
            
        else
            j = j + 1;
        end
    end
    i = i + 1;
end

end