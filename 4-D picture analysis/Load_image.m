function stack = Load_image

folder = uigetdir("\\its-rds\rdsprojects\p\pikeja-turing-study-group\Sean\Ilastik");
list = dir(folder);
numFiles = size(list, 1);

i = numFiles;
listnames = [list.name];
t = true;

while i > 0 && ~contains(listnames, num2str(i, '%03.f'))
    i = i - 1;
end

numFiles = i;

i = 1;

while i < numFiles && ~contains(list(i).name, 'SimpSegS2.tif')
    i = i + 1;
end

StartIndex = i;

info = imfinfo([folder, '\', list(StartIndex).name]);
numImages = size(info, 1);
height = info.Height;
width = info.Width;

Images = input(['Time points youd like to load, between 1 and ', num2str(numFiles), ': ']) + StartIndex - 1;
numStacks = size(Images, 2);

stack = zeros(height, width, numImages, numStacks);

for i = 1:numStacks
    disp(i);
    file = list(Images(i)).name;
    
    for j = 1:numImages
        stack(:, :, j, i) = imread([folder, '\', file], j);
    end
end
end
