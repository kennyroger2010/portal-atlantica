#include "totvs.ch"
#include "restful.ch"
#include "topconn.ch"

#DEFINE MSGERRO "Nenhum registro encontrado!"

WSRESTFUL dashboard DESCRIPTION "Servico para acessar indicadores."

    WSMETHOD GET numcli DESCRIPTION "Número de Clientes"  WSSYNTAX "/dashboard/numcli"  PATH "/dashboard/numcli" PRODUCES APPLICATION_JSON 

END WSRESTFUL

//-------------------------------------------------------------------
/*/{Protheus.doc} anoant
Método get para retornar Faturamento do Ano Anterior
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD GET numcli WSSERVICE dashboard

    Local lRet    := .T.
    Local cJson   := ""
    Local nTotal  := 0
    Local cSql    := ""
    Local cCodVen := ""

    SA3->(DbSetOrder(7))
    If SA3->(DbSeek(xFilial("SA3") + RetCodUsr()))
        cCodVen := SA3->A3_COD
    EndIf    

    cSql := "   SELECT COUNT(*) TOTAL "
    cSql += "     FROM " + RetSqlName("SA1") + " SA1 "
    cSql += "    WHERE SA1.A1_FILIAL  = '" + xFilial("SA1") + "' "
    cSql += "      AND SA1.A1_VEND    = '" + cCodVen + "' "        
    cSql += "      AND SA1.D_E_L_E_T_ = '' "
    
    cJson := U_GetJson(cSql)

    If !Empty(cJson)
        ::setResponse(EncodeUTF8('{"data":[' + cJson + ']}'))
    Else
        setRestFault(400, EncodeUTF8(MSGERRO))
        lRet := .F.
    EndIf

RETURN lRet
