#include "totvs.ch"
#include "restful.ch"
#include "topconn.ch"

WSRESTFUL cliente DESCRIPTION "Servico para acessar dados dos clientes."

    WSDATA pageNumber AS INTEGER
    WSDATA rowsPage   AS INTEGER
    WSDATA sortField  AS STRING
    WSDATA sort       AS STRING
    WSDATA search     AS STRING    
    WSDATA id         AS STRING

    WSMETHOD GET ListaClientes  DESCRIPTION "Lista de clientes" WSSYNTAX "/cliente"      PATH "/cliente"
    WSMETHOD GET RetornaCliente DESCRIPTION "Retorna Cliente"   WSSYNTAX "/cliente/{id}" PATH "/cliente/{id}" 
    WSMETHOD POST   DESCRIPTION "Inclui Cliente" WSSYNTAX "/cliente"
    WSMETHOD PUT    DESCRIPTION "Altera Cliente" WSSYNTAX "/cliente"
    WSMETHOD DELETE DESCRIPTION "Exclui Cliente" WSSYNTAX "/cliente"

END WSRESTFUL

//-------------------------------------------------------------------
/*/{Protheus.doc} cliente
Método get para retornar os dados do cliente
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD GET ListaClientes WSRECEIVE pageNumber, rowsPage, sortField, sort, search WSSERVICE cliente

    Local lRet    := .T.
    Local cJson   := ""
    Local cSql    := ""
    Local nTotal  := 0
    Local aFilter := {"A1_COD", "A1_NOME", "A1_NREDUZ"}
    Local cFilter := ""
    Local nX      := 0
    Local cCodVen := ""

    Default ::pageNumber := 0
    Default ::rowsPage   := 0
    Default ::sortField  := ""
    Default ::sort       := ""
    Default ::search     := ""
    
    ::SetContentType("application/json")

    SA3->(DbSetOrder(7))
    If SA3->(DbSeek(xFilial("SA3") + RetCodUsr()))
        cCodVen := SA3->A3_COD
    EndIf

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
    cSql := "   SELECT ISNULL(COUNT(*), 0) TOTAL "
    cSql += "     FROM " + RetSqlName("SA1") + " SA1 "
    cSql += "    WHERE SA1.A1_FILIAL  = '" + xFilial("SA1") + "' "
    cSql += "      AND SA1.A1_VEND    = '" + cCodVen + "' "
    cSql += "      AND SA1.D_E_L_E_T_ = ' ' "

    If !Empty(::search)
        cSql += cFilter
    EndIf

    TCQUERY cSql NEW ALIAS qQuery

    nTotal := qQuery->TOTAL

    qQuery->(DbCloseArea())

    //--------------------------------------
    // Seleciona registros.
    //--------------------------------------
    cSql := "   SELECT A1_FILIAL, "
    cSql += "          A1_COD,    "
    cSql += "          A1_LOJA,   "
    cSql += "          A1_NOME,   "
    cSql += "          A1_NREDUZ, "
    cSql += "          A1_PESSOA, "
    cSql += "          A1_END,    "
    cSql += "          A1_BAIRRO, "
    cSql += "          A1_TIPO,   "
    cSql += "          A1_EST,    "
    cSql += "          A1_MUN     "
    cSql += "     FROM " + RetSqlName("SA1") + " SA1 "
    cSql += "    WHERE SA1.A1_FILIAL  = '" + xFilial("SA1") + "' "
    cSql += "      AND SA1.A1_VEND    = '" + cCodVen + "' "
    cSql += "      AND SA1.D_E_L_E_T_ = ' ' "


    If !Empty(::search)
        cSql += cFilter
    EndIf

    If Empty(::sortField) .Or. ::sortField == 'created'
        cSql += " ORDER BY SA1.A1_COD "
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
/*/{Protheus.doc} cliente
Método get para retornar os dados do cliente
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD GET RetornaCliente PATHPARAM id WSSERVICE cliente

    Local lRet    := .T.
    Local cJson   := ""
    Local cSql    := ""

    ::SetContentType("application/json")
    
    //--------------------------------------
    // Seleciona registros.
    //--------------------------------------
    cSql := "   SELECT A1_FILIAL, "
    cSql += "          A1_COD,    "
    cSql += "          A1_LOJA,   "
    cSql += "          A1_NOME,   "
    cSql += "          A1_NREDUZ, "
    cSql += "          A1_PESSOA, "
    cSql += "          A1_END,    "    
    cSql += "          A1_BAIRRO, "
    cSql += "          A1_TIPO,   "
    cSql += "          A1_EST,    "
    cSql += "          A1_MUN     "
    cSql += "     FROM " + RetSqlName("SA1") + " SA1 "
    cSql += "    WHERE SA1.A1_FILIAL  = '" + xFilial("SA1") + "' "
    cSql += "      AND SA1.D_E_L_E_T_ = ' ' "
    cSql += "      AND SA1.A1_COD + SA1.A1_LOJA = '" + ::id + "' "

    cJson := U_GetJson(cSql)

    If !Empty(cJson)

        ::setResponse(EncodeUTF8('{"data":' + cJson + '}'))

    Else

        setRestFault(400, EncodeUTF8("Nenhum registro encontrado!"))
        lRet := .F.

    EndIf

