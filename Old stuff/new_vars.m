function new_Vars = new_vars(Vars)

new_Vars = cell(size(Vars, 1), 1);

for i = 1:size(Vars, 1)
    v = [0, strfind(Vars{i}, '_'), size(Vars{i}, 2) + 1];
    dum = cell(2, size(v, 2) - 1);
    new_Vars{i} = '';
    
    for j = 1:size(v, 2) - 1
        k = floor((v(j + 1) - v(j) - 1)/2);
        
        while k >= 1
            a = length(strfind(Vars{i}(v(j) + 1:v(j + 1) - 1), Vars{i}(v(j) + 1:v(j) + k)));
            
            if a * k == v(j + 1) - v(j) - 1
                dum{1, j} = Vars{i}(v(j) + 1:v(j) + k);
                dum{2, j} = a;
                k = -1;
                
            else
                k = k - 1;
            end
        end
        
        if k == 0
            dum{1, j} = Vars{i}(v(j) + 1:v(j + 1) - 1);
            dum{2, j} = 1;
        end
        
        for k = 1:size(dum{1, j}, 2)
            if ~isnan(str2double(dum{1, j}(k)))
                new_Vars{i} = strcat(new_Vars{i}, '^{', num2str(dum{1, j}(k)), '}');
            else
                new_Vars{i} = strcat(new_Vars{i}, dum{1, j}(k));
            end
        end
        
        if dum{2, j} > 1
            new_Vars{i} = strcat(new_Vars{i}, '_{', num2str(dum{2, j}), '}');
        end
    end
end

