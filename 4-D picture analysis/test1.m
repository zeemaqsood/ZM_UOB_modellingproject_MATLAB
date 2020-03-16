folder = uigetdir("\\its-rds\rdsprojects\p\pikeja-turing-study-group\Sean\Ilastik");
list = dir(folder);
numFiles = size(list, 1);

j = 1;
numImages = 0;
while numImages == 0 && j <= numFiles
    file = list(j).name;
    
    if endsWith(file, 'SimpSegS2.tif')
        info = imfinfo([folder, '\', file]);
        numImages = size(info, 1);
        height = info.Height;
        width = info.Width;
        
        stack = zeros(height, width, numImages, numFiles);
        
        for i1 = 1:numImages
            stack(:, :, i1, 1) = imread([folder, '\', file], i1);
        end
        k = 2;
    end
    
    j = j + 1;
end

for i = j:size(list, 1)
    disp(i);
    file = list(i).name;
    if endsWith(file, 'SimpSegS2.tif')
        for i1 = 1:numImages
            stack(:, :, i1, k) = imread([folder, '\', file], i1);
        end
        k = k + 1;
    end
end

stack(:, :, :, k:end) = [];

saves = ['save ', folder, '\MatlabTest.mat', blanks(10*k - 1)];
n = length(['save ', folder, '\MatlabTest.mat']);

for i = 1:k - 1
    name = ['Stack_', num2str(i, '%03.f')];
    eval([name, ' = stack(:, :, :, i);']);
    saves(n + (i - 1) * 10 + 2:n + 10 * i) = name;
end

eval(saves);
