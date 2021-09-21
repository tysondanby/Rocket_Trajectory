function A= rotationMatrix(U, theta)
%Computes a rotation matrix about an arbitrary axis U. Based on formula found at  http://ksuweb.kennesaw.edu/~plaval/math4490/rotgen.pdf

    %This makes writing the matrix out less cumbersome.
    C= cos(theta);
    S= sin(theta);
    T= 1-C;

    A=[T*U(1)^2+C, T*U(1)*U(2)-S*U(3), T*U(1)*U(3)+S*U(2);
       T*U(1)*U(2)+S*U(3), T*U(2)^2+C, T*U(2)*U(3)-S*U(1);
       T*U(1)*U(3)-S*U(2), T*U(2)*U(3)+S*U(1), T*U(3)^2+C];
    
end