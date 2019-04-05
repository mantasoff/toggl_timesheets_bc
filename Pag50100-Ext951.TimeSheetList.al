pageextension 50100 "1CF Time Sheet List" extends "Time Sheet List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addlast(Processing){
            action("1CF Import Toggl Entries")
            {
                ApplicationArea = All;
                Caption = 'Import Toggl Entries'; 
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = DateRange;

                trigger OnAction()
                var
                TogglToTimeSheet: Codeunit "1CF Toggle to Time Sheet";
                begin
                    TogglToTimeSheet.Run();
                end;
            }
            action("1CF Toggl Entries")
            {
                ApplicationArea = All;
                Caption = '1CF Toggl Entries';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = Entries;

                trigger OnAction()
                var
                    TogglEntries: Page "1CF Toggl Entries";
                begin
                    TogglEntries.Run();
                end;
            }
        }
    }

    var
        myInt: Integer;
}