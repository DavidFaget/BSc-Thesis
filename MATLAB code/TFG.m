function [] = tfg();  

%%%PROGRAMA PARA OBTENER LOS GRÁFICOS DE EVOLUCIÓN DE LA POBLACIÓN A LO
%%%LARGO DEL TIEMPO Y LA ÓRBITA DE LA SOLUCIÓN.

global coefs;
global txt2; 
txt2="Proceso terminado. Introduce el número del siguiente modelo:";

txt=['Modelos disponibles: \n 1: Depredador-presa modificado \n 2: SIR' ...
' \n 3: SIR con dinámica vital \n 4: SEIR con dinámica vital y '... 
'vacunación \n 5: Salir del programa \n'];
fprintf(txt)
modelo=input("Introduce el número del modelo:");


while(modelo~=5)
    switch modelo

        case 1

        y0=input("Introduce las condiciones iniciales [S,Z]:");
        coefs=input("Introduce [alpha,beta,delta,gamma,xi]:");

        %%%VALORES SUGERIDOS%%%
%         [S,Z]=[1,2]
%         alpha=0.015 %Entrada de humanos
%         beta=0.0098 %Tasa de que el humano pierda
%         delta=0.0008 %Tasa de 'zombificación' en un encuentro
%         gamma=0.0003 %Zombis destrozados en encuentro con humanos
%         xi=0.01 %Muerte natural zombis
        
        [t,y]=ode23(@volt,[0 1000],y0);
        
        for i=1:length(y(:,1))
        n(i)=y(i,1)+y(i,2);
        end
        n=n';
        
        figure(1) %Población a lo largo del tiempo
        clf
        plot(t,y(:,1)./n,'bo-','MarkerSize',2,'LineWidth',2)
        hold on
        plot(t,y(:,2)./n,'ro-','MarkerSize',2,'LineWidth',2)
        xlabel('Tiempo')
        ylabel('Proporción de individuos')
        legend('Humanos','Zombis')


        figure(2) %Órbita de la solución.
        clf
        plot(y(:,1),y(:,2),'bo-','MarkerSize',2,'LineWidth',2)
        xlabel('Humanos')
        ylabel('Zombis')
        
        modelo=input(txt2);

        case 2
        
        y0=input("Introduce las condiciones iniciales [S,I,R]:");
        coefs=input("Introduce [beta,gamma]:");
        
                %%%VALORES SUGERIDOS%%%
%         [S,I,R]=[200,2,0]
%         [beta,gamma]=[0.0016,0.06] 
        
        %NÚMERO BÁSICO DE REPRODUCCIÓN:
        N=sum(y0);
        R0=N*coefs(1)/coefs(2);
        disp(["El número básico de reproducción es:",R0])
        
        [t,y]=ode23(@sir,[0 100],y0);
        figure(1) %Evolución
        clf
        plot(t,y(:,1),'bo-','MarkerSize',2,'LineWidth',2)
        hold on
        plot(t,y(:,2),'ro-','MarkerSize',2,'LineWidth',2)
        hold on
        plot(t,y(:,3),'go-','MarkerSize',2,'LineWidth',2)
        xlabel('Tiempo')
        ylabel('Individuos')
        legend('Humanos susceptibles','Zombis','Recuperados')


        figure(2) %Órbita de la solución de las dos primeras componentes.
        clf
        plot(y(:,1),y(:,2),'bo-','MarkerSize',2,'LineWidth',2)
        ylabel('Zombis')
        xlabel('Humanos susceptibles')
        
        modelo=input(txt2);
        
        case 3
        
        y0=input("Introduce las condiciones iniciales [S,I,R]:");
        coefs=input("Introduce [beta,gamma,mu]:");
        
            %%%VALORES SUGERIDOS%%%
