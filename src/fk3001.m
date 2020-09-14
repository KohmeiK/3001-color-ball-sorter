function AM = fk3001(th1, th2, th3)   
    T12 = matrix(th1, 95, 0, -90);
    T23 = matrix(th2-90, 0, 100, 0);
    T34 = matrix(th3+90, 0, 100, 0);
    
    
    
    product_matrix = T12*T23*T34;
    
    AM(1,1) = product_matrix(1,4);
    AM(2,1) = product_matrix(2,4);
    AM(3,1) = product_matrix(3,4);
    
end