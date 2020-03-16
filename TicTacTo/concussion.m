function [ps, c] = concussion(M, data)

N = size(data, 2) - 1;
S = zeros(size(data, 1), N + M + 2);
S(:, 1:N + 1) = data;

M = min(N, M);
ps = zeros(M, 3);
c = zeros(M, 1);
vars = 1:N;

for i = 1:M
    d = corr(S(:, vars), S(:, N + i));
    
    s = find(d == max(d), 1);
    m = vars(s);
    vars(s) = [];
    c(i) = max(d);
    
    figure();
    plot(S(:, m), S(:, N + i), 'x');
    hold on;
    ps(i, :) = [m, polyfit(S(:, m), S(:, N + i), 1)];
    fplot(@(x) ps(i, 2) * x + ps(i, 3));
    hold off;

    S(:, N + i + 1) = S(:, N + 1) - ps(i, 3) - ps(i, 2) * S(:, m);
    S(:, N + M + 2) = S(:, N + M + 2) + ps(i, 3) + ps(i, 2) * S(:, m);
end

figure();
plot(S(:, N + 1), S(:, N + M + 2), 'x');
hold on;
fplot(@(x) x);
hold off;

end


