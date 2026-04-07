import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { RouterModule } from '@angular/router';
import { ReactiveFormsModule, FormsModule } from '@angular/forms';
import { MatTableModule }     from '@angular/material/table';
import { MatPaginatorModule } from '@angular/material/paginator';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule }     from '@angular/material/input';
import { MatButtonModule }    from '@angular/material/button';
import { MatIconModule }      from '@angular/material/icon';
import { MatSelectModule }    from '@angular/material/select';
import { MatCardModule }      from '@angular/material/card';
import { MatSnackBarModule }  from '@angular/material/snack-bar';
import { MatTooltipModule }   from '@angular/material/tooltip';
import { MatChipsModule }     from '@angular/material/chips';
import { MatDatepickerModule } from '@angular/material/datepicker';
import { MatNativeDateModule }  from '@angular/material/core';
import { MatSortModule }       from '@angular/material/sort';
import { MatDialogModule }     from '@angular/material/dialog';
import { MatProgressBarModule } from '@angular/material/progress-bar';
import { MatButtonToggleModule } from '@angular/material/button-toggle';
import { MatAutocompleteModule } from '@angular/material/autocomplete';
import { DragDropModule } from '@angular/cdk/drag-drop';
import { LeadListComponent } from './lead-list/lead-list.component';
import { LeadFormComponent } from './lead-form/lead-form.component';
import { LeadsKanbanComponent } from './leads-kanban/leads-kanban.component';

@NgModule({
  declarations: [LeadListComponent, LeadFormComponent, LeadsKanbanComponent],
  imports: [
    CommonModule, ReactiveFormsModule, FormsModule,
    RouterModule.forChild([
      { path: '', component: LeadListComponent },
      { path: 'new', component: LeadFormComponent },
      { path: ':id/edit', component: LeadFormComponent },
    ]),
    MatTableModule, MatPaginatorModule, MatSortModule, MatFormFieldModule, MatInputModule,
    MatButtonModule, MatIconModule, MatSelectModule, MatCardModule,
    MatSnackBarModule, MatTooltipModule, MatChipsModule, MatDialogModule, MatProgressBarModule,
    MatDatepickerModule, MatNativeDateModule, MatButtonToggleModule, MatAutocompleteModule,
    DragDropModule
  ]
})
export class LeadsModule {}
