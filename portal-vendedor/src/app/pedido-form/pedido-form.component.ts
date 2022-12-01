import { Component, OnInit, ViewChild } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ActivatedRoute, Params } from '@angular/router';
import { DisplayedColumn, DisplayedFields, Page } from '../models/display';
import { PedidoItem, Produto } from '../models/pedido';
import { FormComponent } from '../template/form/form.component';
import { GridEditComponent } from '../template/grid-edit/grid-edit.component';
import { GridModalComponent } from '../template/grid-modal/grid-modal.component';

@Component({
  selector: 'app-pedido-form',
  templateUrl: './pedido-form.component.html',
  styleUrls: ['./pedido-form.component.css']
})
export class PedidoFormComponent implements OnInit {

  @ViewChild("form") form!: FormComponent;
  @ViewChild("grid") grid!: GridEditComponent;

  page: Page = {
    title: 'Pedido de Venda',
    subTitle: ['C5_NUM', 'A1_NOME'],
    navGrid: '/pedido',
    navForm: 'pedidoform',
    id: '',
    endpoint: 'pedido',
    action: '0',
    btnInsert: true,
    btnView: false,
    btnEdit: true,
    btnDelete: true,
    method: 'post'
  }

  displayedFields: DisplayedFields[] = [];

  pageForm: Page = {
    title: 'Produto',
    subTitle: ['C6_PRODUTO', 'C6_DESCRI'],
    btnInsert: true,
    btnView: false,
    btnEdit: true,
    btnDelete: true,
    method: '',
    model: 'ClassProduto'
  }

  displayedFieldsForm: DisplayedFields[] = [];

  pedido: PedidoItem = {
    C5_NUM: '',
    C5_EMISSAO: '',
    C5_CONDPAG: '',
    E4_DESCRI: '',
    C5_CLIENTE: '',
    C5_LOJACLI: '',
    A1_NOME: '',
    A1_NREDUZ: '',
    A1_MUN: '',
    A1_EST: '',
    produtos: []
  }

  produto: Produto = {
    C6_ITEM: '',
    C6_PRODUTO: '',
    C6_DESCRI: '',
    C6_UM: '',
    C6_QTDVEN: 0,
    C6_PRCVEN: 0,
    C6_VALOR: 0,
    C6_TES: '',
    C6_CF: ''
  }

  displayedColumns: DisplayedColumn[] = [
    { field: 'C6_ITEM', display: 'Item' },
    { field: 'C6_PRODUTO', display: 'Produto' },
    { field: 'C6_DESCRI', display: 'Desc.Produto' },
    { field: 'C6_UM', display: 'Unid.Med.' },
    { field: 'C6_QTDVEN', display: 'Quantidade' },
    { field: 'C6_PRCVEN', display: 'Preço de Venda' },
    { field: 'C6_VALOR', display: 'Total da Venda' },
    { field: 'C6_TES', display: 'TES' },
    { field: 'C6_CF', display: 'CFOP' }
  ];

  clientes: any[] = [];
  condicoes: any[] = [];
  produtos: any[] = [];
  tes: any[] = [];

  constructor(private activateRouter: ActivatedRoute, public dialog: MatDialog) { }

