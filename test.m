function [Rs, LRs] = test

global L maxR

T = 50;
L = 1000;
R = 104;
maxR = 4;
k = [0.00005, 0.05];


LR = zeros(L, 1);
LRs = zeros(L, T + 1) ;
Rs = [R, zeros(1, T)];

for t = 1:T
    [R, LR] = stoch(R, LR, LR, k);
    
    if mod(t, 1) == 0
        figure();
        Plot_LR;
    end
    
    LRs(:, t + 1) = LR;
    Rs(t + 1) = R;
end
end
% plot(min(1, k1 * (1.2 .^ (0:100))))
% plot(min(1, k1 * (16 .^ (0:8))))

