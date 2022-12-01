#include "totvs.ch"
#include "restful.ch"
#include "topconn.ch"
#include "fwmvcdef.ch"

WSRESTFUL pedido DESCRIPTION "Servico para acessar dados dos pedidos."

	WSDATA pageNumber AS INTEGER
	WSDATA rowsPage   AS INTEGER
	WSDATA sortField  AS STRING
	WSDATA sort       AS STRING
	WSDATA search     AS STRING
	WSDATA id         AS STRING

	WSMETHOD GET ListaPedidos  DESCRIPTION "Lista de Pedidos de Venda" WSSYNTAX "/pedido"      PATH "/pedido"
	WSMETHOD GET RetornaPedido DESCRIPTION "Retorna Pedido de Venda"   WSSYNTAX "/pedido/{id}" PATH "/pedido/{id}"
	WSMETHOD POST   DESCRIPTION "Inclui/Altera/Exclui Pedido de Venda" WSSYNTAX "/pedido"

END WSRESTFUL

//-------------------------------------------------------------------
/*/{Protheus.doc} pedido
Método get para retornar os dados do pedido
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD GET ListaPedidos WSRECEIVE pageNumber, rowsPage, sortField, sort, search WSSERVICE pedido

	Local lRet    := .T.
	Local cJson   := ""
	Local cSql    := ""
	Local nTotal  := 0
	Local aFilter := {"C5_NUM", "C5_CLIENTE", "A1_NOME", "A1_NREDUZ"}
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
	cSql := "    SELECT ISNULL(COUNT(*), 0) TOTAL "
	cSql += "      FROM " + RetSqlName("SC5") + " SC5 "
	cSql += " LEFT JOIN " + RetSqlName("SE4") + " SE4 "
	cSql += "        ON SE4.E4_FILIAL  = '" + xFilial("SE4") + "' "
	cSql += "       AND SE4.E4_CODIGO  = SC5.C5_CONDPAG "
	cSql += "       AND SE4.D_E_L_E_T_ = ' ' "
	cSql += " LEFT JOIN " + RetSqlName("SA1") + " SA1 "
	cSql += "        ON SA1.A1_FILIAL  = '" + xFilial("SA1") + "' "
	cSql += "       AND SA1.A1_COD     = SC5.C5_CLIENTE "
	cSql += "       AND SA1.A1_LOJA    = SC5.C5_LOJACLI "
	cSql += "       AND SA1.D_E_L_E_T_ = ' ' "
	cSql += "     WHERE SC5.C5_FILIAL  = '" + xFilial("SC5") + "' "
	cSql += "       AND SC5.C5_VEND1   = '" + cCodVen + "' "
	cSql += "       AND SC5.D_E_L_E_T_ = ' ' "

	If !Empty(::search)
		cSql += cFilter
	EndIf

	TCQUERY cSql NEW ALIAS qQuery

	nTotal := qQuery->TOTAL

	qQuery->(DbCloseArea())

	//--------------------------------------
	// Seleciona registros.
	//--------------------------------------
	cSql := "    SELECT C5_FILIAL,  "
	cSql += "           C5_NUM,     "
	cSql += "           C5_EMISSAO, "
	cSql += "           C5_CONDPAG, "
	cSql += "           E4_DESCRI,  "
	cSql += "           C5_CLIENTE, "
	cSql += "           C5_LOJACLI, "
	cSql += "           A1_NOME,    "
	cSql += "           A1_NREDUZ,  "
	cSql += "           A1_MUN,     "
	cSql += "           A1_EST      "
	cSql += "      FROM " + RetSqlName("SC5") + " SC5 "
	cSql += " LEFT JOIN " + RetSqlName("SE4") + " SE4 "
	cSql += "        ON SE4.E4_FILIAL  = '" + xFilial("SE4") + "' "
	cSql += "       AND SE4.E4_CODIGO  = SC5.C5_CONDPAG "
	cSql += "       AND SE4.D_E_L_E_T_ = ' ' "
	cSql += " LEFT JOIN " + RetSqlName("SA1") + " SA1 "
	cSql += "        ON SA1.A1_FILIAL  = '" + xFilial("SA1") + "' "
	cSql += "       AND SA1.A1_COD     = SC5.C5_CLIENTE "
	cSql += "       AND SA1.A1_LOJA    = SC5.C5_LOJACLI "
	cSql += "       AND SA1.D_E_L_E_T_ = ' ' "
	cSql += "     WHERE SC5.C5_FILIAL  = '" + xFilial("SC5") + "' "
	cSql += "       AND SC5.C5_VEND1   = '" + cCodVen + "' "
	csql += "       AND SC5.D_E_L_E_T_ = ' ' "

	If !Empty(::search)
		cSql += cFilter
	EndIf

	If Empty(::sortField) .Or. ::sortField == 'created'
		cSql += " ORDER BY SC5.C5_NUM DESC "
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
/*/{Protheus.doc} pedido
Método get para retornar os dados do pedido
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD GET RetornaPedido PATHPARAM id WSSERVICE pedido

	Local lRet    := .T.
	Local cJson   := ""
	Local cJsonIt := ""
	Local cSql    := ""

	::SetContentType("application/json")

	//--------------------------------------
	// Seleciona o cabeçalho do pedido.
	//--------------------------------------
	cSql := "    SELECT C5_FILIAL,  "
	cSql += "           C5_NUM,     "
	cSql += "           C5_EMISSAO, "
	cSql += "           C5_CONDPAG, "
	cSql += "           E4_DESCRI,  "
	cSql += "           C5_CLIENTE, "
	cSql += "           C5_LOJACLI, "
	cSql += "           A1_NOME,    "
	cSql += "           A1_NREDUZ,  "
	cSql += "           A1_MUN,     "
	cSql += "           A1_EST      "
	cSql += "      FROM " + RetSqlName("SC5") + " SC5 "
	cSql += " LEFT JOIN " + RetSqlName("SE4") + " SE4 "
	cSql += "        ON SE4.E4_FILIAL  = '" + xFilial("SE4") + "' "
	cSql += "       AND SE4.E4_CODIGO  = SC5.C5_CONDPAG "
	cSql += "       AND SE4.D_E_L_E_T_ = ' ' "
	cSql += " LEFT JOIN " + RetSqlName("SA1") + " SA1 "
	cSql += "        ON SA1.A1_FILIAL  = '" + xFilial("SA1") + "' "
	cSql += "       AND SA1.A1_COD     = SC5.C5_CLIENTE "
	cSql += "       AND SA1.A1_LOJA    = SC5.C5_LOJACLI "
	cSql += "       AND SA1.D_E_L_E_T_ = ' ' "
	cSql += "     WHERE SC5.C5_FILIAL  = '" + xFilial("SC5") + "' "
	csql += "       AND SC5.D_E_L_E_T_ = ' ' "
	cSql += "       AND SC5.C5_NUM     = '" + ::id + "' "

	cJson := U_GetJson(cSql)

	//--------------------------------------
	// Seleciona os itens do pedido.
	//--------------------------------------
	cSql := "    SELECT C6_ITEM,    "
	cSql += "           C6_PRODUTO, "
	cSql += "           C6_DESCRI,  "
	cSql += "           C6_UM,      "
	cSql += "           C6_QTDVEN,  "
	cSql += "           C6_PRCVEN,  "
	cSql += "           C6_VALOR,   "
	cSql += "           C6_TES,     "
	cSql += "           C6_CF       "
	cSql += "      FROM " + RetSqlName("SC6") + " SC6 "
	cSql += "     WHERE SC6.C6_FILIAL  = '" + xFilial("SC6") + "' "
	csql += "       AND SC6.D_E_L_E_T_ = ' ' "
	cSql += "       AND SC6.C6_NUM     = '" + ::id + "' "

	cJsonIt := U_GetJson(cSql)

	If !Empty(cJson) .And. !Empty(cJsonIt)

		::setResponse(EncodeUTF8('{"data":' + SubStr(cJson, 1, Len(cJson) - 1) + ', "produtos":[' + cJsonIt + ']}}'))

	Else

		setRestFault(400, EncodeUTF8("Nenhum registro encontrado!"))
		lRet := .F.

	EndIf

