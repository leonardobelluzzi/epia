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
nnEntrada = size(entrada,1);
%Neuronios na camada de saida;
nnSaida = 3;
%Neuronios na camada escondida;
nnEscondida = round ((nnEntrada + nnSaida) /2);
%Numero de epocas
epocaMax = 10;
%Taxa de aprendizado
alpha  = 0.001;
%Decaimento alpha se 1 = (sem decaimento)
alphaDecai = 1;
%Erro minimo
erroMin = 0.001;
%=============================================%

%Geração Aleatórias de pesos
%Bias
pesoBiasEscondida = 1 - 2. * rand(1, nnEscondida);
pesoBiasSaida = 1 - 2. * rand(1, nnSaida);

%Escondida
pesoEscondida = 1 - 2. * rand(nnEntrada, nnEscondida);
pesoSaida = 1 - 2. * rand(nnEscondida, nnSaida);


%SaidaEsperada
saidaEsp = [1 -1 -1];

%erro
erroTotal = zeros(epocaMax);

%Rede Algoritimo
for epoca = 1: epocaMax
    z_in = zeros (nnEscondida);
    
    for a = 1 : nnEscondida
        for b = 1 : nnEntrada
            z_in(a) = z_in(a) + entrada(b, 1) * pesoEscondida(b, a);
        end
    end
    for a = 1 : nnEscondida
        z_in(a) = z_in(a) + 1 * pesoBiasEscondida(1, a);
    end
    
    %Aplicar a função
    z = zeros(nnEscondida);
    for a = 1 : nnEscondida
        z(a) = F(z_in(a));
    end
    
    y_in = zeros(nnSaida);
    for a = 1 : nnSaida
        for b = 1 : nnEscondida
            y_in(a) = y_in(a) + z(b) * pesoSaida(b, a);
        end
    end
    for a = 1 : nnSaida
        y_in(a) = y_in(a) + 1 * pesoBiasSaida(1, a);
    end
    
    %Aplicar a função
    y = zeros(1,nnSaida);
    for a = 1 : nnSaida
        y(a) = G(y_in(a));
    end
    
    %Erro Quadradico médio
    erro_ind = zeros(1,nnSaida);
    for a = 1 : nnSaida
        erro_ind(a) = saidaEsp(a) - y(a);
    end
    erroDaEpoca = sum(abs(erro_ind));
    
    erroTotal(epoca) = erroDaEpoca;
    
    %Caso atingir o erro minimo
    if (erroDaEpoca < erroMin)
        disp('A rede atingiu o erro minimo: ');
        break;
    end
    
    %Ajustes
    deltaK = zeros(1,nnSaida);
    for a = 1 : nnSaida
        deltaK(a) = erro_ind(a) * flinha(y_in(a));
    end
    
    disp(['Época: ', num2str(epoca)]);
    disp(['Saida: ', num2str(y)]);
    disp(['SaidaEsp: ', num2str(saidaEsp)]);
    disp(['Erro Individual: ', num2str(erro_ind)]);
    disp(['Delta K ', num2str(deltaK)]);
    %Saida
    deltaPesoSaida = zeros(nnEscondida,nnSaida);
    
    for a = 1 : nnSaida
        for b = 1 : nnEscondida
            deltaPesoSaida(b,a) = alpha * deltaK(a) * z(b);
        end
    end
    
    %Bias Saida
    for a = 1 : nnSaida
        deltaPesoSaidaBias(a) = alpha * deltaK(a);
    end
    
    
    %Escondida
    deltaInJ = zeros(1,nnEscondida);
    
    
    %Bias Escondida
    
    
    
    
    
end
