function scaleinvpts = harris_laplace(img,nframe=1)
  %%evaluating each frame
  sign = 1.0;
  ki=1.2;
  s=0.6;
  sigi = 1.0;
  sigd = s*sigi;
  %img = imread(imagepath);
  %img = rgb2gray(img);
  [h,w] = size(img);
  row = [];
  col = [];
  for k=1:10
    sigi = (ki^(k-1))*sign; %SigmaI
    sigd = s*sigi; %SigmaD 
    imgx = zeros(h,w);
    imgy = zeros(h,w);
    Ly = [-1,0,1]'*fspecial('gaussian',[1 3],sigd);
    Lx = fspecial('gaussian',[3 1],sigd)*[-1,0,1];
    imgx = conv2(img,Lx,'same');
    imgy = conv2(img,Ly,'same');
    g = fspecial('gaussian',[3 3],sigi);
    imgxx = imgx.^2;
    imgxx = conv2(imgxx,g,'same');
    imgyy = imgy.^2;
    imgyy = conv2(imgyy,g,'same');
    imgxy = imgx.*imgy;
    imgxy = conv2(imgxy,g,'same');
    R = zeros(h,w);
    for i=1:h
      for j=1:w
        Mu = [imgxx(i,j),imgxy(i,j);imgxy(i,j),imgyy(i,j)];
        [V,D] = eig(Mu);
        R(i,j) = det(D) - 0.05*(trace(D))^2;
      end
    end
    Corners = (R>5e6).*R;
    %%Finding local maxima for cornerness
    i=1;
    while i<(h-2)/2
      j=1;
      while j<(w-2)/2
        C1 = Corners(i:i+2,j:j+2);
        C2 = Corners(h-i-2:h-i,w-j-2:w-j);
        C3 = Corners(h-i-2:h-i,j:j+2);
        C4 = Corners(i:i+2,w-j-2:w-j);
        if C1(2,2)==max(max(C1)) && C1(2,2)!=0 && nnz(C1=C1(2,2))==1
          row = [row,i+1];
          col = [col,j+1];
        endif
        if C2(2,2)==max(max(C2)) && C2(2,2)!=0 && nnz(C2=C2(2,2))==1
          row = [row,h-i-1];
          col = [col,w-j-1];
        endif
        if C3(2,2)==max(max(C3)) && C3(2,2)!=0 && nnz(C3=C3(2,2))==1
          row = [row,h-i-1];
          col = [col,j+1];
        endif
        if C4(2,2)==max(max(C4)) && C4(2,2)!=0 && nnz(C4=C4(2,2))==1
          row = [row,i+1];
          col = [col,w-j-1];
        endif
        j=j+1;
      endwhile
      i=i+1;
    endwhile
  endfor

  %%Laplace Of Gaussian

  scaleinvpts = [];
  lenrc = length(row);
  imglog=[];
  for k=1:10
    sigma = ki^(k-1);
    imglog(:,:,k) = uint8(abs(conv2(conv2(img,fspecial('gaussian',[3 3],sigma),'same'),fspecial('log',[3 3],sigma),'same')));
  endfor
  for i=1:lenrc
    r = row(i);
    c = col(i);
    logvalvec = [];
    for n=1:10
      logval = imglog(r,c,n);
      logvalvec = [logvalvec,logval];
    endfor
    lensipb = length(scaleinvpts);
    for n=2:9
      log3val = logvalvec(n-1:n+1);
      if log3val(2)==max(log3val) && log3val(2)!=0
        scaleinvpts = [scaleinvpts; r,c,ki^(n-1)];
      endif
    endfor
    if lensipb == length(scaleinvpts)
      scaleinvpts = [scaleinvpts; r,c,1];
    endif
  endfor
  %figure(nframe)
  %imshow(img)
  %hold on
  %plot(scaleinvpts(:,2),scaleinvpts(:,1),'gs')
  %save -6 scaleinvpts.mat scaleinvpts
endfunction