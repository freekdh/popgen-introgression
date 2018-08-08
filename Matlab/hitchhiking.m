function hitchhiking()
    
    size = 6;
    recmat = recombinationMatrix(size, 0.05,.1); % don't go over 10
    selmat = selectionMatrix(size, 0.0, 0.0, 0.0, 0., .1); % don't go over 10
    
    %spy(selmat)
    %spy(recmat)
    
    initvec = initialvec(1,2,6,1,size);
    powermat = selmat*recmat;
            
    [E_AB,E_Ab,E_aB,E_ab,V_AB,V_Ab,V_aB,V_ab] = data(500,initvec,powermat, size);
    [E_AB,E_Ab,E_aB,E_ab,V_AB,V_Ab,V_aB,V_ab];
    
    csvwrite("./data/neutral.csv",[E_AB,E_Ab,E_aB,E_ab,V_AB,V_Ab,V_aB,V_ab]);
    
    %plot([AB-1,Ab-1,aB-1,ab-1])
        
	%plot([(AB-1)./((Ab-1)+(AB-1)),(aB-1)./((aB-1)+(ab-1))])
end

function [E_AB,E_Ab,E_aB,E_ab,V_AB,V_Ab,V_aB,V_ab] = data(t,initvec,powermat,size)
    temppower = eye(size^4);
    E_AB = zeros(t,1);
    E_Ab = zeros(t,1);
    E_aB = zeros(t,1);
    E_ab = zeros(t,1);
    V_AB = zeros(t,1);
    V_Ab = zeros(t,1);
    V_aB = zeros(t,1);
    V_ab = zeros(t,1);
    
    for tt = 1:t
        vec = temppower*initvec;
        for i = 1: size^4
            [k,l,m,n] = elem2mat(i,size);
            E_AB(tt) = E_AB(tt) + (k-1)*vec(i);
            E_Ab(tt) = E_Ab(tt) + (l-1)*vec(i);
            E_aB(tt) = E_aB(tt) + (m-1)*vec(i);
            E_ab(tt) = E_ab(tt) + (n-1)*vec(i);
            V_AB(tt) = V_AB(tt) + (k-1)*(k-1)*vec(i);
            V_Ab(tt) = V_Ab(tt) + (l-1)*(l-1)*vec(i);
            V_aB(tt) = V_aB(tt) + (m-1)*(m-1)*vec(i);
            V_ab(tt) = V_ab(tt) + (n-1)*(n-1)*vec(i);
        end
        
        V_AB(tt) = V_AB(tt) - (E_AB(tt)*E_AB(tt));
        V_Ab(tt) = V_Ab(tt) - (E_Ab(tt)*E_Ab(tt));
        V_aB(tt) = V_aB(tt) - (E_aB(tt)*E_aB(tt));
        V_ab(tt) = V_ab(tt) - (E_ab(tt)*E_ab(tt));
        
        temppower = temppower*powermat;
    end
end

function vec = initialvec(AB,Ab,aB,ab,size)
vec = zeros(size^4,1);
vec(mat2elem(AB,Ab,aB,ab,size)) = 1;
end

function matrix = recombinationMatrix(size, rec,dt)
    matrix = sparse(size^4,size^4);
    for AB = 1:size
        for Ab = 1:size
            for aB = 1:size
                for ab = 1:size
                    sum=AB+Ab+aB+ab-4;
                    temp =0;
                    if(AB ~= size && Ab ~= 1 && aB ~= 1 && ab ~= size)
                    matrix(mat2elem(AB+1,Ab-1,aB-1,ab+1,size), mat2elem(AB,Ab,aB,ab,size)) = (Ab-1)*(aB-1)*dt*rec; temp = temp + (Ab-1)*(aB-1)*dt*rec;
                    end
                    if(AB ~= 1 && Ab ~= size && aB ~= size && ab ~= 1)
                    matrix(mat2elem(AB-1,Ab+1,aB+1,ab-1,size), mat2elem(AB,Ab,aB,ab,size)) = (AB-1)*(ab-1)*dt*rec; temp = temp + (AB-1)*(ab-1)*dt*rec;                 
                    end
                    
                    if(sum ~= 0)
                    matrix(mat2elem(AB,Ab,aB,ab,size), mat2elem(AB,Ab,aB,ab,size)) = 1-temp;
                    end
                end
            end
        end
    end
    
    matrix(1,1) = 1;
    
end

function matrix = selectionMatrix(size, bA, dA, ba, da, dt)
    matrix = sparse(size^4,size^4);
    for AB = 1:size
        for Ab = 1:size
            for aB = 1:size
                for ab = 1:size
                    sum=AB+Ab+aB+ab-4;
                    temp = 0;
                    if(AB ~= 1)
                    matrix(mat2elem(AB-1,Ab,aB,ab,size),mat2elem(AB,Ab,aB,ab,size)) = (AB-1)*dt*dA; temp=temp+(AB-1)*dt*dA;
                    end
                    if(Ab ~= 1)
                    matrix(mat2elem(AB,Ab-1,aB,ab,size),mat2elem(AB,Ab,aB,ab,size)) = (Ab-1)*dt*dA; temp=temp+(Ab-1)*dt*dA;
                    end
                    if(aB ~= 1)
                    matrix(mat2elem(AB,Ab,aB-1,ab,size),mat2elem(AB,Ab,aB,ab,size)) = (aB-1)*dt*da; temp=temp+(aB-1)*dt*da;
                    end
                    if(ab ~= 1)
                    matrix(mat2elem(AB,Ab,aB,ab-1,size),mat2elem(AB,Ab,aB,ab,size)) = (ab-1)*dt*da; temp=temp+(ab-1)*dt*da;
                    end
                    
                    if(AB ~= 1 && AB ~= size)
                    matrix(mat2elem(AB+1,Ab,aB,ab,size),mat2elem(AB,Ab,aB,ab,size)) = (AB-1)*dt*bA; temp=temp+(AB-1)*dt*bA;
                    end
                    if(Ab ~= 1 && Ab ~= size)
                    matrix(mat2elem(AB,Ab+1,aB,ab,size),mat2elem(AB,Ab,aB,ab,size)) = (Ab-1)*dt*bA; temp=temp+(Ab-1)*dt*bA;
                    end
                    if(aB ~= 1 && aB ~= size)
                    matrix(mat2elem(AB,Ab,aB+1,ab,size),mat2elem(AB,Ab,aB,ab,size)) = (aB-1)*dt*ba; temp=temp+(aB-1)*dt*ba;
                    end
                    if(ab ~= 1 && ab ~= size)
                    matrix(mat2elem(AB,Ab,aB,ab+1,size),mat2elem(AB,Ab,aB,ab,size)) = (ab-1)*dt*ba; temp=temp+(ab-1)*dt*ba;
                    end
                    
                    
                    if(sum ~= 0)
                    matrix(mat2elem(AB,Ab,aB,ab,size),mat2elem(AB,Ab,aB,ab,size)) = 1-temp;
                    end
                end
            end
        end
    end
    
    matrix(1,1) = 1;
    
end

function index = mat2elem(i,j,k,l,N)
index = (l-1)*N*N*N+(k-1)*N*N+(j-1)*N+i;
end

function [i,j,k,l] = elem2mat (index, N)
    i = mod(index-1,N)+1;
    j = mod(floor((index-1)/(N)),N)+1;
    k = mod(floor((index-1)/(N*N)),N)+1;
    l = mod(floor((index-1)/(N*N*N)),N)+1;
end

