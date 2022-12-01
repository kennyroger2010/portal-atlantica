#include "totvs.ch"
#include "topconn.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} GetJson
Método para retornar o json da consulta no banco.
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
User Function GetJson(cSql, pageNumber, rowsPage)

	Local qQuery  := ""
	Local aFields := {}
	Local nX      := 0
	Local cJson   := ""
	Local lRet    := .F.

	Default pageNumber := 0
	Default rowsPage   := 0

	SET(_SET_DATEFORMAT, 'dd/mm/yyyy')

	If pageNumber > 0 .And. rowsPage > 0
		cSql += " OFFSET ( " + cValToChar((pageNumber - 1) * rowsPage) + " ) ROWS "
		cSql += " FETCH NEXT " + cValToChar(rowsPage) + " ROWS ONLY "
	EndIf

	TCQUERY ChangeQuery(cSql) NEW ALIAS qQuery

	aFields := qQuery->(DbStruct())

	While qQuery->(!Eof())

		If lRet
			cJson += ','
		Else
			lRet := .T.
		EndIf

		cJson += "{"

		For nX := 1 To Len(aFields)

			If aFields[nX][1] == "VALUE"
				cJson += '"value":'
			ElseIf aFields[nX][1] == "VIEWVALUE"
				cJson += '"viewValue":'
			Else
				cJson += '"' + aFields[nX][1] + '":'
			EndIf

			If FieldPos(aFields[nX][1]) > 0 .And. Len(TamSX3(aFields[nX][1])) > 0

				If TamSX3(aFields[nX][1])[3] == "N"
					cJson += cValToChar(&("qQuery->" + aFields[nX][1]))
				ElseIf TamSX3(aFields[nX][1])[3] == "D"
					cJson += '"' + DtoC(StoD(&("qQuery->" + aFields[nX][1]))) + '"'
				Else
					cJson += '"' + AllTrim(&("qQuery->" + aFields[nX][1])) + '"'
				EndIf

			Else

				If aFields[nX][2] == "N"
					cJson += cValToChar(&("qQuery->" + aFields[nX][1]))
				Else
					cJson += '"' + AllTrim(&("qQuery->" + aFields[nX][1])) + '"'
				EndIf

			EndIf

			If nX != Len(aFields)
				cJson += ","
			EndIf

		Next

		cJson += "}"

		qQuery->(DbSkip())

	EndDo

	qQuery->(DbCloseArea())

Return cJson

//-------------------------------------------------------------------
/*/{Protheus.doc} GetJsonAux
Método para retornar o json da consulta auxilizar.
@return json
@author Kenny Roger
@since 23/03/2021
@version 1.0
/*/
//-------------------------------------------------------------------
User Function GetJsonAux(cTable, cKeyField, cDescField, nIndex, cIndexField, cIndexKey)

	Local cJson  := ""
	Local nTotal := 0

	&(cTable)->(DbSetOrder(nIndex))
	&(cTable)->(DbGoTop())
	&(cTable)->(DbSeek(cIndexKey))

	While &(cTable)->(!Eof()) .And. &(cTable + "->(" + cIndexField + ")") == cIndexKey

		cJson += If(nTotal == 0, "", ",") + '{"value":"' + AllTrim(&(cTable + "->" + cKeyField)) + '","viewValue":"' + AllTrim(&(cTable + "->" + cDescField)) + '"}'

		nTotal++

		&(cTable)->(DbSkip())

	EndDo

Return {cJson, nTotal}

