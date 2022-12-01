#include "totvs.ch"
#include "restful.ch"
#include "topconn.ch"

WSRESTFUL produto DESCRIPTION "Servico para acessar dados dos produtos."

    WSDATA pageNumber AS INTEGER
    WSDATA rowsPage   AS INTEGER
    WSDATA sortField  AS STRING
    WSDATA sort       AS STRING
    WSDATA search     AS STRING    
    WSDATA id         AS STRING

    WSMETHOD GET ListaProdutos  DESCRIPTION "Lista de produtos" WSSYNTAX "/produto"      PATH "/produto"
    WSMETHOD GET RetornaProduto DESCRIPTION "Retorna Produto"   WSSYNTAX "/produto/{id}" PATH "/produto/{id}" 
    WSMETHOD POST   DESCRIPTION "Inclui Produto" WSSYNTAX "/produto"
    WSMETHOD PUT    DESCRIPTION "Altera Produto" WSSYNTAX "/produto"
    WSMETHOD DELETE DESCRIPTION "Exclui Produto" WSSYNTAX "/produto"

END WSRESTFUL

//-------------------------------------------------------------------
/*/{Protheus.doc} produto
Método get para retornar os dados do produto
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD GET ListaProdutos WSRECEIVE pageNumber, rowsPage, sortField, sort, search WSSERVICE produto

    Local lRet    := .T.
    Local cJson   := ""
    Local cSql    := ""
    Local nTotal  := 0
    Local aFilter := {"B1_COD", "B1_DESC", "BM_DESC"}
    Local cFilter := ""
    Local nX      := 0

    Default ::pageNumber := 0
    Default ::rowsPage   := 0
    Default ::sortField  := ""
    Default ::sort       := ""
    Default ::search     := ""
    
    ::SetContentType("application/json")

    //--------------------------------------
    // Montar string de filtro.
    //--------------------------------------
    cFilter += " AND ("
    For nX := 1 To Len(aFilter)
        cFilter += aFilter[nX] + " LIKE '%" + ::search + "%'"
        If nX < Len(aFilter)
            cFilter += " OR "
        EndIf
    Next
    cFilter += ")"

    //--------------------------------------
    // Total de registros.
    //--------------------------------------
    cSql := "    SELECT ISNULL(COUNT(*), 0) TOTAL "
    cSql += "      FROM " + RetSqlName("SB1") + " SB1 "
    cSql += " LEFT JOIN " + RetSqlName("SBM") + " SBM "
    cSql += "        ON SBM.BM_FILIAL  = '" + xFilial("SBM") + "' "
    cSql += "       AND SBM.BM_GRUPO   = SB1.B1_GRUPO "
    cSql += "       AND SBM.D_E_L_E_T_ = ' ' "
    cSql += "     WHERE SB1.B1_FILIAL  = '" + xFilial("SB1") + "' "
    cSql += "       AND SB1.D_E_L_E_T_ = ' ' "

    If !Empty(::search)
        cSql += cFilter
    EndIf

    TCQUERY cSql NEW ALIAS qQuery

    nTotal := qQuery->TOTAL

    qQuery->(DbCloseArea())

    //--------------------------------------
    // Seleciona registros.
    //--------------------------------------
    cSql := "    SELECT B1_FILIAL, "
    cSql += "           B1_COD,    "
    cSql += "           B1_DESC,   "
    cSql += "           B1_TIPO,   "
    cSql += "           B1_UM,     "
    cSql += "           B1_LOCPAD, "
    cSql += "           B1_GRUPO,  "
    cSql += "           B1_PRV1,   "
    cSql += "           BM_DESC    "
    cSql += "      FROM " + RetSqlName("SB1") + " SB1 "
    cSql += " LEFT JOIN " + RetSqlName("SBM") + " SBM "
    cSql += "        ON SBM.BM_FILIAL  = '" + xFilial("SBM") + "' "
    cSql += "       AND SBM.BM_GRUPO   = SB1.B1_GRUPO "
    cSql += "       AND SBM.D_E_L_E_T_ = ' ' "
    cSql += "     WHERE SB1.B1_FILIAL  = '" + xFilial("SB1") + "' "
    cSql += "       AND SB1.D_E_L_E_T_ = ' ' "

    If !Empty(::search)
        cSql += cFilter
    EndIf

    If Empty(::sortField) .Or. ::sortField == 'created'
        cSql += " ORDER BY SB1.B1_COD "
    Else
        cSql += " ORDER BY " + ::sortField + " " + ::sort
    EndIf

    cJson := U_GetJson(cSql, ::pageNumber, ::rowsPage)

    If !Empty(cJson)

        ::setResponse(EncodeUTF8('{"data":[' + cJson + '],"total":' + cValToChar(nTotal) + '}'))

    Else

        setRestFault(400, EncodeUTF8("Nenhum registro encontrado!"))
        lRet := .F.

    EndIf

RETURN lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} produto
Método get para retornar os dados do produto
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD GET RetornaProduto PATHPARAM id WSSERVICE produto

    Local lRet    := .T.
    Local cJson   := ""
    Local cSql    := ""

    ::SetContentType("application/json")
    
    //--------------------------------------
    // Seleciona registros.
    //--------------------------------------
    cSql := "    SELECT B1_FILIAL, "
    cSql += "           B1_COD,    "
    cSql += "           B1_DESC,   "
    cSql += "           B1_TIPO,   "
    cSql += "           B1_UM,     "
    cSql += "           B1_LOCPAD, "
    cSql += "           B1_GRUPO,  "
    cSql += "           B1_PRV1,   "
    cSql += "           BM_DESC    "
    cSql += "      FROM " + RetSqlName("SB1") + " SB1 "
    cSql += " LEFT JOIN " + RetSqlName("SBM") + " SBM "
    cSql += "        ON SBM.BM_FILIAL  = '" + xFilial("SBM") + "' "
    cSql += "       AND SBM.BM_GRUPO   = SB1.B1_GRUPO "
    cSql += "       AND SBM.D_E_L_E_T_ = ' ' "
    cSql += "     WHERE SB1.B1_FILIAL  = '" + xFilial("SB1") + "' "
    cSql += "       AND SB1.D_E_L_E_T_ = ' ' "
    cSql += "       AND SB1.B1_COD = '" + ::id + "' "

    cJson := U_GetJson(cSql)

    If !Empty(cJson)

        ::setResponse(EncodeUTF8('{"data":' + cJson + '}'))

    Else

        setRestFault(400, EncodeUTF8("Nenhum registro encontrado!"))
        lRet := .F.

    EndIf

RETURN lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} produto
Método post utilizado para incluir produto.
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD POST WSSERVICE produto

    Local lRet      := .T.
    Local oObj      := Nil
    Local aRegistro := {}
    Local aErro     := {}
    Local cErro     := ""
    Local nX        := 0

    Private lMsErroAuto    := .F.
    Private lAutoErrNoFile := .T.

    lRet := FwJsonDeserrialize(::getContent(), @oObj)

    If lRet

        aAdd(aRegistro, {"B1_FILIAL", xFilial("SB1"), Nil})
        aAdd(aRegistro, {"B1_COD",    oObj:B1_COD,    Nil})
        aAdd(aRegistro, {"B1_DESC",   oObj:B1_DESC,   Nil})
        aAdd(aRegistro, {"B1_TIPO",   oObj:B1_TIPO,   Nil})
        aAdd(aRegistro, {"B1_UM",     oObj:B1_UM,     Nil})
        aAdd(aRegistro, {"B1_LOCPAD", oObj:B1_LOCPAD, Nil})
        aAdd(aRegistro, {"B1_GRUPO",  oObj:B1_GRUPO,  Nil})
        aAdd(aRegistro, {"B1_PRV1",   oObj:B1_PRV1,   Nil})

        MsExecAuto({|x,y| Mata010(x,y)}, aRegistro, 3)

        If !lMsErroAuto

            ::setResponse(EncodeUTF8('{"mesage":"Registro incluído com sucesso"}'))

        Else

            aErro := GetAutoGRLog()
            
            For nX := 1 To Len(aErro)
                cErro += aErro[nX] + Chr(10)
            Next

            setRestFault(400, EncodeUTF8(cErro))
            lRet := .F.

        EndIf

    Else

        setRestFault(500, EncodeUTF8("Erro ao montar o objeto!"))
        lRet := .F.

    EndIf

RETURN lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} produto
Método put utilizado para alterar produto.
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD PUT WSSERVICE produto

    Local lRet      := .T.
    Local oObj      := Nil
    Local aRegistro := {}
    Local aErro     := {}
    Local cErro     := ""
    Local nX        := 0

    Private lMsErroAuto    := .F.
    Private lAutoErrNoFile := .T.

    lRet := FwJsonDeserrialize(::getContent(), @oObj)

    If lRet

        aAdd(aRegistro, {"B1_FILIAL", xFilial("SB1"), Nil})
        aAdd(aRegistro, {"B1_COD",    oObj:B1_COD,    Nil})
        aAdd(aRegistro, {"B1_DESC",   oObj:B1_DESC,   Nil})
        aAdd(aRegistro, {"B1_TIPO",   oObj:B1_TIPO,   Nil})
        aAdd(aRegistro, {"B1_UM",     oObj:B1_UM,     Nil})
        aAdd(aRegistro, {"B1_LOCPAD", oObj:B1_LOCPAD, Nil})
        aAdd(aRegistro, {"B1_GRUPO",  oObj:B1_GRUPO,  Nil})
        aAdd(aRegistro, {"B1_PRV1",   oObj:B1_PRV1,   Nil})

        MsExecAuto({|x,y| Mata010(x,y)}, aRegistro, 4)

        If !lMsErroAuto

            ::setResponse(EncodeUTF8('{"mesage":"Registro alterado com sucesso"}'))

        Else

            aErro := GetAutoGRLog()
            
            For nX := 1 To Len(aErro)
                cErro += aErro[nX] + Chr(10)
            Next

            setRestFault(400, EncodeUTF8(cErro))
            lRet := .F.

        EndIf

    Else

        setRestFault(500, EncodeUTF8("Erro ao montar o objeto!"))
        lRet := .F.

    EndIf

RETURN lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} produto
Método delete utilizado para excluir produto.
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD DELETE WSSERVICE produto

    Local lRet      := .T.
    Local oObj      := Nil
    Local aRegistro := {}
    Local aErro     := {}
    Local cErro     := ""
    Local nX        := 0

    Private lMsErroAuto    := .F.
    Private lAutoErrNoFile := .T.

    lRet := FwJsonDeserrialize(::getContent(), @oObj)

    If lRet

        aAdd(aRegistro, {"B1_FILIAL", xFilial("SB1"), Nil})
        aAdd(aRegistro, {"B1_COD",    oObj:B1_COD,    Nil})

        MsExecAuto({|x,y| Mata010(x,y)}, aRegistro, 5)

        If !lMsErroAuto

            ::setResponse(EncodeUTF8('{"mesage":"Registro excluído com sucesso"}'))

        Else

            aErro := GetAutoGRLog()
            
            For nX := 1 To Len(aErro)
                cErro += aErro[nX] + Chr(10)
            Next

            setRestFault(400, EncodeUTF8(cErro))
            lRet := .F.

        EndIf

    Else

        setRestFault(500, EncodeUTF8("Erro ao montar o objeto!"))
        lRet := .F.

    EndIf

RETURN lRet