RETURN lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} cliente
Método post utilizado para incluir cliente.
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD POST WSSERVICE cliente

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

        aAdd(aRegistro, {"A1_FILIAL", xFilial("SA1"), Nil})
        aAdd(aRegistro, {"A1_COD",    oObj:A1_COD,    Nil})
        aAdd(aRegistro, {"A1_LOJA",   oObj:A1_LOJA,   Nil})
        aAdd(aRegistro, {"A1_NOME",   oObj:A1_NOME,   Nil})
        aAdd(aRegistro, {"A1_NREDUZ", oObj:A1_NREDUZ, Nil})
        aAdd(aRegistro, {"A1_PESSOA", oObj:A1_PESSOA, Nil})
        aAdd(aRegistro, {"A1_END",    oObj:A1_END,    Nil})
        aAdd(aRegistro, {"A1_BAIRRO", oObj:A1_BAIRRO, Nil})
        aAdd(aRegistro, {"A1_TIPO",   oObj:A1_TIPO,   Nil})
        aAdd(aRegistro, {"A1_EST",    oObj:A1_EST,    Nil})
        aAdd(aRegistro, {"A1_MUN",    oObj:A1_MUN,    Nil})

        MsExecAuto({|x,y| Mata030(x,y)}, aRegistro, 3)

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
/*/{Protheus.doc} cliente
Método put utilizado para alterar cliente.
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD PUT WSSERVICE cliente

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

        aAdd(aRegistro, {"A1_FILIAL", xFilial("SA1"), Nil})
        aAdd(aRegistro, {"A1_COD",    oObj:A1_COD,    Nil})
        aAdd(aRegistro, {"A1_LOJA",   oObj:A1_LOJA,   Nil})
        aAdd(aRegistro, {"A1_NOME",   oObj:A1_NOME,   Nil})
        aAdd(aRegistro, {"A1_NREDUZ", oObj:A1_NREDUZ, Nil})
        aAdd(aRegistro, {"A1_PESSOA", oObj:A1_PESSOA, Nil})
        aAdd(aRegistro, {"A1_END",    oObj:A1_END,    Nil})
        aAdd(aRegistro, {"A1_BAIRRO", oObj:A1_BAIRRO, Nil})
        aAdd(aRegistro, {"A1_TIPO",   oObj:A1_TIPO,   Nil})
        aAdd(aRegistro, {"A1_EST",    oObj:A1_EST,    Nil})
        aAdd(aRegistro, {"A1_MUN",    oObj:A1_MUN,    Nil})

        MsExecAuto({|x,y| Mata030(x,y)}, aRegistro, 4)

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
/*/{Protheus.doc} cliente
Método delete utilizado para excluir cliente.
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD DELETE WSSERVICE cliente

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

        aAdd(aRegistro, {"A1_FILIAL", xFilial("SA1"), Nil})
        aAdd(aRegistro, {"A1_COD",    oObj:A1_COD,    Nil})
        aAdd(aRegistro, {"A1_LOJA",   oObj:A1_LOJA,   Nil})

        MsExecAuto({|x,y| Mata030(x,y)}, aRegistro, 5)

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