  ngOnInit(): void {

    this.page.endpoint = 'pedido';

    this.activateRouter.params
      .subscribe(
        (params: Params) => {

          this.page.action = params.action;
          this.page.id = params.id;
          this.page.queryDetail = 'produtos';

          this.displayedFields = [
            {
              row: [
                {
                  label: 'Número',
                  name: 'C5_NUM',
                  disabled: true,
                  type: 'input',
                  varType: 'text',
                  dataset: '',
                  query: ''
                },
                {
                  label: 'Emissão',
                  name: 'C5_EMISSAO',
                  disabled: params.action >= '5',
                  type: 'input',
                  varType: 'text',
                  dataset: '',
                  query: ''
                },
                {
                  label: 'Cond.Pagto',
                  name: 'C5_CONDPAG',
                  disabled: params.action >= '5',
                  type: 'select',
                  varType: '',
                  dataset: this.condicoes,
                  query: 'condicoes'
                },
              ]
            },
            {
              row: [
                {
                  label: 'Cliente',
                  name: 'C5_CLIENTE',
                  disabled: true,
                  type: 'input',
                  varType: '',
                  dataset: '',
                  query: '',
                  search: true,
                  click: 'cliente'
                },
                {
                  label: 'Loja',
                  name: 'C5_LOJACLI',
                  disabled: true,
                  type: 'input',
                  varType: 'text',
                  dataset: '',
                  query: ''
                },
                {
                  label: 'Nome',
                  name: 'A1_NOME',
                  disabled: true,
                  type: 'input',
                  varType: 'text',
                  dataset: '',
                  query: ''
                },
                {
                  label: 'Nome Reduzido',
                  name: 'A1_NREDUZ',
                  disabled: true,
                  type: 'input',
                  varType: 'text',
                  dataset: '',
                  query: ''
                },
              ]
            },
          ]

          this.displayedFieldsForm = [
            {
              row: [
                {
                  label: 'Item',
                  name: 'C6_ITEM',
                  disabled: true,
                  type: 'input',
                  varType: 'text',
                  dataset: '',
                  query: '',
                  increment: true,
                  init: '01'
                },
                {
                  label: 'Quantidade',
                  name: 'C6_QTDVEN',
                  disabled: "this.page.action >= '5'",
                  type: 'input',
                  varType: 'number',
                  dataset: '',
                  query: '',
                  trigger: 'element.C6_VALOR = element.C6_QTDVEN * element.C6_PRCVEN'
                },
                {
                  label: 'Preço',
                  name: 'C6_PRCVEN',
                  disabled: "this.page.action >= '5'",
                  type: 'input',
                  varType: 'number',
                  dataset: '',
                  query: '',
                  trigger: 'element.C6_VALOR = element.C6_QTDVEN * element.C6_PRCVEN'
                },
                {
                  label: 'Valor Total',
                  name: 'C6_VALOR',
                  disabled: true,
                  type: 'input',
                  varType: 'number',
                  dataset: '',
                  query: ''
                },
              ]
            },
            {
              row: [
                {
                  label: 'Tes',
                  name: 'C6_TES',
                  disabled: "this.page.action >= '5'",
                  type: 'select',
                  varType: '',
                  dataset: this.tes,
                  query: 'tes'
                },
                {
                  label: 'Produto',
                  name: 'C6_PRODUTO',
                  disabled: "this.page.action >= '5'",
                  type: 'select',
                  varType: '',
                  dataset: this.produtos,
                  query: 'produtos',
                  trigger: 'element.C6_DESCRI = (obj ? obj.viewValue : ""); element.C6_UM = (obj ? obj.B1_UM : "")'
                },
              ]
            },
          ]
        }
      )
  }

  onReloadGrid() {

    if (this.grid) {
      this.grid.isLoadingResults = false;
      this.grid.isRateLimitReached = false;
      this.grid.dataSource = this.form.element.produtos;
    }

  }

  click(event: any) {

    if (event.action == 'cliente') {

      let dialogRef = this.dialog.open(GridModalComponent, {
        height: '80%',
        width: '70%',
        data: {}
      });
  
      let page: Page = {
        title: 'Cadastro de Clientes',
        navForm: 'clienteform',
        id: 'row.A1_COD + row.A1_LOJA',
        endpoint: 'cliente',
        btnInsert: false,
        btnView: false,
        btnEdit: false,
        btnDelete: false,
        btnSelect: true
      }
  
      let displayedColumns: DisplayedColumn[] = [
        { field: 'A1_COD', display: 'Código' },
        { field: 'A1_NOME', display: 'Nome' },
        { field: 'A1_NREDUZ', display: 'Nome Reduzido' },
        { field: 'A1_END', display: 'Endereço' },
        { field: 'A1_MUN', display: 'Município' },
        { field: 'A1_EST', display: 'Estados' }
      ];
  
      dialogRef.componentInstance.page = page;
      dialogRef.componentInstance.displayedColumns = displayedColumns;
  
      dialogRef.afterClosed().subscribe(e => {
        if (e) {
          this.form.element.C5_CLIENTE = e.A1_COD;
          this.form.element.C5_LOJACLI = e.A1_LOJA;
          this.form.element.A1_NOME = e.A1_NOME;
          this.form.element.A1_NREDUZ = e.A1_NREDUZ;
        }
      })
  
    }

  }

}