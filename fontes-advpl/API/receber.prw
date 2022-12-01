#include "totvs.ch"
#include "restful.ch"
#include "topconn.ch"

WSRESTFUL receber DESCRIPTION "Servico para acessar dados dos títulos a receber."

    WSDATA pageNumber AS INTEGER
    WSDATA rowsPage   AS INTEGER
    WSDATA sortField  AS STRING
    WSDATA sort       AS STRING
    WSDATA id         AS STRING

    WSMETHOD GET DESCRIPTION "Lista de títulos a receber" WSSYNTAX "/receber"

END WSRESTFUL

//-------------------------------------------------------------------
/*/{Protheus.doc} receber
Método get para retornar os dados dos títulos a receber
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD GET WSRECEIVE pageNumber, rowsPage, sortField, sort, id WSSERVICE receber

    Local lRet    := .T.
    Local cJson   := ""
    Local cSql    := ""
    Local nTotal  := 0    

    Default ::pageNumber := 0
    Default ::rowsPage   := 0
    Default ::sortField  := ""
    Default ::sort       := ""
    Default ::id         := ""
    
    ::SetContentType("application/json")

    //--------------------------------------
    // Total de registros.
    //--------------------------------------
    cSql := "   SELECT ISNULL(COUNT(*), 0) TOTAL "
    cSql += "     FROM " + RetSqlName("SE1") + " SE1 "
    cSql += "    WHERE SE1.E1_FILIAL  = '" + xFilial("SE1") + "' "
    cSql += "      AND SE1.D_E_L_E_T_ = ' ' "
    cSql += "      AND SE1.E1_SALDO   > 0 "

    If !Empty(::id)
        cSql += "   AND SE1.E1_CLIENTE + SE1.E1_LOJA = '" + ::id + "' "
    EndIf

    TCQUERY cSql NEW ALIAS qQuery

    nTotal := qQuery->TOTAL

    qQuery->(DbCloseArea())

    //--------------------------------------
    // Seleciona registros.
    //--------------------------------------
    cSql := "    SELECT E1_FILIAL,  "
    cSql += "           E1_PREFIXO, "
    cSql += "           E1_NUM,     "
    cSql += "           E1_PARCELA, "
    cSql += "           E1_TIPO,    "
    cSql += "           E1_NATUREZ, "    
    cSql += "           ED_DESCRIC, "
    cSql += "           E1_CLIENTE, "
    cSql += "           E1_LOJA,    "
    cSql += "           E1_EMISSAO, "
    cSql += "           E1_VENCREA, "
    cSql += "           E1_VALOR,   "
    cSql += "           E1_SALDO    "
    cSql += "      FROM " + RetSqlName("SE1") + " SE1 "
    cSql += " LEFT JOIN " + RetSqlName("SED") + " SED "
    cSql += "        ON SED.ED_FILIAL = '" + xFilial("SED") + "' "
    cSql += "       AND SED.ED_CODIGO = SE1.E1_NATUREZ "
    cSql += "     WHERE SE1.E1_FILIAL  = '" + xFilial("SE1") + "' "
    cSql += "       AND SE1.D_E_L_E_T_ = ' ' "
    cSql += "       AND SE1.E1_SALDO   > 0 "

    If !Empty(::id)
        cSql += "   AND SE1.E1_CLIENTE + SE1.E1_LOJA = '" + ::id + "' "
    EndIf

    If Empty(::sortField) .Or. ::sortField == 'created'
        cSql += " ORDER BY E1_VENCREA, E1_NUM, E1_PARCELA "
    Else
        cSql += " ORDER BY " + ::sortField + " " + ::sort
    EndIf

    cJson := U_GetJson(cSql, ::pageNumber, ::rowsPage)

    If !Empty(cJson)

        ::setResponse('{"data":[' + cJson + '],"total":' + cValToChar(nTotal) + '}')

    Else

        setRestFault(400, "Nenhum registro encontrado!")
        lRet := .F.

    EndIf

RETURN lRet