%       [S,I,R]=[499,1,0]
%       [beta,gamma,mu]=[0.0029,0.6285,0.061] 

        %NÚMERO BÁSICO DE REPRODUCCIÓN:
        global N; %N es global ya que la usaremos en la función "sirvital"
        N=sum(y0);
        R0=N*coefs(1)/(coefs(2)+coefs(3));
        disp(["El número básico de reproducción es:",R0])
        
        [t,y]=ode23(@sirvital,[0 100],y0);    
        figure(1) %Evolución
        clf
        plot(t,y(:,1),'bo-','MarkerSize',2,'LineWidth',2)
        hold on
        plot(t,y(:,2),'ro-','MarkerSize',2,'LineWidth',2)
        hold on
        plot(t,y(:,3),'go-','MarkerSize',2,'LineWidth',2)
        xlabel('Tiempo')
        ylabel('Individuos')
        legend('Humanos susceptibles','Zombis','Recuperados')


        figure(2) %Órbita de la solución de las dos primeras componentes.
        clf
        plot(y(:,1),y(:,2),'bo-','MarkerSize',2,'LineWidth',2)
        ylabel('Zombis')
        xlabel('Humanos susceptibles')
        
        modelo=input(txt2);
        
        case 4
        
        y0=input("Introduce las condiciones iniciales [S,E,I,R]:");
        coefs=input("Introduce [alpha,beta,gamma,mu,mu_0,v]:");
        
            %%%VALORES SUGERIDOS%%%
%       [S,E,I,R]=[199,0,1,0]
%       [alpha,beta,gamma,mu,mu_0,v]=[0.007,0.072,0.0062,0.022,0.0004,0.004] 

        %NÚMERO BÁSICO DE REPRODUCCIÓN:
        global N; %N es global ya que la usaremos en la función "seir"
        N=sum(y0);
        R0=(N*coefs(1)*coefs(2)*coefs(4))/((coefs(4)+coefs(2))*(coefs(4)+...
            coefs(6))*(coefs(5)+coefs(3)+coefs(4)));
        disp(["El número básico de reproducción es:",R0])
        
        [t,y]=ode23(@seir,[0 100],y0);    
        figure(1) %Evolución
        clf
        plot(t,y(:,1),'bo-','MarkerSize',2,'LineWidth',2)
        hold on
        plot(t,y(:,2),'ko-','MarkerSize',2,'LineWidth',2)
        hold on
        plot(t,y(:,3),'ro-','MarkerSize',2,'LineWidth',2)
        hold on
        plot(t,y(:,4),'go-','MarkerSize',2,'LineWidth',2)
        xlabel('Tiempo')      
        ylabel('Individuos')
        legend('Humanos susceptibles','Expuestos','Zombis','Recuperados')


        figure(2) %Órbita de la solución de susceptibles frente a infectados.
        clf
        plot(y(:,1),y(:,3),'bo-','MarkerSize',2,'LineWidth',2)
        ylabel('Zombis')
        xlabel('Humanos susceptibles')
        
        modelo=input(txt2);
        
        
        otherwise
        fprintf("El número del modelo introducido no es válido. \n")
        modelo=input("Introduce un número de modelo válido:");
        
    end
end


end



function f = volt(t,y);
global coefs
f = [coefs(1)*y(1)-coefs(2)*y(1)*y(2),coefs(3)*y(1)*y(2)-...
    coefs(4)*y(1)*y(2)-coefs(5)*y(2)]';
end

function f = sir(t,y);
global coefs
f = [-coefs(1)*y(1)*y(2),coefs(1)*y(1)*y(2)-coefs(2)*y(2),coefs(2)*y(2)]';
end

function f = sirvital(t,y);
global coefs
global N
f = [-coefs(1)*y(1)*y(2)-coefs(3)*y(1)+coefs(3)*N,coefs(1)*y(1)*y(2)-...
    coefs(2)*y(2)-coefs(3)*y(2),coefs(2)*y(2)-coefs(3)*y(3)]';
end

function f = seir(t,y);
global coefs
global N
f = [coefs(4)*N-(coefs(1)*y(3)+coefs(4)+coefs(6))*y(1),coefs(1)*y(1)*y(3)-...
    (coefs(2)+coefs(4))*y(2),coefs(2)*y(2)-(coefs(5)+coefs(3)+...
    coefs(4))*y(3),coefs(3)*y(3)+coefs(6)*y(1)-coefs(4)*y(4)]';
end
