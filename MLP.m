classdef MLP
    %MLP Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        epocaMax
        alpha
        alphaDecai
        erroMin
        pesoBiasEscondida
        pesoBiasSaida
        pesoEscondida
        pesoSaida
        n
        k
        p
        entrada
    end
    
    methods
        function result = Treinar(obj, dadosEntrada, linha, epocaMax, alpha, alphaDecai, erroMin, k)
            %Entrada Pegar a entrada
            %================================================================================================================================%
            localIMG = '00001';
            localimg = strcat('C:\Users\raulg\OneDrive\Documentos\MATLAB\epia\dataset1\treinamento\train_5a_',localIMG);
            localimg = strcat(localimg, '.png');
            disp(localimg);
            img = imread(localimg);
            obj.entrada = HOG(img,16);
            %================================================================================================================================%
            
            %Configuracao Rede
            %=============================================%
            %Neuronios na camada de entrada;
            obj.n = size(obj.entrada,1);
            %Neuronios na camada de saida;
            obj.k = 3;
            %Neuronios na camada escondida;
            obj.p = round ((obj.n + obj.k) /2);
            %Numero de epocas
            obj.epocaMax = epocaMax;
            %Taxa de aprendizado
            obj.alpha  = alpha;
            %Decaimento alpha se 1 = (sem decaimento)
            obj.alphaDecai = alphaDecai;
            %Erro minimo
            obj.erroMin = erroMin;
            %=============================================%

            %Geração Aleatórias de pesos
            %Bias
            obj.pesoBiasEscondida = 1 - 2. * rand(1, obj.p);
            obj.pesoBiasSaida = 1 - 2. * rand(1, obj.k);

            %Escondida
            obj.pesoEscondida = 1 - 2. * rand(obj.n, obj.p);
            obj.pesoSaida = 1 - 2. * rand(obj.p, obj.k);

            %erro
            erroTotal = zeros(obj.epocaMax);
            
            %Rede Algoritimo
            for epoca = 1: epocaMax
                for i = 1:k
                    if(i ~= linha)
                        for j = 1:size(dadosEntrada, 2)
                            arquivo = dadosEntrada(i, j, 1);
                            if contains(arquivo, "_58_") == 1
                                saidaEsp = [1 -1 -1];
                            elseif contains(arquivo, "_53_") == 1
                                saidaEsp = [-1 1 -1];
                            else
                                saidaEsp = [-1 -1 1];
                            end
                            if(arquivo == "")
                                continue;
                            end
                            
                            img = imread(char(arquivo));
                            obj.entrada = HOG(img,16);
                            
                            z_in = zeros (1,obj.p);

                            for pa = 1 : obj.p
                                for na = 1 : obj.n
                                    z_in(pa) = z_in(pa) + obj.entrada(na, 1) * obj.pesoEscondida(na, pa);
                                end
                            end
                            for pa = 1 : obj.p
                                z_in(pa) = z_in(pa) + 1 * obj.pesoBiasEscondida(1, pa);
                            end

                            %Aplicar a função
                            z = zeros(1,obj.p);
                            for pa = 1 : obj.p
                                z(pa) = F(z_in(pa));
                            end

                            y_in = zeros(1,obj.k);
                            for ka = 1 : obj.k
                                for pa = 1 : obj.p
                                    y_in(ka) = y_in(ka) + z(pa) * obj.pesoSaida(pa, ka);
                                end
                            end
                            for ka = 1 : obj.k
                                y_in(ka) = y_in(ka) + 1 * obj.pesoBiasSaida(1, ka);
                            end

                            %Aplicar a função
                            y = zeros(1,obj.k);
                            for ka = 1 : obj.k
                                y(ka) = G(y_in(ka));
                            end

                            %Erro Quadradico médio
                            erro_ind = zeros(1,obj.k);
                            for ka = 1 : obj.k
                                erro_ind(ka) = saidaEsp(ka) - y(ka);
                            end
                            erroDaEpoca = sum(abs(erro_ind));

                            erroTotal(epoca) = erroTotal(epoca) + erroDaEpoca;

                            %Ajustes
                            deltaK = zeros(1,obj.k);
                            for ka = 1 : obj.k
                                deltaK(ka) = erro_ind(ka) * flinha(y_in(ka));
                            end

                            disp(['Época: ', num2str(epoca)]);
                            disp(['Saida: ', num2str(y)]);
                            disp(['SaidaEsp: ', num2str(saidaEsp)]);
                            disp(['Erro Individual: ', num2str(erro_ind)]);
                            disp(['Delta K ', num2str(deltaK)]);
                            disp(['Erro epoca', num2str(sum(erro_ind))]);
                            %Saida
                            deltaPesoSaida = zeros(obj.p,obj.k);

                            for ka = 1 : obj.k
                                for pa = 1 : obj.p
                                    deltaPesoSaida(pa,ka) = obj.alpha * deltaK(ka) * z(pa);
                                end
                            end

                            %Bias Saida
                            deltaPesoSaidaBias = zeros(1,obj.k);
                            for a = 1 : obj.k
                                deltaPesoSaidaBias(ka) = obj.alpha * deltaK(ka);
                            end


                            %Escondida
                            deltaInJ = zeros(1,obj.p);
                            for pa = 1 : obj.p
                                for ka = 1 : obj.k
                                    deltaInJ(1,pa) = deltaInJ(1,pa) + deltaK(ka) * obj.pesoSaida(pa,ka);
                                end
                            end

                            deltaJ = zeros(1,obj.p);

                            for pa = 1 : obj.p
                                deltaJ(pa) = deltaInJ(pa) * flinha(z(pa));
                            end

                            deltaPesoEscondida = zeros(obj.n, obj.p);
                            for na = 1 : obj.n
                               for pa = 1 : obj.p
                                   deltaPesoEscondida(na, pa) = obj.alpha * deltaJ(pa) * obj.entrada(na,1);
                               end
                            end
                            %Bias Escondida
                            deltaPesoBiasEscondida = zeros(1, obj.p);
                            for pa = 1 : obj.p
                                deltaPesoBiasEscondida(pa) = obj.alpha * deltaJ(pa);
                            end

                            %Ajustar Rede
                            for na = 1 : obj.n
                               for pa = 1 : obj.p
                                   obj.pesoEscondida(na, pa) = obj.pesoEscondida(na, pa) + deltaPesoEscondida(na, pa);
                               end
                            end

                             for ka = 1 : obj.k
                                for pa = 1 : obj.p
                                    obj.pesoSaida(pa,ka) = obj.pesoSaida(pa,ka) + deltaPesoSaida(pa,ka);
                                end
                             end

                             for pa = 1 : obj.p
                                obj.pesoBiasEscondida(pa) = obj.pesoBiasEscondida(pa) + deltaPesoBiasEscondida(pa);
                             end

                             for a = 1 : obj.k
                                obj.pesoBiasSaida(ka) = obj.pesoBiasSaida(ka) + deltaPesoSaidaBias(ka);
                             end
                        end
                    end
                end
                %Caso atingir o erro minimo
                if (erroDaEpoca < erroMin)
                    disp('A rede atingiu o erro minimo: ');
                    break;
                end
            end
            
            result = obj;
        end
        
        function erro = Teste(obj, dadosEntrada, linha)
            ErroFold = 0;
            
            for j = 1:size(dadosEntrada, 2)
                arquivo = dadosEntrada(linha, j, 1);
                if contains(arquivo, "_58_") == 1
                    saidaEsp = [1 -1 -1];
                elseif contains(arquivo, "_53_") == 1
                    saidaEsp = [-1 1 -1];
                else
                    saidaEsp = [-1 -1 1];
                end
                if(arquivo == "")
                    continue;
                end

                img = imread(char(arquivo));
                obj.entrada = HOG(img,16);

                z_in = zeros (1,obj.p);

                for pa = 1 : obj.p
                    for na = 1 : obj.n
                        z_in(pa) = z_in(pa) + obj.entrada(na, 1) * obj.pesoEscondida(na, pa);
                    end
                end
                for pa = 1 : obj.p
                    z_in(pa) = z_in(pa) + 1 * obj.pesoBiasEscondida(1, pa);
                end

                %Aplicar a função
                z = zeros(1,obj.p);
                for pa = 1 : obj.p
                    z(pa) = F(z_in(pa));
                end

                y_in = zeros(1,obj.k);
                for ka = 1 : obj.k
                    for pa = 1 : obj.p
                        y_in(ka) = y_in(ka) + z(pa) * obj.pesoSaida(pa, ka);
                    end
                end
                for ka = 1 : obj.k
                    y_in(ka) = y_in(ka) + 1 * obj.pesoBiasSaida(1, ka);
                end

                %Aplicar a função
                y = zeros(1,obj.k);
                for ka = 1 : obj.k
                    y(ka) = G(y_in(ka));
                end

                %Erro Quadradico médio
                erro_ind = zeros(1,obj.k);
                for ka = 1 : obj.k
                    erro_ind(ka) = saidaEsp(ka) - y(ka);
                end
                erroDaEpoca = sum(abs(erro_ind));

                ErroFold = ErroFold + erroDaEpoca;
                            
            end
            
            erro = ErroFold;
        end
    end    
end

