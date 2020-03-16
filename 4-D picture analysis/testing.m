function calc_areas(time_points)

for i = 1:length(time_points)
    image = 2;
    
    objects = stack(:, :, :, image);
    objects(1:6, :, :) = [];
    
    seg = max(objects, [], 3);
    
    seg = imfill(padarray(padarray(seg, [1, 1], 255, 'pre'), [1, 0], 255, 'post'), 'holes'); seg = seg(2:end - 1, 2:end);
    seg = imfill(padarray(padarray(seg, [1, 0], 255, 'pre'), [1, 1], 255, 'post'), 'holes'); seg = seg(2:end - 1, 1:end - 1);
    se = strel('sphere', 4);
    seg = imdilate(imerode(seg, se), se);
    [seg, ~] = bwlabeln(seg, 8);
    
    distIm = - bwdist(~seg);
    split = watershed(imimposemin(distIm, imextendedmin(distIm, 2)));
    split(seg == 0) = 0;
    n = size(unique(split), 1);
    
    split = repmat(split, 1, 1, size(objects, 3));
    
    objects(objects ~= 0) = split(objects ~= 0);
    
    areas = zeros(n, 1);
    
    for i = 1:n
        areas(i) = sum(sum(sum(objects == i)));
    end
    
    figure();
    for i = 1:size(objects, 3)
        subplot(4, 6, i);
        imshow(objects(:, :, i), []);
        
        for j = 1:n
            [x, y] = find(objects(:, :, i) == j, 1);
            text(y, x, num2str(j), 'Color', 'r', 'FontSize', 10);
        end
    end
end
end