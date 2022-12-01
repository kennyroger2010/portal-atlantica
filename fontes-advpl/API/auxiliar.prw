#include "totvs.ch"
#include "restful.ch"
#include "topconn.ch"

#DEFINE MSGERRO "Nenhum registro encontrado!"

WSRESTFUL auxiliar DESCRIPTION "Servico para acessar dados auxiliares."

    WSMETHOD GET Tipos     DESCRIPTION "Lista de Tipos"     WSSYNTAX "/auxiliar/tipos"     PATH "/auxiliar/tipos"     PRODUCES APPLICATION_JSON 
    WSMETHOD GET Medidas   DESCRIPTION "Lista de Medidas"   WSSYNTAX "/auxiliar/medidas"   PATH "/auxiliar/medidas"   PRODUCES APPLICATION_JSON 
    WSMETHOD GET Locais    DESCRIPTION "Lista de Locais"    WSSYNTAX "/auxiliar/locais"    PATH "/auxiliar/locais"    PRODUCES APPLICATION_JSON 
    WSMETHOD GET Grupos    DESCRIPTION "Lista de Grupos"    WSSYNTAX "/auxiliar/grupos"    PATH "/auxiliar/grupos"    PRODUCES APPLICATION_JSON 
    WSMETHOD GET Estados   DESCRIPTION "Lista de Estados"   WSSYNTAX "/auxiliar/estados"   PATH "/auxiliar/estados"   PRODUCES APPLICATION_JSON 
    WSMETHOD GET Condicoes DESCRIPTION "Lista de Condições" WSSYNTAX "/auxiliar/condicoes" PATH "/auxiliar/condicoes" PRODUCES APPLICATION_JSON 
    WSMETHOD GET Tes       DESCRIPTION "Lista de Tes"       WSSYNTAX "/auxiliar/tes"       PATH "/auxiliar/tes"       PRODUCES APPLICATION_JSON 
    WSMETHOD GET Produtos  DESCRIPTION "Lista de Produtos"  WSSYNTAX "/auxiliar/produtos"  PATH "/auxiliar/produtos"  PRODUCES APPLICATION_JSON 
    WSMETHOD GET Clientes  DESCRIPTION "Lista de Clientes"  WSSYNTAX "/auxiliar/clientes"  PATH "/auxiliar/clientes"  PRODUCES APPLICATION_JSON 

END WSRESTFUL

