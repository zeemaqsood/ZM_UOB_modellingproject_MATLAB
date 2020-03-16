function volumes = calc_volumes(stack, time_points)

T = length(time_points);
new_stack = Seg_image(stack, time_points);
n = length(unique(new_stack)) - 1;

volumes = zeros(n + 1, T);
volumes(1, :) = time_points;


for t = 1:T
    for i = 1:n
        objects = new_stack(:, :, :, t);
        volumes(i + 1, t) = sum(objects(:) == i);
    end
end
end