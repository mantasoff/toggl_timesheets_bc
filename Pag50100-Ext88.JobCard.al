pageextension 50100 "1CF Job Card" extends "Job Card"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addfirst("&Job")
        {
            action("1CF Toggl")
            {
                ApplicationArea = All;
                Promoted = True;
                PromotedIsBig = True;
                PromotedCategory = Process;
                Image = Apply;

                trigger OnAction()
                var
                    TogglManagement: Codeunit "1CF Toggle Management";
                begin
                    TogglManagement.CreateTogglClient(Rec);
                end;
            }
        }
    }
}