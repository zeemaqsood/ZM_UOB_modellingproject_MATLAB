function grid = Draw(S)

grid = zeros(3, max(S.TrackPos));
grid(3, 41:end) = NaN;

for i = 1:length(S.TrackPos)
    grid(S.RacingLine(i), S.TrackPos(i)) = i;
end

end