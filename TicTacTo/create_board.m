function board = create_board(m, n)
    powers = 3.^(0:n^2 - 1);
    test = floor(mod((m - 1)./powers, 3));
    board = strings(1, n^2);
    board(test == 1) = "x";
    board(test == 2) = "o";
end