function scaleinvpts = harrisLaplace(img)
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
        g = fspecial('gaussian',[5 5],sigi);
        scaledImage = uint8(conv2(img,g,'same'));
        imageScaleSpace(:,:,n) = scaledImage;
        threshold = 1e3;
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
        pts = zeros(npts,3);
        for p=1:npts
            r = interestPts(p,1);
            c= interestPts(p,2);
            sigi = sig0*scaleFactor^n;
            LoGval = imgLoG(r,c,n);
            if LoGval > imgLoG(r,c,n-1) && LoGval > imgLoG(r,c,n+1)
                scaleinvpts = [scaleinvpts;r,c,sigi];
            end
        end
%         %% Image planes at three scales 
%         imagePlane = imageScaleSpace(:,:,n); %Image Plane
%         imagePlanenm1 = imageScaleSpace(:,:,n-1); %Lower image Plane
%         imagePlanenp1 = imageScaleSpace(:,:,n+1); % Upper image plane
%         %[h,w] = size(scaledImage);
%         %% Interest points
%         points = interestPoints{n}; %interest points in the image plane at the scale sigI
%         npts = length(points); %number of points detected
%         %% Scales
%         sigI = sig0*scaleFactor^n; % scale
%         %% LoG of images
%         imagePlaneLoG = imgLoG(:,:,n); % Laplace of gaussian at scale sigI
%         imagePlaneLoGnm1 = imgLoG(:,:,n-1); % LoG at lower scale 
%         imagePlaneLoGnp1 = imgLoG(:,:,n+1); % loG at upper scale
%         %% Checking for LoG maxima
%         for i = 1:npts
%             x = points(i,:);
%             if imagePlaneLoG(x(1),x(2)) > imagePlaneLoGnm1(x(1),x(2)) && imagePlaneLoG(x(1),x(2)) > imagePlaneLoGnp1(x(1),x(2))
%                 scaleinvpts = [scaleinvpts;x(1),x(2),sigI];
%             end
%         end
    end
end
