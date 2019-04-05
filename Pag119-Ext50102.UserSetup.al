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
        }
    }

}