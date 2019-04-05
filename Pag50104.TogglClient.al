page 50104 "1CF Toggl Client"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "1CF Toggl Client";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(UserID; UserID)
                {
                    ApplicationArea = All;

                }
                field(ClientID; ClientID)
                {
                    ApplicationArea = All;

                }
                field(ClientName; ClientName)
                {
                    ApplicationArea = All;

                }
            }
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
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}