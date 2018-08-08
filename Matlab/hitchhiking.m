function hitchhiking()
    
    size = 6;
    recmat = recombinationMatrix(size, 0.05,.1); % don't go over 10
    selmat = selectionMatrix(size, 0.0, 0.0, 0.0, 0., .1); % don't go over 10
    
    %spy(selmat)
    %spy(recmat)
    
    initvec = initialvec(1,2,6,1,size);
    powermat = selmat*recmat;
            
    [AB,Ab,aB,ab] = data(500,initvec,powermat, size);
    [AB,Ab,aB,ab];
    
    csvwrite("./data/neutral.csv",[AB,Ab,aB,ab]);
    
    %plot([AB-1,Ab-1,aB-1,ab-1])
        
	plot([(AB-1)./((Ab-1)+(AB-1)),(aB-1)./((aB-1)+(ab-1))])
end

function [AB,Ab,aB,ab] = data(t,initvec,powermat,size)
    temppower = eye(size^4);
    AB = zeros(t,1);
    Ab = zeros(t,1);
    aB = zeros(t,1);
    ab = zeros(t,1);
    
    for tt = 1:t
        vec = temppower*initvec;
        for i = 1: size^4
            [k,l,m,n] = elem2mat(i,size);
            AB(tt) = AB(tt) + k*vec(i);
            Ab(tt) = Ab(tt) + l*vec(i);
            aB(tt) = aB(tt) + m*vec(i);
            ab(tt) = ab(tt) + n*vec(i);
        end
        
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
