function Make_Board(board)

Ws_Wpawn = imread('Pictures/Pawn.jpg');
Ws_Wpawn(Ws_Wpawn < 127) = 0;
Ws_Wpawn(Ws_Wpawn >= 127) = 255;
Ws_Bpawn = imcomplement(imfill(imcomplement(Ws_Wpawn), 6));
Gs_Bpawn = Ws_Bpawn;
Gs_Bpawn(Gs_Bpawn == 255) = 127;
Gs_Wpawn = Ws_Wpawn;
Gs_Wpawn(Ws_Bpawn == 255) = 127;
pawn = zeros(30, 30, 2, 2, 'like', Ws_Wpawn);
pawn(:, :, 1, 1) = imresize(Ws_Wpawn, 30/size(Ws_Wpawn, 1));
pawn(:, :, 1, 2) = imresize(Gs_Wpawn, 30/size(Gs_Wpawn, 1));
pawn(:, :, 2, 1) = imresize(Ws_Bpawn, 30/size(Ws_Bpawn, 1));
pawn(:, :, 2, 2) = imresize(Gs_Bpawn, 30/size(Gs_Bpawn, 1));

Ws_Wrook = imread('Pictures/Rook.jpg');
Ws_Wrook(Ws_Wrook < 127) = 0;
Ws_Wrook(Ws_Wrook >= 127) = 255;
Ws_Brook = imcomplement(imfill(imcomplement(Ws_Wrook), 6));
Gs_Brook = Ws_Brook;
Gs_Brook(Gs_Brook == 255) = 127;
Gs_Wrook = Ws_Wrook;
Gs_Wrook(Ws_Brook == 255) = 127;
rook = zeros(30, 30, 2, 2, 'like', Ws_Wrook);
rook(:, :, 1, 1) = imresize(Ws_Wrook, 30/size(Ws_Wrook, 1));
rook(:, :, 1, 2) = imresize(Gs_Wrook, 30/size(Gs_Wrook, 1));
rook(:, :, 2, 1) = imresize(Ws_Brook, 30/size(Ws_Brook, 1));
rook(:, :, 2, 2) = imresize(Gs_Brook, 30/size(Gs_Brook, 1));

Ws_Wbishop = imread('Pictures/Bishop.jpg');
Ws_Wbishop(Ws_Wbishop < 127) = 0;
Ws_Wbishop(Ws_Wbishop >= 127) = 255;
Ws_Bbishop = imcomplement(imfill(imcomplement(Ws_Wbishop), 6));
Gs_Bbishop = Ws_Bbishop;
Gs_Bbishop(Gs_Bbishop == 255) = 127;
Gs_Wbishop = Ws_Wbishop;
Gs_Wbishop(Ws_Bbishop == 255) = 127;
bishop = zeros(30, 30, 2, 2, 'like', Ws_Wbishop);
bishop(:, :, 1, 1) = imresize(Ws_Wbishop, 30/size(Ws_Wbishop, 1));
bishop(:, :, 1, 2) = imresize(Gs_Wbishop, 30/size(Gs_Wbishop, 1));
bishop(:, :, 2, 1) = imresize(Ws_Bbishop, 30/size(Ws_Bbishop, 1));
bishop(:, :, 2, 2) = imresize(Gs_Bbishop, 30/size(Gs_Bbishop, 1));

Ws_Wknight = rgb2gray(imread('Pictures/Knight.jpg'));
Ws_Wknight(Ws_Wknight < 127) = 0;
Ws_Wknight(Ws_Wknight >= 127) = 255;
Ws_Bknight = imcomplement(imfill(imcomplement(Ws_Wknight), 6));
Gs_Bknight = Ws_Bknight;
Gs_Bknight(Gs_Bknight == 255) = 127;
Gs_Wknight = Ws_Wknight;
Gs_Wknight(Ws_Bknight == 255) = 127;
knight = zeros(30, 30, 2, 2, 'like', Ws_Wknight);
knight(:, :, 1, 1) = imresize(Ws_Wknight, 30/size(Ws_Wknight, 2));
knight(:, :, 1, 2) = imresize(Gs_Wknight, 30/size(Gs_Wknight, 2));
knight(:, :, 2, 1) = imresize(Ws_Bknight, 30/size(Ws_Bknight, 2));
knight(:, :, 2, 2) = imresize(Gs_Bknight, 30/size(Gs_Bknight, 2));

