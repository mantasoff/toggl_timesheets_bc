page 50102 TogglSetup
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "1CF Toggl Setup";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Toggl Api Time Entries Link"; "Toggl Api Time Entries Link")
                {
                    ApplicationArea = All;

                }
                field("Toggl Api Projects Link"; "Toggl Api Projects Link")
                {
                    ApplicationArea = All;

                }
                field("Toggl Api Clients Link"; "Toggl Api Clients Link")
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if not get then begin
            init;
            insert;
        end;
    end;
}