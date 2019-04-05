pageextension 50109 "1CF User Setup" extends "User setup"
{
    layout
    {
        addlast(Control1)
        {

            field("1CF Toggl Api Key"; "1CF Toggl Api Key")
            {
                ApplicationArea = All;
            }
            field("1CF Workspace ID"; "1CF Workspace ID")
            {
                // TODO: remove; should come from validate in table
                ApplicationArea = All;
            }
        }
    }

}