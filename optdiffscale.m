function opts = optdiffscale(sigmaI,W0)
  R = [];
  %%Calculation of optimal s for calculating sigmaD by maximizing isotropic measure
  for s = 50:75
    sofD = s/100;
    sigmaD = sofD*sigmaI;
    Lwy = [-1,0,1]'*fspecial('gaussian',[1 3],sigmaD);
    Lwx = fspecial('gaussian',[3 1],sigmaD)*[-1,0,1];
    gw = fspecial('gaussian',[3 3],sigmaI);
    imgwx = conv2(W0,Lwx,'same');
    imgwy = conv2(W0,Lwy,'same');
    imgwxx = imgwx.^2;
    imgwxx = conv2(imgwxx,gw,'same');
    imgwyy = imgwy.^2;
    imgwyy = conv2(imgwyy,gw,'same');
    imgwxy = imgwx.*imgwy;
    imgwxy = conv2(imgwxy,gw,'same');
    R(s-49) = isotropicmeasure(imgwxx,imgwyy,imgwxy,sigmaD);
  endfor
  opts = (R(find(R==max(R)))+49)/100;
  %disp('opts')
  %disp(opts)
endfunction