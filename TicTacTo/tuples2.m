function [answer, answer2] = tuples2(list, ntuple)
  
    if ntuple == 1
        answer = transpose(list);
        
    else
        answer = zeros(0, ntuple);
        answer2 = zeros(0, ntuple);
        
        for i = 1:size(list, 2)
            nmotuple = tuples2(list(list > list(i)), ntuple - 1);
            m = size(nmotuple, 1);
            answer = [answer; [list(i) * ones(m, 1), nmotuple]];
        end
    end

end