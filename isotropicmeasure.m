function isotropic_measure = isotropicmeasure(imgxx,imgyy,imgxy,sigmaD)
  R = zeros(5,5);
  for i=1:5
    for j=1:5
      Mu = (sigmaD^2)*[imgxx(i,j),imgxy(i,j);imgxy(i,j),imgyy(i,j)];
      eigvals = eig(Mu);
      R(i,j) = min(eigvals)/max(eigvals);
    end
  end
  isotropic_measure = R(3,3);
end
