import { Component, Input, Output, EventEmitter } from '@angular/core';
import { CdkDragDrop, moveItemInArray, transferArrayItem } from '@angular/cdk/drag-drop';
import { Lead } from '../../../core/models/models';

@Component({
  selector: 'app-leads-kanban',
  template: `
    <div class="kanban-board" cdkDropListGroup>
      <div class="kanban-column" *ngFor="let col of columns">
        <h3 class="column-title">
          {{col.label}} 
          <span class="count">{{col.leads.length}}</span>
        </h3>
        
        <div cdkDropList 
             [cdkDropListData]="col.leads" 
             class="kanban-list" 
             (cdkDropListDropped)="drop($event, col.status)">
          
          <mat-card *ngFor="let lead of col.leads" 
                    cdkDrag 
                    class="kanban-card" 
                    (click)="onLeadClick(lead)">
            <mat-card-content style="padding:16px">
              <div class="card-header">
                <span class="lead-num">{{lead.leadNumber}}</span>
                <span class="lead-source">{{lead.source?.name}}</span>
              </div>
              
              <div class="customer-name">{{lead.customer?.firstName}} {{lead.customer?.lastName}}</div>
              
              <div class="model-info" *ngIf="lead.preferredModel">
                <mat-icon>directions_car</mat-icon> 
                <span>{{lead.preferredModel?.modelName}}</span>
              </div>
              
              <div class="card-footer">
                <div class="assigned-to">
                  <mat-icon>account_circle</mat-icon> 
                  {{lead.assignedTo?.firstName}}
                </div>
                <div class="date" *ngIf="lead.expectedCloseDate">
                  {{lead.expectedCloseDate | date:'MMM d'}}
                </div>
              </div>
            </mat-card-content>
          </mat-card>
          
          <div class="empty-placeholder" *ngIf="col.leads.length === 0">
            No leads in this stage
          </div>
        </div>
      </div>
    </div>
  `,
  styles: [`
    .kanban-board { 
      display: flex; 
      gap: 20px; 
      overflow-x: auto; 
      padding: 4px 4px 24px; 
      align-items: flex-start; 
      height: calc(100vh - 280px);
      scroll-behavior: smooth;
    }
    .kanban-column { 
      flex: 0 0 320px; 
      background: #f8fafc; 
      border-radius: 16px; 
      display: flex; 
      flex-direction: column; 
      max-height: 100%; 
      border: 1px solid #e2e8f0;
      box-shadow: 0 1px 3px rgba(0,0,0,0.05);
    }
    .column-title { 
      padding: 20px 20px 12px; 
      margin: 0; 
      font-size: 1.1rem; 
      font-weight: 700; 
      color: #0f172a; 
      display: flex; 
      justify-content: space-between; 
      align-items: center; 
    }
    .column-title .count { 
      font-size: 0.75rem; 
      background: #334155; 
      padding: 2px 10px; 
      border-radius: 20px; 
      color: #fff; 
    }
    .kanban-list { 
      min-height: 150px; 
      padding: 0 12px 16px; 
      flex-grow: 1; 
      overflow-y: auto; 
    }
    .kanban-card { 
      margin-bottom: 12px; 
      cursor: pointer; 
      border-radius: 12px; 
      border: 1px solid transparent; 
      transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
      box-shadow: 0 2px 4px rgba(0,0,0,0.04);
    }
    .kanban-card:hover { 
      border-color: var(--hd-blue); 
      transform: translateY(-2px) scale(1.01); 
      box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); 
    }
    .card-header { 
      display: flex; 
      justify-content: space-between; 
      margin-bottom: 10px; 
      font-size: 0.7rem; 
      font-weight: 700; 
      text-transform: uppercase;
      letter-spacing: 0.5px;
    }
    .lead-num { color: var(--hd-blue); }
    .lead-source { 
      color: #475569; 
      background: #f1f5f9; 
      padding: 2px 8px; 
      border-radius: 6px; 
    }
    .customer-name { 
      font-weight: 800; 
      font-size: 1.05rem; 
      margin-bottom: 10px; 
      color: #1e293b;
    }
    .model-info { 
      font-size: 0.85rem; 
      color: #64748b; 
      display: flex; 
      align-items: center; 
      gap: 6px; 
      margin-bottom: 16px; 
      background: #eff6ff;
      padding: 6px 10px;
      border-radius: 8px;
    }
    .model-info mat-icon { font-size: 18px; width: 18px; height: 18px; color: var(--hd-blue); }
    .card-footer { 
      display: flex; 
      justify-content: space-between; 
      font-size: 0.8rem; 
      color: #64748b; 
      border-top: 1px solid #f1f5f9; 
      padding-top: 12px; 
    }
    .assigned-to { display: flex; align-items: center; gap: 4px; font-weight: 500; }
    .assigned-to mat-icon { font-size: 16px; width: 16px; height: 16px; color: #94a3b8; }
    
    .empty-placeholder {
      text-align: center;
      padding: 40px 10px;
      color: #94a3b8;
      font-size: 0.85rem;
      font-style: italic;
      border: 2px dashed #e2e8f0;
      border-radius: 12px;
      margin-bottom: 16px;
    }

    /* CDK Drag & Drop styles */
    .cdk-drag-preview { 
      box-sizing: border-box; 
      border-radius: 12px; 
      box-shadow: 0 20px 25px -5px rgba(0,0,0,0.1), 0 10px 10px -5px rgba(0,0,0,0.04); 
    }
    .cdk-drag-placeholder { opacity: 0.15; }
    .cdk-drag-animating { transition: transform 250ms cubic-bezier(0, 0, 0.2, 1); }
    .kanban-list.cdk-drop-list-dragging .kanban-card:not(.cdk-drag-placeholder) { 
      transition: transform 250ms cubic-bezier(0, 0, 0.2, 1); 
    }
  `]
})
export class LeadsKanbanComponent {
  @Input() set leads(data: Lead[]) {
    this.allLeads = data;
    this.distributeLeads();
  }
  @Output() statusChange = new EventEmitter<{lead: Lead, newStatus: string}>();
  @Output() leadSelected = new EventEmitter<Lead>();

  allLeads: Lead[] = [];
  columns: { label: string, status: string, leads: Lead[] }[] = [
    { label: 'New', status: 'NEW', leads: [] },
    { label: 'Contacted', status: 'CONTACTED', leads: [] },
    { label: 'Test Drive', status: 'TEST_DRIVE', leads: [] },
    { label: 'Negotiation', status: 'NEGOTIATION', leads: [] },
    { label: 'Booked', status: 'BOOKED', leads: [] },
    { label: 'Lost', status: 'LOST', leads: [] }
  ];

  distributeLeads() {
    this.columns.forEach(col => {
      col.leads = this.allLeads.filter(l => l.status === col.status);
    });
  }

  drop(event: CdkDragDrop<Lead[]>, newStatus: string) {
    if (event.previousContainer === event.container) {
      moveItemInArray(event.container.data, event.previousIndex, event.currentIndex);
    } else {
      const lead = event.previousContainer.data[event.previousIndex];
      transferArrayItem(
        event.previousContainer.data,
        event.container.data,
        event.previousIndex,
        event.currentIndex
      );
      this.statusChange.emit({ lead, newStatus });
    }
  }

  onLeadClick(lead: Lead) {
    this.leadSelected.emit(lead);
  }
}
