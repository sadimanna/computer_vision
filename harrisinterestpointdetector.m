%%Harris Interest point Detector
pkg load image
%%images details
imagepath = "/home/siladittya/octave/ISI/cycle.jpg";
%file = dir([imagepath,'*.jpg']);
%nframes = length(file);
%%evaluating each frame
sigd = 1.0;
sigi = 2.0;
for i=1:1
  img = imread(imagepath);
  img = rgb2gray(img);
  [h,w] = size(img);
  imgx = zeros(h,w);
  imgy = zeros(h,w);
  Lx = [-1,0,1;-1,0,1;-1,0,1];
  Ly = Lx';
  %%Harris Edge detector
  imgx = conv2(img,Lx,'same');
  imgy = conv2(img,Ly,'same');
  g = fspecial('gaussian',[3 3],sigi);
  imgxx = imgx.^2;
  imgxx = conv2(imgxx,g,'same');
  imgyy = imgy.^2;
  imgyy = conv2(imgyy,g,'same');
  imgxy = imgx.*imgy;
  imgxy = conv2(imgxy,g,'same');
  Cx = [];
  Cy = [];
  R = zeros(h,w);
  for i=1:h
    for j=1:w
      M = [imgxx(i,j),imgxy(i,j);imgxy(i,j),imgyy(i,j)];
      [V,D] = eig(M);
      R(i,j) = det(D) - 0.05*(trace(D))^2;
    end
  end
  %Edges = (R<-1e5);
  Corners = (R>1e5).*R;
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
      if C(2,2)==max(max(C)) && C(2,2)!=0
        if nnz(C=C(2,2))==1
          Cx = [Cx,i+1];
          Cy = [Cy,j+1];
          maxval = [maxval,max(max(C))];
          j=j+3;
        elseif nnz(C==C(2,2))>1 && ismember(C(2,2),maxval)
          j=j+1;
        endif
      else
        j=j+1;
      endif
    endwhile
    i=i+1;
  endwhile  
  %subplot(132)
  %subplot(211)
  figure(1)
  imshow(img)
  hold on
  plot(Cy,Cx,'b*')
  %subplot(212)
  %imshow(img)
end