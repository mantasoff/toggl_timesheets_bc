page 50100 "1CF Toggl Entries"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "1CF Toggl Entry";
    Caption = '1CF Toggl Entries';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                }
                field(Person; "User ID")
                {
                    ApplicationArea = All;
                }
                field(Client; Client)
                {
                    ApplicationArea = All;
                }
                field(Project; Project)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Tag; Tag)
                {
                    ApplicationArea = All;
                }
                field("Start Date"; "Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; "End Date")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }
    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    TogglManagement: Codeunit "1CF Toggle Management";
                begin
                    TogglManagement.FillTogglEntries();
                end;
            }
        }
    }
}
