function interestPoints = harrisInterestPoints(img,sigi,sigd,threshold)
  %%evaluating each frame
  %sigd = 1.0;
  %sigi = 2.0;
  %img = imread(imagepath);
  %img = rgb2gray(img);
  [h,w] = size(img);
  G = fspecial('gaussian',[5 5],sigd);
  [Lx,Ly] = gradient(G);
  %%Harris Edge detector
  imgx = conv2(img,Lx,'same');
  imgy = conv2(img,Ly,'same');
  g = fspecial('gaussian',[5 5],sigi);
  imgxx = imgx.^2;
  imgxx = imfilter(imgxx,g,'conv');
  imgyy = imgy.^2;
  imgyy = imfilter(imgyy,g,'conv');
  imgxy = imgx.*imgy;
  imgxy = imfilter(imgxy,g,'conv');
  Cx = [];
  Cy = [];
  R = zeros(h,w);
  for i=1:h
    for j=1:w
      M = (sigd^2)*[imgxx(i,j),imgxy(i,j);imgxy(i,j),imgyy(i,j)];
      [~,D] = eig(M);
      R(i,j) = det(D) - 0.05*(trace(D))^2;
    end
  end
  %Edges = (R<-1e5);
  Corners = (R>threshold).*R;
  %figure(1)
  %subplot(131)
  %imshow(Edges)
  %%Finding local maxima for cornerness
  i=1;
  j=1;
  present = 0;
  maxval = [];
  while i<h-2
    j=1;
    while j<w-2
      C = Corners(i:i+2,j:j+2);
      if C(2,2)==max(max(C)) && C(2,2)~=0
        if nnz(C==C(2,2))==1
          Cx = [Cx,i+1];
          Cy = [Cy,j+1];
          maxval = [maxval,max(max(C))];
          j=j+3;
        elseif nnz(C==C(2,2))>1 && ismember(C(2,2),maxval)
          j=j+1;
        end
      else
        j=j+1;
      end
    end
    i=i+1;
  end  
%   figure(1)
%   imshow(img)
%   hold on
%   plot(Cy,Cx,'bo','MarkerSize',10)
  interestPoints = [Cx',Cy'];
end
