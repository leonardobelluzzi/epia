clc, clear;

%Entrada Pegar a entrada
%================================================================================================================================%
localIMG = '00001';
localimg = strcat('C:\Users\leona\Desktop\USP\2017 - 1 Semestre\IA - Sarajane\EP2\dataset1\treinamento\train_5a_',localIMG);
localimg = strcat(localimg, '.png');
disp(localimg);
img = imread(localimg);
entrada = HOG(img,16);
%================================================================================================================================%

%Configuracao Rede
%=============================================%
%Neuronios na camada de entrada;
n = size(entrada,1);
%Neuronios na camada de saida;
k = 26;
%Neuronios na camada escondida;
p = round ((n + k) /2);
%Numero de epocas
epocaMax = 1000;
%Taxa de aprendizado
alpha  = 0.0001;
%Decaimento alpha se 1 = (sem decaimento)
alphaDecai = 1;
%Erro minimo
erroMin = 0.001;
%=============================================%

%Geração Aleatórias de pesos
%Bias
pesoBiasEscondida = 1 - 2. * rand(1, p);
pesoBiasSaida = 1 - 2. * rand(1, k);

%Escondida
pesoEscondida = 1 - 2. * rand(n, p);
pesoSaida = 1 - 2. * rand(p, k);


%SaidaEsperada
saidaEsp = [1 -1 -1];

%erro
erroTotal = zeros(epocaMax);

%Rede Algoritimo
for epoca = 1: epocaMax
    z_in = zeros (1,p);
    
    for pa = 1 : p
        for na = 1 : n
            z_in(pa) = z_in(pa) + entrada(na, 1) * pesoEscondida(na, pa);
        end
    end
    for pa = 1 : p
        z_in(pa) = z_in(pa) + 1 * pesoBiasEscondida(1, pa);
    end
    
    %Aplicar a função
    z = zeros(1,p);
    for pa = 1 : p
        z(pa) = F(z_in(pa));
    end
    
    y_in = zeros(1,k);
    for ka = 1 : k
        for pa = 1 : p
            y_in(ka) = y_in(ka) + z(pa) * pesoSaida(pa, ka);
        end
    end
    for ka = 1 : k
        y_in(ka) = y_in(ka) + 1 * pesoBiasSaida(1, ka);
    end
    
    %Aplicar a função
    y = zeros(1,k);
    for ka = 1 : k
        y(ka) = G(y_in(ka));
    end
    
    %Erro Quadradico médio
    erro_ind = zeros(1,k);
    for ka = 1 : k
        erro_ind(ka) = saidaEsp(ka) - y(ka);
    end
    erroDaEpoca = sum(abs(erro_ind));
    
    erroTotal(epoca) = erroDaEpoca;
    
    %Caso atingir o erro minimo
    if (erroDaEpoca < erroMin)
        disp('A rede atingiu o erro minimo: ');
        break;
    end
    
    %Ajustes
    deltaK = zeros(1,k);
    for ka = 1 : k
        deltaK(ka) = erro_ind(ka) * flinha(y_in(ka));
    end
    
    disp(['Época: ', num2str(epoca)]);
    disp(['Saida: ', num2str(y)]);
    disp(['SaidaEsp: ', num2str(saidaEsp)]);
    disp(['Erro Individual: ', num2str(erro_ind)]);
    disp(['Delta K ', num2str(deltaK)]);
    disp(['Erro epoca', num2str(sum(erro_ind))]);
    %Saida
    deltaPesoSaida = zeros(p,k);
    
    for ka = 1 : k
        for pa = 1 : p
            deltaPesoSaida(pa,ka) = alpha * deltaK(ka) * z(pa);
        end
    end
    
    %Bias Saida
    deltaPesoSaidaBias = zeros(1,k);
    for a = 1 : k
        deltaPesoSaidaBias(ka) = alpha * deltaK(ka);
    end
    
    
    %Escondida
    deltaInJ = zeros(1,p);
    for pa = 1 : p
        for ka = 1 : k
            deltaInJ(1,pa) = deltaInJ(1,pa) + deltaK(ka) * pesoSaida(pa,ka);
        end
    end
    
    deltaJ = zeros(1,p);
    
    for pa = 1 : p
        deltaJ(pa) = deltaInJ(pa) * flinha(z(pa));
    end
    
    deltaPesoEscondida = zeros(n, p);
    for na = 1 : n
       for pa = 1 : p
           deltaPesoEscondida(na, pa) = alpha * deltaJ(pa) * entrada(na,1);
       end
    end
    %Bias Escondida
    deltaPesoBiasEscondida = zeros(1, p);
    for pa = 1 : p
        deltaPesoBiasEscondida(pa) = alpha * deltaJ(pa);
    end
    
    %Ajustar Rede
    for na = 1 : n
       for pa = 1 : p
           pesoEscondida(na, pa) = pesoEscondida(na, pa) + deltaPesoEscondida(na, pa);
       end
    end
    
     for ka = 1 : k
        for pa = 1 : p
            pesoSaida(pa,ka) = pesoSaida(pa,ka) + deltaPesoSaida(pa,ka);
        end
     end
    
     for pa = 1 : p
        pesoBiasEscondida(pa) = pesoBiasEscondida(pa) + deltaPesoBiasEscondida(pa);
     end
    
     for a = 1 : k
        pesoBiasSaida(ka) = pesoBiasSaida(ka) + deltaPesoSaidaBias(ka);
    end
    
end
