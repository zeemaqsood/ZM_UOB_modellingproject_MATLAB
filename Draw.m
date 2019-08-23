function draw = Draw(Test, n)

Test(Test(:, 1) == 0) = n;
draw = zeros(4, max(Test(:, 1)));
draw(4, 41:end) = NaN;

draw(4 * (Test(:, 1) - 1) + Test(:, 2)) = Test(:, 3);

end