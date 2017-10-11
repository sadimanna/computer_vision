function scaleinvpts = harrisLaplaceNew(img)
    sig0 = 1.5;
    scaleFactor = 1.2;
    s = 0.7;
    scaleinvpts = zeros(1,3);
    imageScaleSpace = [];
    interestPoints = {};
    %% Creating the scale space and subsequenbt detection of interest points at the scale 
    for n = 1:7
        sigi = sig0*scaleFactor^n;
        sigd = s*sigi;
        %g = fspecial('gaussian',[5 5],sigi);
        scaledImage = imgaussfilt(img,sigi,'Filtersize',2*ceil(3*sigi)+1);
        imageScaleSpace(:,:,n) = scaledImage;
        threshold = 5e2;
        scaledInterestPoints = harrisInterestPoints(img,sigi,sigd,threshold)
        interestPoints{n} = scaledInterestPoints;
        %figure 
        %imshow(scaledImage) 
        %hold on
        %plot(scaledInterestPoints(:,2),scaledInterestPoints(:,1),'gs')
    end
    %% Convolving LoG kernels with Image Scale Space
    imgLoG = [];
    for n=1:7
        sigI= sig0*scaleFactor^n;
        LoG = fspecial('log',[5 5],sigI);
        imgLoG(:,:,n) = (sigI^2)*imfilter(img,LoG,'replicate','conv');
    end
    %% Dectecting LoG Maxima
    for n=2:6
        interestPts = interestPoints{n};
        npts = size(interestPts,1);
        for p=1:npts
            r = interestPts(p,1);
            c= interestPts(p,2);
            sigi = sig0*scaleFactor^n;
            LoGval = imgLoG(r,c,n);
            if LoGval > imgLoG(r,c,n-1) && LoGval > imgLoG(r,c,n+1)
                scaleinvpts = [scaleinvpts;r,c,sigi];
            end
        end
    end
end
