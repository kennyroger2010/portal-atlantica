import { Component, OnInit } from '@angular/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { ActivatedRoute, Params, Router } from '@angular/router';
import { DisplayedColumn, DisplayedFields, Page } from '../models/display';
import { ProdutoItem } from '../models/produto';
import { CrudService } from '../services/crud.service';

@Component({
  selector: 'app-produto-form',
  templateUrl: './produto-form.component.html',
  styleUrls: ['./produto-form.component.css']
})
export class ProdutoFormComponent implements OnInit {

  page: Page = {
    title: 'Produto',
    subTitle: ['B1_COD', 'B1_DESC'],
    navGrid: '/produto',
    navForm: 'produtoform',
    id: '',
    endpoint: 'produto',
    action: '0',
    btnInsert: true,
    btnView: true,
    btnEdit: true,
    btnDelete: true
  }

  displayedFields: DisplayedFields[] = [];

  produto: ProdutoItem = {
    B1_COD: '',
    B1_DESC: '',
    B1_TIPO: '',
    B1_UM: '',
    B1_LOCPAD: '',
    B1_GRUPO: '',
    B1_PRV1: 0
  }

  grupos: any[] = [];
  tipos: any[] = [];
  medidas: any[] = [];
  locais: any[] = [];

  constructor(private crudService: CrudService, private snackBar: MatSnackBar, private router: Router, private activateRouter: ActivatedRoute) { }

  ngOnInit(): void {

    this.page.endpoint = 'produto';

    this.activateRouter.params
      .subscribe(
        (params: Params) => {

          this.page.action = params.action;
          this.page.id = params.id;

          this.displayedFields = [
            {
              row: [
                { label: 'Código', name: 'B1_COD', disabled: params.action != '3', type: 'input', varType: 'text', dataset: '', query: '' },
                { label: 'Preço de Venda', name: 'B1_PRV1', disabled: params.action >= '5', type: 'input', varType: 'number', dataset: '', query: '' },
              ]
            },
            {
              row: [
                { label: 'Descrição', name: 'B1_DESC', disabled: params.action >= '5', type: 'input', varType: 'text', dataset: '', query: '' },
              ]
            },
            {
              row: [
                { label: 'Tipo', name: 'B1_TIPO', disabled: params.action >= '5', type: 'select', varType: '', dataset: this.tipos, query: 'tipos' },
                { label: 'Unid.Med.', name: 'B1_UM', disabled: params.action >= '5', type: 'select', varType: '', dataset: this.medidas, query: 'medidas' },
                { label: 'Local', name: 'B1_LOCPAD', disabled: params.action >= '5', type: 'select', varType: '', dataset: this.locais, query: 'locais' },
                { label: 'Grupo', name: 'B1_GRUPO', disabled: params.action >= '5', type: 'select', varType: '', dataset: this.grupos, query: 'grupos' },
              ]
            },
          ]
        }
      )
  }
}
