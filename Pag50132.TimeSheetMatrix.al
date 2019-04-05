page 50132 "1CF Time Sheet Matrix"
{
    Caption = 'Time Sheet Matrix';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPlus;
    SourceTable = Job;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {

        area(Content)
        {
            field(PeriodType; PeriodType)
            {
                ApplicationArea = All;
                Caption = 'View by';
                OptionCaption = 'Day,Week,Month,Quarter,Year,Accounting Period';
                ToolTip = 'Specifies by which period amounts are displayed.';

                trigger OnValidate()
                begin
                    SetColumns(SetWanted::First);
                    UpdateMatrixSubform();
                end;
            }
            part(MatrixForm; "1CF Time Sheet Matrix Subform")
            {
                ApplicationArea = All;
                ShowFilter = false;
            }

        }
    }
    actions
    {
        area(processing)
        {
            action(PreviousSet)
            {
                ApplicationArea = All;
                Caption = 'Previous Set';
                Image = PreviousSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Go to the previous set of data.';

                trigger OnAction()
                begin
                    MATRIX_GenerateColumnCaptions(SetWanted::Previous);
                    UpdateMatrixSubform();
                end;
            }
            action(PreviousColumn)
            {
                ApplicationArea = All;
                Caption = 'Previous Column';
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Go to the previous column.';

                trigger OnAction()
                begin
                    MATRIX_GenerateColumnCaptions(SetWanted::PreviousColumn);
                    UpdateMatrixSubform();
                end;
            }
            action(NextColumn)
            {
                ApplicationArea = All;
                Caption = 'Next Column';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Go to the next column.';

                trigger OnAction()
                begin
                    MATRIX_GenerateColumnCaptions(SetWanted::NextColumn);
                    UpdateMatrixSubform();
                end;
            }
            action(NextSet)
            {
                ApplicationArea = All;
                Caption = 'Next Set';
                Image = NextSet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Go to the next set of data.';

                trigger OnAction()
                begin
                    MATRIX_GenerateColumnCaptions(SetWanted::Next);
                    UpdateMatrixSubform();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetColumns(SetWanted::First);
        MATRIX_GenerateColumnCaptions(SetWanted::First);
        UpdateMatrixSubform();
    end;

    var
        MatrixRecords: array[32] of Record Date;
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        SetWanted: Option First,Previous,Same,Next,PreviousColumn,NextColumn;
        MatrixColumnCaptions: array[32] of Text;
        ColumnSet: Text;
        PKFirstRecInCurrSet: Text;
        CurrSetLength: Integer;

    [Scope('Personalization')]
    procedure SetColumns(SetWanted: Option First,Previous,Same,Next,PreviousColumn,NextColumn)
    var
        MatrixMgt: Codeunit "Matrix Management";
    begin
        MatrixMgt.GeneratePeriodMatrixData(SetWanted, 12, false, PeriodType, '',
          PKFirstRecInCurrSet, MatrixColumnCaptions, ColumnSet, CurrSetLength, MatrixRecords);
    end;

    local procedure UpdateMatrixSubform()
    begin
        CurrPage.MatrixForm.PAGE.Load(MatrixColumnCaptions, MatrixRecords, CurrSetLength);
    end;

    local procedure MATRIX_GenerateColumnCaptions(MATRIX_SetWanted: Option First,Previous,Same,Next,PreviousColumn,NextColumn)
    var
        MatrixMgt: Codeunit "Matrix Management";
    begin
        Clear(MatrixColumnCaptions);
        CurrSetLength := 12;

        MatrixMgt.GeneratePeriodMatrixData(
          MATRIX_SetWanted, CurrSetLength, false, PeriodType, '',
          PKFirstRecInCurrSet, MatrixColumnCaptions, ColumnSet, CurrSetLength, MatrixRecords);
    end;
}