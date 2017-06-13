mlp = MLP();
kFold = KFoldCrossValidation(5,mlp,'C:\Users\raulg\OneDrive\Documentos\MATLAB\epia\dataset1\treinamento');
ExecuteCrossValidation(kFold,0.0001,1,0.01,1000);