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
        function result = Treinar(obj, dadosEntrada, linha, epocaMax, alpha, alphaDecai, erroMin, k, fileID)
            
            saida = [[1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1]; 
                    [-1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1]];
            
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
            obj.k = 26;
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

            %Gera��o Aleat�rias de pesos
            %Bias
            obj.pesoBiasEscondida = 1 - 2. * rand(1, obj.p);
            obj.pesoBiasSaida = 1 - 2. * rand(1, obj.k);

            %Escondida
            obj.pesoEscondida = 1 - 2. * rand(obj.n, obj.p);
            obj.pesoSaida = 1 - 2. * rand(obj.p, obj.k);

            %erro
            erroTotal = zeros(obj.epocaMax);
            erros = 0;
            %Rede Algoritimo
            for epoca = 1: epocaMax
                for i = 1:k
                    if(i ~= linha)
                        for j = 1:size(dadosEntrada, 2)
                            arquivo = dadosEntrada(i, j, 1);
                            saidaMatriz = 0;
                            if contains(arquivo, "_A_") == 1
                                saidaMatriz = 1;
                                
                            elseif contains(arquivo, "_B_") == 1                
                                saidaMatriz = 2;
                                
                            elseif contains(arquivo, "_C_") == 1                
                                saidaMatriz = 3;
                                
                            elseif contains(arquivo, "_D_") == 1                
                                saidaMatriz = 4;
                                
                            elseif contains(arquivo, "_E_") == 1                
                                saidaMatriz = 5;
                                
                            elseif contains(arquivo, "_F_") == 1                
                                saidaMatriz = 6;
                                
                            elseif contains(arquivo, "_G_") == 1                
                                saidaMatriz = 7;
                                
                            elseif contains(arquivo, "_H_") == 1                
                                saidaMatriz = 8;
                                
                            elseif contains(arquivo, "_I_") == 1                
                                saidaMatriz = 9;
                                
                            elseif contains(arquivo, "_J_") == 1                
                                saidaMatriz = 10;
                                
                            elseif contains(arquivo, "_K_") == 1                
                                saidaMatriz = 11;
                                
                            elseif contains(arquivo, "_L_") == 1                
                                saidaMatriz = 12;
                                
                            elseif contains(arquivo, "_M_") == 1                
                                saidaMatriz = 13;
                                
                            elseif contains(arquivo, "_N_") == 1                
                                saidaMatriz = 14;
                                
                            elseif contains(arquivo, "_O_") == 1                
                                saidaMatriz = 15;
                                
                            elseif contains(arquivo, "_P_") == 1                
                                saidaMatriz = 16;
                                
                            elseif contains(arquivo, "_Q_") == 1                
                                saidaMatriz = 17;
                            elseif contains(arquivo, "_R_") == 1                
                                saidaMatriz = 18;
                            elseif contains(arquivo, "_S_") == 1                
                                saidaMatriz = 19;
                            elseif contains(arquivo, "_T_") == 1                
                            elseif contains(arquivo, "_U_") == 1                
                                saidaMatriz = 21;
                            elseif contains(arquivo, "_V_") == 1                
                                saidaMatriz = 22;
                            elseif contains(arquivo, "_W_") == 1                
                                saidaMatriz = 23;
                            elseif contains(arquivo, "_X_") == 1                
                                saidaMatriz = 24;
                            elseif contains(arquivo, "_Y_") == 1                
                                saidaMatriz = 25;
                            elseif contains(arquivo, "_Z_") == 1                
                                saidaMatriz = 26;
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

                            %Aplicar a fun��o
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

                            %Aplicar a fun��o
                            y = zeros(1,obj.k);
                            for ka = 1 : obj.k
                                y(ka) = G(y_in(ka));
                            end

                            %Erro Quadradico m�dio
                            erro_ind = zeros(1,obj.k);
                            for ka = 1 : obj.k
                                erro_ind(ka) = saida(saidaMatriz,ka) - y(ka);
                            end
                            erroDaEpoca = sum(abs(erro_ind));

                            erroTotal(epoca) = erroTotal(epoca) + erroDaEpoca;

                            %Ajustes
                            deltaK = zeros(1,obj.k);
                            for ka = 1 : obj.k
                                deltaK(ka) = erro_ind(ka) * flinha(y_in(ka));
                            end

                            disp(['�poca: ', num2str(epoca)]);
                            disp(['Saida: ', num2str(y)]);
                            disp(['SaidaEsp: ', num2str(saida(saidaMatriz))]);
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
                erros = erros + 1;
                %Caso atingir o erro minimo
                if (erroDaEpoca < erroMin)
                    disp('A rede atingiu o erro minimo: ');
                    break;
                end
            end
            erroTot = 0;
            
            for i=1:erros
                erroTot = erroTot + erroTotal(i);
            end
            
            erroTot = erroTot / erros;
                
            fprintf(fileID, strcat(num2str(erroTot),";"));
            result = obj;
        end
        
        function erro = Teste(obj, dadosEntrada, linha)
            ErroFold = 0;
            
            saida = [[1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1]; 
                    [-1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1 -1];
                    [-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 1]];
            
            MatrizConfusao = zeros(26,26);
            
            for j = 1:size(dadosEntrada, 2)
                arquivo = dadosEntrada(linha, j, 1);
                saidaMatriz = 0;
                if contains(arquivo, "_A_") == 1
                    saidaMatriz = 1;
                    
                elseif contains(arquivo, "_B_") == 1                
                    saidaMatriz = 2;
                    
                elseif contains(arquivo, "_C_") == 1                
                    saidaMatriz = 3;
                    
                elseif contains(arquivo, "_D_") == 1                
                    saidaMatriz = 4;
                    
                elseif contains(arquivo, "_E_") == 1                
                    saidaMatriz = 5;
                    
                elseif contains(arquivo, "_F_") == 1                
                    saidaMatriz = 6;
                    
                elseif contains(arquivo, "_G_") == 1                
                    saidaMatriz = 7;
                    
                elseif contains(arquivo, "_H_") == 1                
                    saidaMatriz = 8;
                    
                elseif contains(arquivo, "_I_") == 1                
                    saidaMatriz = 9;
                    
                elseif contains(arquivo, "_J_") == 1                
                    saidaMatriz = 10;
                    
                elseif contains(arquivo, "_K_") == 1                
                    saidaMatriz = 11;
                    
                elseif contains(arquivo, "_L_") == 1                
                    saidaMatriz = 12;
                    
                elseif contains(arquivo, "_M_") == 1                
                    saidaMatriz = 13;
                    
                elseif contains(arquivo, "_N_") == 1                
                    saidaMatriz = 14;
                    
                elseif contains(arquivo, "_O_") == 1                
                    saidaMatriz = 15;
                    
                elseif contains(arquivo, "_P_") == 1                
                    saidaMatriz = 16;
                    
                elseif contains(arquivo, "_Q_") == 1                
                    saidaMatriz = 17;
                    
                elseif contains(arquivo, "_R_") == 1                
                    saidaMatriz = 18;
                    
                elseif contains(arquivo, "_S_") == 1                
                    saidaMatriz = 19;
                    
                elseif contains(arquivo, "_T_") == 1                
                    saidaMatriz = 20;
                    
                elseif contains(arquivo, "_U_") == 1                
                    saidaMatriz = 21;
                    
                elseif contains(arquivo, "_V_") == 1                
                    saidaMatriz = 22;
                    
                elseif contains(arquivo, "_W_") == 1                
                    saidaMatriz = 23;
                    
                elseif contains(arquivo, "_X_") == 1                
                    saidaMatriz = 24;
                    
                elseif contains(arquivo, "_Y_") == 1                
                    saidaMatriz = 25;
                    
                elseif contains(arquivo, "_Z_") == 1                
                    saidaMatriz = 26;
                    
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

                %Aplicar a fun��o
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

                %Aplicar a fun��o
                y = zeros(1,obj.k);
                for ka = 1 : obj.k
                    y(ka) = G(y_in(ka));
                end

                %Erro Quadradico m�dio
                erro_ind = zeros(1,obj.k);
                for ka = 1 : obj.k
                    erro_ind(ka) = saida(saidaMatriz,ka) - y(ka);
                end
                erroDaEpoca = sum(abs(erro_ind));

                ErroFold = ErroFold + erroDaEpoca;
                resultadoObtido = 0;
                erroResultado = 99999999999999;
                for i=1:26
                    erroAtual = 0
                    for i2=1:obj.k
                        erroAtual = erroAtual + ((y(i2) - saida(i,i2)) ^ 2);
                    end
                    if(erroAtual < erroResultado)
                        erroResultado = erroAtual;
                        resultadoObtido = i;
                    end
                end
                MatrizConfusao(resultadoObtido,saidaMatriz) = MatrizConfusao(resultadoObtido,saidaMatriz) + 1;
            end
            
            fileID3 = fopen('matrizConfusao.txt', 'w');
            fprintf(fileID3,strcat("Matriz de Confus�o. Execucao em: ", datestr(now), "\r\n"));
            fprintf(fileID3,"A\tB\tC\tD\tE\tF\tG\tH\tI\tJ\tK\tL\tM\tN\tO\tP\tQ\tR\tS\tT\tU\tV\tW\tX\tY\tZ\r\n");
            fprintf(fileID3,"%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\t%d\r\n", MatrizConfusao);
            fclose(fileID3);
            
            erro = ErroFold;
        end
    end    
end

