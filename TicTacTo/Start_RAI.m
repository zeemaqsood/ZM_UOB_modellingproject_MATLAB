function Start_RAI
global Q Q_new alpha gamma

alpha = 0.2;
gamma = 0.2;

Q = zeros(12, 8, 100);
Q(1, :, :) = [NaN, 2, 3, 6, 9, 12, 18, 36] .* ones(1, 8, 100);
Q(2:end, 1, :) = transpose(0:0.1:1) .* ones(11, 1, 100);
Q(3:end, 2:end, 11) = 8;
Q(2, 2:end, 11) = [8, zeros(1, 6)];
Q_new = Q;
runs = 100000000;
rewards = [1:runs;
           zeros(1, runs)];
       
       score = zeros(runs/100000, 2);

for i = 1:runs    
    rewards(2, i) = Roullette_AI(8);
    
    if mod(i, 100000) == 0
        disp(i/runs);
        score(i/10000, :) = [i/100000, mean(rewards(2, i - 9999:i))];
        Q_new = Q;
    end
end


end