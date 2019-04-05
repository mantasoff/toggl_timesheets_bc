page 50101 TogglProjectEntries
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "1CF Toggl Project";

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
                field(ProjectID; ProjectID)
                {
                    ApplicationArea = All;
                }
                field(ClientName; ClientName)
                {
                    ApplicationArea = All;
                }
                field(ProjectName; ProjectName)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}