function [answer, i, j] = check(board1, board2, n)

j = 0;
answer = false;
vec = zeros(1, n^2);
for k = 1:n
    vec((k - 1) * n + 1:k * n) = n - k + 1:n:n^2;
end

vec1 = zeros(1, n^2);
for k = 1:n
    vec1((k - 1) * n + 1:k * n) = k:n:n^2;
end

while j < 2
    i = 0;
    
    while i < 4
        if all(all(board1 == board2))
            answer = true;
            return;
        end
        
        board2(:) = board2(vec);
        
        i = i + 1;
    end
    
    board2 = board2(vec1);
    j = j + 1;
end

end