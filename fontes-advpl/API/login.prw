#include "totvs.ch"
#include "restful.ch"
#include "topconn.ch"

WSRESTFUL login DESCRIPTION "Servico de login."

WSMETHOD get DESCRIPTION "Retorna usuario" WSSYNTAX "/login"

END WSRESTFUL

//-------------------------------------------------------------------
/*/{Protheus.doc} login
Método get para retornar os dados do usuário
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD GET WSRECEIVE WSSERVICE login

    Local lRet     := .T.
    Local cJson    := ""
    Local aInfUser := {}
    
    ::SetContentType("application/json")

    PSWORDER(2)

    PSWSEEK(cUserName)

    aInfUser := PSWRET()

    cJson := '{"data":{'
    cJson += '"nome":"'         + AllTrim(aInfUser[1][4])  + '",'
    cJson += '"departamento":"' + AllTrim(aInfUser[1][12]) + '",'
    cJson += '"cargo":"'        + AllTrim(aInfUser[1][13]) + '",'
    cJson += '"email":"'        + AllTrim(aInfUser[1][14]) + '"'
    cJson += '}'
    cJson += '}'

    ::setResponse(cJson)

RETURN lRet
