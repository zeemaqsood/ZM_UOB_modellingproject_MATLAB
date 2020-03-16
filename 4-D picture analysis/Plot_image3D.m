function Plot_image3D(stack, m, n)
figure();

for i = 1:size(stack, 3)
    subplot(m, n, i);
    imshow(stack(:, :, i));
end
end