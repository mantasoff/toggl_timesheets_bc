page 50101 "Toggl Setup"
{
    PageType = Card;
    SourceTable = "1CF Toggl Setup";
    Caption = 'Toggl Setup';
    InsertAllowed = false;
    DeleteAllowed = false;
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Toggl Api Link"; "Toggl Api Link")
                {
                    ApplicationArea = All;

                }
                field("Days to keep Toggl Entry"; "Days to keep Toggl Entry")
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Reset();
        if not Get() then begin
            Init();
            Insert();
        end;
    end;
}