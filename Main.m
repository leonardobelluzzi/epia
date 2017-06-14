mlp = MLP();
kFold = KFoldCrossValidation(3,mlp,'C:\Users\raulg\OneDrive\Documentos\MATLAB\epia\dataset1\treino');
ExecuteCrossValidation(kFold,0.0001,1,0.01,1);