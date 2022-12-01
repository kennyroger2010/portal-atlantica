import { AfterViewInit, Component, EventEmitter, Input, OnInit, Output, ViewChild } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { MatTable } from '@angular/material/table';
import { Router } from '@angular/router';
import { Subject } from 'rxjs';
import { ToolsService } from 'src/app/services/tools.service';
import { ReadParam } from '../../models/params';
import { FormModalComponent } from '../form-modal/form-modal.component';

@Component({
  selector: 'app-grid-edit',
  templateUrl: './grid-edit.component.html',
  styleUrls: ['./grid-edit.component.css']
})
export class GridEditComponent implements OnInit, AfterViewInit {

  @Input() page: any = {};
  @Input() pageForm: any = {};
  @Input() displayedColumns: any[] = [];
  @Input() element: any;
  @Input() displayedFields: any = [];

  @Output() endOfProcess = new EventEmitter;

  columnsToDisplay: string[] = [];

  search = '';
  resultsLength = 0;
  isLoadingResults = true;
  isRateLimitReached = false;
  dataSource: any[] = [];
  filterString: Subject<string> = new Subject<string>();
  readParams: ReadParam = { endpoint: '', pageIndex: 0, pageSize: 0 };

  @ViewChild(MatTable) table!: MatTable<any>;

  constructor(private router: Router, public dialog: MatDialog, private tools: ToolsService) { }

  ngOnInit(): void {

    this.columnsToDisplay = this.displayedColumns.map(function (elem) {
      return elem.field;
    });

    if (this.page.action < '5' && (this.page.btnView || this.page.btnEdit || this.page.btnDelete)) {
      this.columnsToDisplay.push('ACOES');
    }

  }

  ngAfterViewInit() {

    this.endOfProcess.emit();
    
  }

  create() {

    let dialogRef = this.dialog.open(FormModalComponent, {
      width: '70%',
      data: {}
    });

    let elem = Object.create(this.element);

    for (var i = 0; i < this.displayedFields.length; i++) {
      for (var x = 0; x < this.displayedFields[i].row.length; x++) {
        if (this.displayedFields[i].row[x].increment) {
          let next = this.tools.nextSequence(this.dataSource, this.displayedFields[i].row[x].name);
          elem[this.displayedFields[i].row[x].name] = (next ? next : this.displayedFields[i].row[x].init);
        }
      }
    }

    this.pageForm.action = '3';

    dialogRef.componentInstance.page = this.pageForm;
    dialogRef.componentInstance.element = elem;
    dialogRef.componentInstance.displayedFields = this.displayedFields;

    dialogRef.afterClosed().subscribe(e => {
      if (e) {
        this.dataSource.push(e);
        this.table.renderRows();
      }
    })

  }

  update(row: any, action: string) {

    let dialogRef = this.dialog.open(FormModalComponent, {
      width: '70%',
      data: {}
    });

    this.pageForm.action = action;
    dialogRef.componentInstance.page = this.pageForm;
    dialogRef.componentInstance.element = row;
    dialogRef.componentInstance.displayedFields = this.displayedFields;

    dialogRef.afterClosed().subscribe(e => {
      if (e) {
        this.dataSource.splice(this.dataSource.indexOf(e), 1);
        this.table.renderRows();
      }
    })

  }

}
