function affineinvpts = harris_affine_rev(img)
  scaleinvpts = harris_laplace(img);
  lenrc = length(scaleinvpts);
  s = 0.6;
  for i=1:lenrc
    %%Initializing interest points
    x0 = scaleinvpts(i,1:2);
    x0 = x0';
    %%Initializing U-transformation matrix
    U0 = eye(2);
    %si0 = scaleinvpts(i,3);
    %sd0 = s*si0;
    %%Calculating the co-ordinates in the transformed Image domain
    xw0 = inv(U)*x0;
    %%Selecting the transformed image domain window W(xw)
    W0 = img(xw(1)-2:xw(1)+2,xw(2)-2:xw(2)+2);
    %%Normalizing the window
    W0 = windownormalize(W);
    %%Calculating Integration Scale
    si = intscaleselect(W0);
    %%Calculation of optimal s for calculating sigmaD by maximizing isotropic measure
    opts = optdiffscale(si,W0);
    sd = opts*si;
    %%Finding Spatial Localization
    xwk = spatialloc(xw,si,sd,W0);
    %%Calculating Displacement
    displacement = xw-xwk;
    %%Calculating location of xk
    xk = x + U0*(displacement);
    %%Calculation of mu matrix at xwk
    W0 = img(xwk(1)-2:xwk(1)+2,xwk(2)-2:xwk(2)+2);
    mu_xwk = harrismeasure(W0,si,sd);
    %%Calculating root of mu matrix
    mu_i = inv(sqrtm(mu_xwk));
    %%Calculating U-transformation Matrix for next step
    U_k = mu_i*U0;
    %%Normalizing maximum eigenvalue to 1
    U_k = U_k/max(eig(U_k));
    %%Checking Stopping criterion
    lambda_mu_i = eig(mu_i);
    epsilon_c = 1-min(lambda_mu_i)/max(lambda_mu_i);
    while epsilon_c > 0.05
      xw = inv(U_k)*xk;
      %%Selecting the transformed image domain window W(xw)
      W0 = img(xw(1)-2:xw(1)+2,xw(2)-2:xw(2)+2);
      %%Normalizing the window
      W0 = windownormalize(W);
      %%Calculating Integration Scale
      si = intscaleselect(W0);
      %%Calculation of optimal s for calculating sigmaD by maximizing isotropic measure
      opts = optdiffscale(si,W0);
      sd = opts*si;
      %%Finding Spatial Localization
      xwk = spatialloc(xw,si,sd,W0);
      %%Calculating Displacement
      displacement = xw-xwk;
      %%Calculating location of xk
      xk = x + U0*(displacement);
      %%Calculation of mu matrix at xwk
      W0 = img(xwk(1)-2:xwk(1)+2,xwk(2)-2:xwk(2)+2);
      mu_xwk = harrismeasure(W0,si,sd);
      %%Calculating root of mu matrix
      mu_i = inv(sqrtm(mu_xwk));
      %%Calculating U-transformation Matrix for next step
      U_k = mu_i*U0;
      %%Normalizing maximum eigenvalue to 1
      U_k = U_k/max(eig(U_k));
      %%Checking Stopping criterion
      lambda_mu_i = eig(mu_i);
      epsilon_c = 1-min(lambda_mu_i)/max(lambda_mu_i);
    endwhile
    
  endfor