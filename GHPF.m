I=imread('Cameraman.tif');
subplot(3,3,1),imshow(I);
title('Original Image');
%J=rgb2gray(I);
%subplot(3,2,2),imshow(j);

%[m,n]=size(I);
k=im2double(I);
[m,n]=size(k);

c=zeros(2*m,2*n);
[p,q]=size(c);

%placing original image in null array to create padded image
for i=1:p
    for j=1:q
        if i<=m && j<=n
            c(i,j)=k(i,j);
        else
            c(i,j)=0;
        end
    end
end


subplot(3,3,2),imshow(c);
title('Padded Image');

%Pre processing of image
for i=1:p
    for j=1:q
        d(i,j)= c(i,j).*(-1).^(i+j);
    end
end

subplot(3,3,3),imshow(d);
title('Preprocessed image');

%Calculating Fourier Transform

e=fft2(d);

subplot(3,3,4),imshow(e);
title('Fourier Transformed Image');

Do=100;
order=2;
z=zeros(p,q);
H=zeros(p,q);
%temp=zeros(p,q);
for i=1:p
    for j=1:q
        z(i,j)= sqrt ((i-p/2).^2 + (j-q/2).^2);
        
    end
end

for i=1:p
    for j=1:q
        H(i,j)= 1 - exp(-(z(i,j).^2)/(2*Do*Do));
    end
end

P=zeros(p,q);

for i=1:p
    for j=1:q
        if z(i,j)>Do              %cut-off frequency
            P(i,j)=H(i,j);
        else
            P(i,j)=0;
        end
    end
end

subplot(3,3,5),imshow(P);
title('High Pass Filter Mask');
%Product of H and e is done to obtain output

f=e.*P;
subplot(3,3,6),imshow(f);
title('Fourier transformed output image');

%Inverse of fourier tranform

g=ifft2(f);
subplot(3,3,7),imshow(g);
title('Output Image after inverse transform');

x1= zeros(p,q);

for i=1:p
    for j=1:q
        x1(i,j)= g(i,j).*((-1).^(i+j));
    end
end

subplot(3,3,8),imshow(x1);
title('Post Processed Image');

final_img=zeros(m,n);

for i=1:m
    for j=1:n
        final_img(i,j)=x1(i,j);
    end
end

subplot(3,3,9),imshow(final_img);
title('Enhanced Output Image');


%Image obtained is blurred as it got smoothened due to passing through low
%pass filter
