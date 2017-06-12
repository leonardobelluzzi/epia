function M = LBP(localimg)

disp(localimg);
RGB = imread(localimg);
I = rgb2gray(RGB);

corners = extractLBPFeatures(I);

M = corners';
end