RETURN lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} pedido
Método post utilizado para incluir pedido.
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD POST WSSERVICE pedido

	Local lRet   := .T.
	Local oObj   := Nil
	Local aRet   := {}

	lRet := FwJsonDeserrialize(::getContent(), @oObj)

	If lRet

		aRet := SetPedido(oObj)

		If aRet[1]
			::setResponse(EncodeUTF8('{"mesage":"Registro gravado com sucesso","pedido":"' + aRet[2] + '"}'))
		Else
			setRestFault(400, EncodeUTF8(aRet[3]))
			lRet := .F.
		EndIf

	Else
		setRestFault(500, EncodeUTF8("Erro ao montar o objeto!"))
		lRet := .F.
	EndIf

RETURN lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} SetPedido
Função para incluir, alterar e excluir pedido de venda.
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function SetPedido(oPedido)

	Local aSC5      := {}
	Local aSC6      := {}
	Local aCabec    := {}
	Local aItens    := {}
	Local aLinha    := {}
	Local nX        := 0
	Local nY        := 0
	Local lOk       := .T.
	Local nOpcx     := 0
	Local cPedido   := ""
	Local aErro     := {}
	Local cErro     := ""

	Private lMsErroAuto	   := .F.
	Private lAutoErrNoFile := .T.

	Begin Transaction

		nOpcx  := oPedido:action
		aSC5   := ClassDataArr(oPedido:data)

		For nX := 1 To Len(aSC5)

			If !Empty(aSC5[nX][2])

				If AllTrim(aSC5[nX][1]) == "C5_EMISSAO"

					aAdd(aCabec, { aSC5[nX][1], CtoD(aSC5[nX][2]), Nil })

				ElseIf AllTrim(aSC5[nX][1]) <> "C5_NUM"

					aAdd(aCabec, { aSC5[nX][1], aSC5[nX][2], Nil })

				ElseIf nOpcx <> 3

					aAdd(aCabec, { aSC5[nX][1], aSC5[nX][2], Nil })

				EndIf

			EndIf

		Next

		For nX := 1 To Len(oPedido:data:produtos)

			aSC6 := ClassDataArr(oPedido:data:produtos[nX])

			aLinha := {}

			For nY := 1 To Len(aSC6)

				If !Empty(aSC6[nY][2])

					aAdd(aLinha, { aSC6[nY][1], aSC6[nY][2], Nil })

				EndIf

			Next

			aLinha := FWVetByDic(aLinha, "SC6")

			If nOpcx == 4
				aAdd(aLinha, {"AUTDELETA", "N", Nil})
			EndIf

			aAdd(aItens, aLinha)

		Next

		aCabec := FWVetByDic(aCabec, "SC5")

		//-------------------------------------------------------
		// Tratamento para itens excluídos do pedido de venda.
		//-------------------------------------------------------
		If nOpcx == 4

			SC6->(DbSetOrder(1))
			SC6->(DbGoTop())
			SC6->(DbSeek(xFilial("SC6") + oPedido:data:C5_NUM))

			While SC6->(!Eof()) .And. SC6->(C6_FILIAL + C6_NUM) == xFilial("SC6") + oPedido:data:C5_NUM
				
				If aScan(aItens, {|x| AllTrim(x[1][2]) == SC6->C6_ITEM}) == 0

					aLinha := {}

					aAdd(aLinha, {"C6_ITEM",   SC6->C6_ITEM, Nil})
					aAdd(aLinha, {"AUTDELETA", "S",          Nil})

					aLinha := FWVetByDic(aLinha, "SC6")

					aAdd(aItens, aLinha)

				EndIf

				SC6->(DbSkip())

			EndDo

		EndIf

		aSort(aItens,,,{|x,y| x[1][2] < y[1][2]})

		MsExecAuto({|x,y,z| Mata410(x,y,z)}, aCabec, aItens, nOpcx)

		If !lMsErroAuto

			cPedido := SC5->C5_NUM

			If nOpcx == 3
				ConOut("=> Pedido " + cPedido + " incluido com sucesso!")
			ElseIf nOpcx == 4
				ConOut("=> Pedido " + cPedido + " alterado com sucesso!")
			ElseIf nOpcx == 5
				ConOut("=> Pedido " + cPedido + " excluido com sucesso!")
			EndIf

		Else

			lOk := .F.

			If nOpcx == 3
				ConOut("=> Erro na inclusao com sucesso!")
			ElseIf nOpcx == 4
				ConOut("=> Erro na alteracao com sucesso!")
			ElseIf nOpcx == 5
				ConOut("=> Erro na exclusao com sucesso!")
			EndIf

			aErro := GetAutoGRLog()

			For nX := 1 To Len(aErro)
				cErro += aErro[nX] + Chr(10)
			Next

			ConOut(cErro)

			DisarmTransaction()

		EndIf

	End Transaction

RETURN {lOk, cPedido, cErro}
