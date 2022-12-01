import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Params } from '@angular/router';
import { ClienteItem } from '../models/cliente';
import { DisplayedColumn, DisplayedFields, Page } from '../models/display';

@Component({
  selector: 'app-cliente-form',
  templateUrl: './cliente-form.component.html',
  styleUrls: ['./cliente-form.component.css']
})
export class ClienteFormComponent implements OnInit {

  page: Page = {
    title: 'Cliente',
    subTitle: ['A1_COD', 'A1_LOJA', 'A1_NOME'],
    navGrid: '/cliente',
    navForm: 'clienteform',
    id: '',
    endpoint: 'cliente',
    action: '0',
    btnInsert: true,
    btnView: true,
    btnEdit: true,
    btnDelete: true
  }

  displayedFields: DisplayedFields[] = [];

  cliente: ClienteItem = {
    A1_COD: '',
    A1_LOJA: '',
    A1_NOME: '',
    A1_NREDUZ: '',
    A1_END: '',
    A1_BAIRRO: '',
    A1_MUN: '',
    A1_EST: '',
    A1_PESSOA: '',
    A1_TIPO: ''
  }

  estados: any[] = [];

  pessoas: any[] = [
    { value: 'F', viewValue: 'Física' },
    { value: 'J', viewValue: 'Jurídica' }
  ];

  tipos: any[] = [
    { value: 'F', viewValue: 'Consumidor Final' },
    { value: 'L', viewValue: 'Produto Rural' },
    { value: 'R', viewValue: 'Revendedor' },
    { value: 'S', viewValue: 'Solidário' },
    { value: 'E', viewValue: 'Exportação' }
  ];

  grid: Page = {
    endpoint: 'receber'
  };

  displayedColumns: DisplayedColumn[] = [
    { field: 'E1_PREFIXO', display: 'Prefixo' },
    { field: 'E1_NUM', display: 'Número' },
    { field: 'E1_PARCELA', display: 'Parcela' },
    { field: 'E1_TIPO', display: 'Tipo' },
    { field: 'E1_NATUREZ', display: 'Natureza' },
    { field: 'ED_DESCRIC', display: 'Desc.Natureza' },
    { field: 'E1_EMISSAO', display: 'Emissão' },
    { field: 'E1_VENCREA', display: 'Vencimento' },
    { field: 'E1_VALOR', display: 'Valor' },
    { field: 'E1_SALDO', display: 'Saldo' },
  ];

  constructor(private activateRouter: ActivatedRoute) { }

  ngOnInit(): void {

    this.page.endpoint = 'cliente';

    this.activateRouter.params
      .subscribe(
        (params: Params) => {

          this.page.action = params.action;
          this.page.id = params.id;

          this.grid = {
            id: params.id,
            endpoint: 'receber'
          }

          this.displayedFields = [
            {
              row: [
                { label: 'Código', name: 'A1_COD', disabled: params.action != '3', type: 'input', varType: 'text', dataset: '', query: '' },
                { label: 'Loja', name: 'A1_LOJA', disabled: params.action != '3', type: 'input', varType: 'text', dataset: '', query: '' },
                { label: 'Pessoa', name: 'A1_PESSOA', disabled: params.action >= '5', type: 'select', varType: '', dataset: this.pessoas, query: '' },
                { label: 'Tipo', name: 'A1_TIPO', disabled: params.action >= '5', type: 'select', varType: '', dataset: this.tipos, query: '' },
              ]
            },
            {
              row: [
                { label: 'Nome', name: 'A1_NOME', disabled: params.action >= '5', type: 'input', varType: 'text', dataset: '', query: '' },
                { label: 'Nome Reduzido', name: 'A1_NREDUZ', disabled: params.action >= '5', type: 'input', varType: 'text', dataset: '', query: '' },
              ]
            },
            {
              row: [
                { label: 'Endereço', name: 'A1_END', disabled: params.action >= '5', type: 'input', varType: 'text', dataset: '', query: '' },
                { label: 'Bairro', name: 'A1_BAIRRO', disabled: params.action >= '5', type: 'input', varType: 'text', dataset: '', query: '' },
                { label: 'Município', name: 'A1_MUN', disabled: params.action >= '5', type: 'input', varType: 'text', dataset: '', query: '' },
                { label: 'Estado', name: 'A1_EST', disabled: params.action >= '5', type: 'select', varType: '', dataset: this.estados, query: 'estados' },
              ]
            }
          ]
        }
      )
  }
}