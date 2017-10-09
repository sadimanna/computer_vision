function mu_xw = harrismeasure_xw(W,sigmaI,sigmaD)
  %disp('harrismeasure')
  si = sigmaI;
  sd = sigmaD;
  imgxx = calcimgxx(W,si,sd);
  imgyy = calcimgyy(W,si,sd);
  imgxy = calcimgxy(W,si,sd);
  mu_xw = (sd^2)*[imgxx(3,3) imgxy(3,3);imgxy(3,3) imgyy(3,3)];
end
