function hog = calculatehog(W)
  %% Compute Gradients
  Lx = [-1,0,1];
  Ly = Lx';
  Wx = conv2(W,Lx,'same');
  Wy = conv2(W,Ly,'same');
  %% Compute Magnitude and Angle
  MagWgrad = (Wx.^2+Wy.^2).^0.5;
  OrWgrad = atan(Wy./Wx);
  %% Compute histogram
  numOfbins = 18;
  binSize = pi/numOfbins;
  cellSize = 2;
  blockSize = 5;
  histogram = zeros(1,numOfbins);
  %halfBinSize = binSize/2;
  for r=1:blockSize-1
    for c=1:blockSize-1
      %histcell = W(r+1:r+2,c+1:c+2);
      histangle = OrWgrad(r+1:r+2,c+1:c+2);
      histmag = MagWgrad(r+1:r+2,c+1:c+2);
      histangle(histangle<0)= pi+histangle(histangle<0); %Making all angles take vaues from 0 to 180
      for pixel = 1:4
        %pixelvalue = histcell(pixel);
        pixelAngle = histangle(pixel)
        if pixelAngle == 0
          disp('zero')
          pixelAngle = atan(0.01)
        elseif isnan(pixelAngle)
          disp('NaN')
          pixelAngle = atan(1e9)
        endif
        pixelMag = histmag(pixel);
        pixelBin = ceil(pixelAngle/binSize)
        histogram(1,pixelBin) = histogram(1,pixelBin)+pixelMag;
      endfor
    endfor
  endfor
  %%Block Normalization
  normMag = norm(histogram)+0.01;
  hog = histogram/normMag;
endfunction
