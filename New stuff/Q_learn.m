Q = ones(1, 3);

for i = 1:100
    r = rand;
    if r > 0.95
        r = rand;
        if r * 3 <= 1
            Tyre = 1;
        elseif r * 3 <= 2
            Tyre = 2;
        else
            Tyre = 3;
        end
    else
        r = rand;

        if r < Q(1)/sum(Q, 2)
            Tyre = 1;
        elseif r < (Q(1) + Q(2))/sum(Q, 2)
            Tyre = 2;
        else
            Tyre = 3;
        end
    end
    position = Racing(400, 3, 50, "Tyre", Tyre);
    Q(Tyre) = 0.1 * Q(Tyre) + 0.9 * (3 - position);
end
