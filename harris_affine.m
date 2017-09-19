function affineinvpts = harris_affine(img,scaleinvpts)
  %%scaleinvpts = harris_laplace(img);
  [h,w]=size(img)
  lenrc = length(scaleinvpts);
  affineinvpts = [];
  for i=1:lenrc
    %%Initializing interest points
    x0 = scaleinvpts(i,1:2);
    x0 = x0';
    %%Initializing U-transformation matrix
    U0 = eye(2);
    %si0 = scaleinvpts(i,3);
    %sd0 = s*si0;
    %%Calculating the co-ordinates in the transformed Image domain
    xw0 = inv(U0)*x0;
    %%Selecting the transformed image domain window W(xw)
    if round(xw0(1))>2 && round(xw0(2))>2 && round(xw0(1))<h-1 && round(xw0(2))<w-1
      W0 = img(round(xw0(1))-2:round(xw0(1))+2,round(xw0(2))-2:round(xw0(2))+2);
      NA = 0;
    else
      NA = 1;
      continue
    endif
    %%Normalizing the window
    W0 = windownormalize(W0);
    %%Calculating Integration Scale
    si = intscaleselect(W0);
    %%Calculation of optimal s for calculating sigmaD by maximizing isotropic measure
    opts = optdiffscale(si,W0);
    sd = opts*si;
    %%Finding Spatial Localization
    xwk = spatialloc(xw0,si,sd,W0);
    %%Calculating Displacement
    displacement = xw0-xwk;
    %%Calculating location of xk
    xk = x0 + U0*(displacement);
    %%Calculation of mu matrix at xwk
    if (round(xwk(1))>2) && (round(xwk(2))>2) && (round(xwk(1))<h-1) && (round(xwk(2))<w-1)
      W0 = img(round(xwk(1))-2:round(xwk(1))+2,round(xwk(2))-2:round(xwk(2))+2);
    else
      NA = 1;
      continue
    endif
    mu_xwk = harrismeasure_xw(W0,si,sd);
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
      %disp('In the loop...')
      %disp(i)
      xw = inv(U_k)*xk;
      %%Selecting the transformed image domain window W(xw)
      if (round(xw(1))>2) && (round(xw(2))>2) && (round(xw(1))<h-1) && (round(xw(2))<w-1)
        W0 = img(round(xw(1))-2:round(xw(1))+2,round(xw(2))-2:round(xw(2))+2);
      else
        NA=1;
        break
      endif
      %%Normalizing the window
      W0 = windownormalize(W0);
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
      xk = xk + U0*(displacement);
      %%Calculation of mu matrix at xwk
      if (round(xwk(1))>2) && (round(xwk(2))>2) && (round(xwk(1))<h-1) && (round(xwk(2))<w-1)
        W0 = img(round(xwk(1))-2:round(xwk(1))+2,round(xwk(2))-2:round(xwk(2))+2);
      else
        NA = 1;
        break
      endif
      mu_xwk = harrismeasure_xw(W0,si,sd);
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
    if (epsilon_c < 0.05 && NA==0 && round(xk(1))>0 && round(xk(2))>0 && round(xk(1))<h && round(xk(2))<w)
      %disp(i)
      ismemberpt = ismember(xk',affineinvpts);
      ismemberpt = ismemberpt(1) && ismemberpt(2);
      if ~ismemberpt
        affineinvpts = [affineinvpts;round(xk')];
      endif
    endif
  endfor
  
  %%Discarding negative points
  affine1 = affineinvpts(:,1)>0;
  affine2 = affineinvpts(:,2)>0;
  affine3 = affine1&affine2;
  affinefc = affineinvpts(:,1);
  affinefc = affinefc(affine3);
  affinesc = affineinvpts(:,2);
  affinesc = affinesc(affine3);
  affineinvpts = [affinefc,affinesc];
endfunction