Ws_Wqueen = imread('Pictures/Queen.jpg');
Ws_Wqueen(Ws_Wqueen < 127) = 0;
Ws_Wqueen(Ws_Wqueen >= 127) = 255;
Ws_Bqueen = imcomplement(imfill(imcomplement(Ws_Wqueen), 6));
Gs_Bqueen = Ws_Bqueen;
Gs_Bqueen(Gs_Bqueen == 255) = 127;
Gs_Wqueen = Ws_Wqueen;
Gs_Wqueen(Ws_Bqueen == 255) = 127;
queen = zeros(30, 30, 2, 2, 'like', Ws_Wqueen);
queen(:, :, 1, 1) = imresize(Ws_Wqueen, 30/size(Ws_Wqueen, 1));
queen(:, :, 1, 2) = imresize(Gs_Wqueen, 30/size(Gs_Wqueen, 1));
queen(:, :, 2, 1) = imresize(Ws_Bqueen, 30/size(Ws_Bqueen, 1));
queen(:, :, 2, 2) = imresize(Gs_Bqueen, 30/size(Gs_Bqueen, 1));

Ws_Wking = imread('Pictures/King.jpg');
Ws_Wking(Ws_Wking < 127) = 0;
Ws_Wking(Ws_Wking >= 127) = 255;
Ws_Bking = imcomplement(imfill(imcomplement(Ws_Wking), 6));
Gs_Bking = Ws_Bking;
Gs_Bking(Gs_Bking == 255) = 127;
Gs_Wking = Ws_Wking;
Gs_Wking(Ws_Bking == 255) = 127;
king = zeros(30, 30, 2, 2, 'like', Ws_Wking);
king(:, :, 1, 1) = imresize(Ws_Wking, 30/size(Ws_Wking, 1));
king(:, :, 1, 2) = imresize(Gs_Wking, 30/size(Gs_Wking, 1));
king(:, :, 2, 1) = imresize(Ws_Bking, 30/size(Ws_Bking, 1));
king(:, :, 2, 2) = imresize(Gs_Bking, 30/size(Gs_Bking, 1));

board_pic = zeros(240, 240, 'like', Ws_Wpawn);
for i = 1:8
    for j = 1:8
        if upper(board(i, j)) == "P"
            board_pic(30 * (i - 1) + 1:30 * i, 30 * (j - 1) + 1:30 * j) = pawn(:, :, 1 + isstrprop(board(i, j), 'upper'), 2 - (mod(i, 2) == mod(j, 2)));
        elseif upper(board(i, j)) == "R"
            board_pic(30 * (i - 1) + 1:30 * i, 30 * (j - 1) + 1:30 * j) = rook(:, :, 1 + isstrprop(board(i, j), 'upper'), 2 - (mod(i, 2) == mod(j, 2)));
        elseif upper(board(i, j)) == "B"
            board_pic(30 * (i - 1) + 1:30 * i, 30 * (j - 1) + 1:30 * j) = bishop(:, :, 1 + isstrprop(board(i, j), 'upper'), 2 - (mod(i, 2) == mod(j, 2)));
        elseif upper(board(i, j)) == "KN"
            board_pic(30 * (i - 1) + 1:30 * i, 30 * (j - 1) + 1:30 * j) = knight(:, :, 1 + all(isstrprop(board(i, j), 'upper')), 2 - (mod(i, 2) == mod(j, 2)));
        elseif upper(board(i, j)) == "Q"
            board_pic(30 * (i - 1) + 1:30 * i, 30 * (j - 1) + 1:30 * j) = queen(:, :, 1 + isstrprop(board(i, j), 'upper'), 2 - (mod(i, 2) == mod(j, 2)));
        elseif upper(board(i, j)) == "K"
            board_pic(30 * (i - 1) + 1:30 * i, 30 * (j - 1) + 1:30 * j) = king(:, :, 1 + isstrprop(board(i, j), 'upper'), 2 - (mod(i, 2) == mod(j, 2)));
        else
            board_pic(30 * (i - 1) + 1:30 * i, 30 * (j - 1) + 1:30 * j) = 128 * (mod(i, 2) == mod(j, 2)) + 127;
        end
    end
end

imshow(board_pic);
for i = 1:8
    text(30 * i - 15, 0, char(64 + i), 'fontsize', 20, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    text(-5, 30 * i - 15, num2str(9 - i), 'fontsize', 20, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'middle');
end

end

