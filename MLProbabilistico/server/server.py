from flask import Flask
from flask import request
from flask_cors import CORS, cross_origin
import pickle
from sklearn.ensemble import RandomForestClassifier

app = Flask(__name__)
cors = CORS(app)

@app.route('/api/v1/licenses/predict', methods=['POST'])
@cross_origin()
def predict():
    body = request.json

    data = [[
        body["numDC_SDP"], body["numDC_AIR"], body["numDC_CCN"], body["numDC_OCC"], body["numCDR_CONFB"],
        body["numCDR_CONFNB"], body["numCDR_CALLB"], body["numCDR_CALLNB"], body["numCDR_DATOSB"],
        body["TPS_Voice"], body["TPS_SMS"], body["TPS_CCNGY_SSU"], body["TPS_OCCGY_SSU"], body["TPS_OCCGY_CR"],
        body["TPS_CCNGY_CR"]
    ]]

    with open('./models/modeloRandomForest.pkl', 'rb') as f:
        modeloCargado = pickle.load(f)
    
    if modeloCargado:
        prediction = modeloCargado.predict(data)
    
    response =  { 
        "prediccion": str(prediction[0])
    }

    return response



@app.route('/')
@cross_origin()
def main():
    print('Ping success..')
    return "Hello! :D Ping Success..."


if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8080, debug=True)