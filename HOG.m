function M = HOG(img, tamQuadro)
    [hog1,visualization] = extractHOGFeatures(img,'CellSize',[tamQuadro tamQuadro],'BlockSize', [2 2], 'NumBins', 9);

     %subplot(1,2,1);
     %imshow(img);
     %subplot(1,2,2);
     %plot(visualization);

    M=hog1';
end