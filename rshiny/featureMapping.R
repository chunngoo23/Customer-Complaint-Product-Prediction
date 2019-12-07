
## Previous author's feature engineering function
#feature_mapping = function(df){
#  new_data = c()
  
#  for(i in 1:6){
#    for(j in 0:i){
#      temp = (df$Test1)^i + (df$Test2)^(i-j)
#      new_data = cbind(new_data,temp)
#    }
#  }
  
#  colnames(new_data) = paste0("V", 1:ncol(new_data))
#  new_data
#}

#a = c("Checking or savings account",
#      "Checking or savings account",
#      "Credit card or prepaid card",
#      "Debt collection",
#      "Credit reporting, credit repair services, or other personal consumer reports")

#b = c("how are you", " i am good", "how about you", "i love you", "oh really")
#py_run_string("from sklearn import preprocessing, decomposition, model_selection, metrics, pipeline")
#py_run_string("lbl_enc = preprocessing.LabelEncoder()")
#py_run_string("a_encoded = lbl_enc.fit_transform(a)") #b沒辦法被放進去 #but ytest can
#py_run_string ("a = [1,2,3]") #要換成nd.array
#py$a 

#tfvfit = py_load_object("tfvfit.pkl") 
#py_run_string("bb = tfvfit.transform(b)")#用python寫的variable無法共用到r
#py_run_string("print(bb)")


#py_run_string("predictions = clf.predict_proba(aa)")
#py_run_string(glue("result = loaded_model.score(xtest_tfv, y_encoded)")) #the input of x and y has to be already transformed
#py_run_string(glue("print(result)"))
#result

#df
#py_run_string("df  =  np.array(df)")