//-------------------------------------------------------------------
/*/{Protheus.doc} ListaTipos
Método get para retornar a lista de tipos
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD GET Tipos WSSERVICE auxiliar

    Local lRet    := .T.
    Local cJson   := ""
    Local nTotal  := 0    
    Local aRet   := U_GetJsonAux("SX5", "X5_CHAVE", "X5_DESCRI", 1, "X5_FILIAL + X5_TABELA", xFilial("SX5") + "02")
    
    cJson  := aRet[1]
    nTotal := aRet[2]

    If !Empty(cJson)
        ::setResponse(EncodeUTF8('{"data":[' + cJson + '],"total":' + cValToChar(nTotal) + '}'))
    Else
        setRestFault(400, EncodeUTF8(MSGERRO))
        lRet := .F.
    EndIf

RETURN lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} ListaMedidas
Método get para retornar a lista de medidas
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD GET Medidas WSSERVICE auxiliar

    Local lRet    := .T.
    Local cJson   := ""
    Local nTotal  := 0    
    Local aRet    := U_GetJsonAux("SAH", "AH_UNIMED", "AH_UMRES", 1, "AH_FILIAL", xFilial("SAH"))
    
    cJson  := aRet[1]
    nTotal := aRet[2]

    If !Empty(cJson)
        ::setResponse(EncodeUTF8('{"data":[' + cJson + '],"total":' + cValToChar(nTotal) + '}'))
    Else
        setRestFault(400, EncodeUTF8(MSGERRO))
        lRet := .F.
    EndIf

RETURN lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} ListaLocais
Método get para retornar a lista de locais
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD GET Locais WSSERVICE auxiliar

    Local lRet    := .T.
    Local cJson   := ""
    Local nTotal  := 0    
    Local aRet    := U_GetJsonAux("NNR", "NNR_CODIGO", "NNR_DESCRI", 1, "NNR_FILIAL", xFilial("NNR"))
    
    cJson  := aRet[1]
    nTotal := aRet[2]

    If !Empty(cJson)
        ::setResponse(EncodeUTF8('{"data":[' + cJson + '],"total":' + cValToChar(nTotal) + '}'))
    Else
        setRestFault(400, EncodeUTF8(MSGERRO))
        lRet := .F.
    EndIf

RETURN lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} ListaGrupos
Método get para retornar a lista de grupos
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD GET Grupos WSSERVICE auxiliar

    Local lRet    := .T.
    Local cJson   := ""
    Local nTotal  := 0    
    Local aRet    := U_GetJsonAux("SBM", "BM_GRUPO", "BM_DESC", 1, "BM_FILIAL", xFilial("SBM"))
    
    cJson  := aRet[1]
    nTotal := aRet[2]

    If !Empty(cJson)
        ::setResponse(EncodeUTF8('{"data":[' + cJson + '],"total":' + cValToChar(nTotal) + '}'))
    Else
        setRestFault(400, EncodeUTF8(MSGERRO))
        lRet := .F.
    EndIf

RETURN lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} ListaEstados
Método get para retornar a lista de estados
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD GET Estados WSSERVICE auxiliar

    Local lRet    := .T.
    Local cJson   := ""
    Local nTotal := 0
    Local aRet    := U_GetJsonAux("SX5", "X5_CHAVE", "X5_DESCRI", 1, "X5_FILIAL + X5_TABELA", xFilial("SX5") + "12")
    
    cJson  := aRet[1]
    nTotal := aRet[2]

    If !Empty(cJson)
        ::setResponse(EncodeUTF8('{"data":[' + cJson + '],"total":' + cValToChar(nTotal) + '}'))
    Else
        setRestFault(400, EncodeUTF8(MSGERRO))
        lRet := .F.
    EndIf

RETURN lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} Condicoes
Método get para retornar a lista de condições de pagamento
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD GET Condicoes WSSERVICE auxiliar

    Local lRet    := .T.
    Local cJson   := ""
    Local nTotal  := 0
    Local aRet    := U_GetJsonAux("SE4", "E4_CODIGO", "E4_DESCRI", 1, "E4_FILIAL", xFilial("SE4"))
    
    cJson  := aRet[1]
    nTotal := aRet[2]

    If !Empty(cJson)
        ::setResponse(EncodeUTF8('{"data":[' + cJson + '],"total":' + cValToChar(nTotal) + '}'))
    Else
        setRestFault(400, EncodeUTF8(MSGERRO))
        lRet := .F.
    EndIf

RETURN lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} Tes
Método get para retornar a lista de tipos de entrada e saída.
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD GET Tes WSSERVICE auxiliar

    Local lRet    := .T.
    Local cJson   := ""
    Local nTotal  := 0
    Local aRet    := U_GetJsonAux("SF4", "F4_CODIGO", "F4_TEXTO", 1, "F4_FILIAL", xFilial("SF4"))
    
    cJson  := aRet[1]
    nTotal := aRet[2]

    If !Empty(cJson)
        ::setResponse(EncodeUTF8('{"data":[' + cJson + '],"total":' + cValToChar(nTotal) + '}'))
    Else
        setRestFault(400, EncodeUTF8(MSGERRO))
        lRet := .F.
    EndIf

RETURN lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} Produtos
Método get para retornar a lista de Produtos.
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD GET Produtos WSSERVICE auxiliar

    Local lRet    := .T.
    Local cJson   := ""
    Local nTotal  := 0
    Local cSql    := ""

    cSql := "   SELECT B1_COD value, B1_DESC viewValue, B1_UM "
    cSql += "     FROM " + RetSqlName("SB1") + " SB1 "
    cSql += "    WHERE SB1.B1_FILIAL  = '" + xFilial("SB1") + "' "
    cSql += "      AND SB1.D_E_L_E_T_ = '' "
    cSql += " ORDER BY SB1.B1_DESC "
    
    cJson  := U_GetJson(cSql)

    If !Empty(cJson)
        ::setResponse(EncodeUTF8('{"data":[' + cJson + '],"total":' + cValToChar(nTotal) + '}'))
    Else
        setRestFault(400, EncodeUTF8(MSGERRO))
        lRet := .F.
    EndIf

RETURN lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} Clientes
Método get para retornar a lista de Clientes.
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD GET Clientes WSSERVICE auxiliar

    Local lRet    := .T.
    Local cJson   := ""
    Local nTotal  := 0
    Local cSql    := ""
    Local cCodVen := ""

    SA3->(DbSetOrder(7))
    If SA3->(DbSeek(xFilial("SA3") + RetCodUsr()))
        cCodVen := SA3->A3_COD
    EndIf    

    cSql := "   SELECT A1_COD value, A1_NREDUZ viewValue, A1_LOJA, A1_NOME "
    cSql += "     FROM " + RetSqlName("SA1") + " SA1 "
    cSql += "    WHERE SA1.A1_FILIAL  = '" + xFilial("SA1") + "' "
    cSql += "      AND SA1.A1_VEND    = '" + cCodVen + "' "        
    cSql += "      AND SA1.D_E_L_E_T_ = '' "
    cSql += " ORDER BY SA1.A1_NREDUZ "
    
    cJson := U_GetJson(cSql)

    If !Empty(cJson)
        ::setResponse(EncodeUTF8('{"data":[' + cJson + '],"total":' + cValToChar(nTotal) + '}'))
    Else
        setRestFault(400, EncodeUTF8(MSGERRO))
        lRet := .F.
    EndIf

RETURN lRet
