function merge_image_plot()
impath = '/Users/karanjitcheema/Desktop/new_view1_track';
plotpath = '/Users/karanjitcheema/Desktop/reunion_dist1';
savepath = '/Users/karanjitcheema/Desktop/reunion_trackplot1';

for i=1:1618
%     i
    im = imread(fullfile(impath,num2str(i,'%d.png')));
    pl = imread(fullfile(plotpath,num2str(i,'%d.png')));
    
    pl = imresize(pl,[300 size(im,2)]);
    
    imwrite([im;pl],fullfile(savepath,num2str(i,'%d.jpg')),'Quality',90);
end