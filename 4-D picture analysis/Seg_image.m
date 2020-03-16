function new_stack = Seg_image(stack, time_points)

T = length(time_points);
splits = [];
new_stack = zeros(size(stack, 1) - 6, size(stack, 2), size(stack, 3), T);

for t = 1:T
    old_split = splits(:, :, 1);
    
    image = time_points(t);
    
    objects = stack(:, :, :, image);
    objects(1:6, :, :) = [];
    
    seg = max(objects, [], 3);
    seg(seg ~= 0) = 1;
    
    se = strel('sphere', 5);
    se2 = strel('sphere', 10);
    
    seg = imdilate(seg, se);
    seg = imfill(padarray(padarray(seg, [1, 1], 255, 'pre'), [1, 0], 255, 'post'), 'holes'); seg = seg(2:end - 1, 2:end);
    seg = imfill(padarray(padarray(seg, [1, 0], 255, 'pre'), [1, 1], 255, 'post'), 'holes'); seg = seg(2:end - 1, 1:end - 1);
    seg = imdilate(imerode(seg, se2), se);
    
    distIm = -bwdist(~seg);
    splits = watershed(imimposemin(distIm, imextendedmin(distIm, 5)));
    splits(seg == 0) = 0;
    
    n = size(unique(splits), 1) - 1;
    
    if ~isempty(old_split)
        new_split = zeros(size(splits));
        
        for i = 1:n
            vec = unique(old_split(splits == i));
            vec(vec == 0) = [];
            
            if isempty(vec)
                m = m + 1;
                val = m;
                
            else
                vec1 = sum(transpose(vec) == old_split(splits == i), 1)/sum(sum(splits == i));
                vec = vec(vec1 > 0.5);
                vec1 = vec1(vec1 > 0.5);
                
                if isempty(vec1)
                    m = m + 1;
                    val = m;
                else
                    val = vec(find(vec1 == max(vec1), 1));
                end
            end
            
            new_split(splits == i) = val;
        end
        
        splits = new_split;
        
    else
        m = n;
    end
    
    splits = repmat(splits, 1, 1, size(objects, 3));
    
    objects(objects ~= 0) = splits(objects ~= 0);
        
    new_stack(:, :, :, t) = objects;
    
%     figure();
%     for i = 1:size(objects, 3)
%         subplot(4, 6, i);
%         imshow(objects(:, :, i), []);
%         
%         for j = 1:m
%             [x, y] = find(objects(:, :, i) == j, 1);
%             text(y, x, num2str(j), 'Color', 'r', 'FontSize', 10);
%         end
%     end
end
end