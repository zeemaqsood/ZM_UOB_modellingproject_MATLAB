function m = get_board_num(board, n)
    powers = 3.^(0:n^2 - 1);
    m = sum(powers("x" == board)) + 2 * sum(powers("o" == board)) + 1;
end