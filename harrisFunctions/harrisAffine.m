function affineinvpts = harrisAffine(img,scaleinvpts)
  %scaleinvpts = harrisLaplace(img);
  [h,w]=size(img);
  lenrc = length(scaleinvpts);
  affineinvpts = [];
  epsilon_c = 1;
  for i=1:lenrc
    loop = 0;
    %disp(i)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Step 1
    %% Initializing interest points
    xk = scaleinvpts(i,1:2); %row vector
    %% Initializing U-transformation matrix
    U_k = eye(2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %% Loop part begins here
    while epsilon_c > 0.05 || loop == 0
      %disp('In the loop...')
      if loop==0
        loop = 1; %First Run Complete
      end
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %% Step 2
      xw_kminus1 = round(transformBackward(xk,U_k)); %xw = [U^(-1)]x -> xw is the point in the transformed Image
      %% Transformed Image
      transformedImage = transformImageBackward(img,U_k);
      %% Transformed Image Dimensions
      [tH,tW] = size(transformedImage);
      %imshow(transformedImage)
      %% Selecting the transformed image domain window W(xw)
      if xw_kminus1(1)>2 && xw_kminus1(2)>2 && xw_kminus1(1)<tH-1 && xw_kminus1(2)<tW-1
        W = double(transformedImage(xw_kminus1(1)-2:xw_kminus1(1)+2,xw_kminus1(2)-2:xw_kminus1(2)+2));
        NA = 0;
      else
        NA=1;
        break
      end
      %% Normalizing the window
      if nnz(W==0)~=25 && nnz(W==0)<10
        W = windownormalize(W);
      else
        break
      end
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %% Step 3
      %disp('Step 3')
      %% Calculating Integration Scale
      si = intscaleselect(W);
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %% Step 4
      %disp('Step 4')
      %% Calculation of optimal s for calculating sigmaD by maximizing isotropic measure
      opts = optdiffscale(si,W);
      sd = opts*si;
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %% Step 5
      %disp('Step 5')
      %% Finding Spatial Localization
      xwk = round(spatialloc(xw_kminus1,si,sd,W));
      %% Calculating Displacement
      displacement = xwk-xw_kminus1;
      %% Displacement in Original image
      displacementOrig = transformForward(displacement,U_k);
      %% Calculating location of xk
      xk = xk + displacementOrig;
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %% Step 6
      %disp('Step 6')
      %% Calculation of window at xwk
      if xwk(1)>2 && xwk(2)>2 && xwk(1)<tH-1 && xwk(2)<tW-1
        W = transformedImage(xwk(1)-2:xwk(1)+2,xwk(2)-2:xwk(2)+2);
        NA = 0;
      else
        NA=1;
        break
      end
      %% calculation of the mu matrix
      mu_xwk = harrismeasure_xw(W,si,sd);
      %% Calculating root of mu matrix
      mu_i = sqrtm(mu_xwk);
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %% Step 7
      %disp('Step 7')
      %% Calculating U-transformation Matrix for next step
      U_k = mu_i\U_k;
      %% Normalizing maximum eigenvalue to 1
      [eigvec,eigval] = eig(U_k);
      eigval = eigval/max(max(eigval));
      U_k = (eigvec*eigval)/(eigvec);
      %% Making the last row of affine transformation matrix equal to zeros expect one in the the last column
      %U_k = U_k/U_k(9);
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      %% Step 8
      %% Checking Stopping criterion
      lambda_mu_i = eig(mu_i);
      epsilon_c = 1-min(lambda_mu_i)/max(lambda_mu_i);
    end
    if epsilon_c < 0.05 && NA==0
      %disp(i)
      ismemberpt = ismember(xk,affineinvpts);
      ismemberpt = ismemberpt(1) && ismemberpt(2);
      if ~ismemberpt
        affineinvpts = [affineinvpts;round(xk)];
      end
    end
  end
end
