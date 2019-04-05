page 50100 "1CF Toggl Entries"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "1CF Toggl Entries";
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
                    TogglManagement.FillTogglEntries('[{"id":1153159613,"guid":"ce2f3316857eb59de2adb88c33f2e79a","wid":3350285,"billable":false,"start":"2019-04-05T06:52:10+00:00","stop":"2019-04-05T06:52:12+00:00","duration":2,"duronly":false,"at":"2019-04-05T06:52:12+00:00","uid":4756729},{"id":1153160383,"guid":"a1d256531b70249ef14bb1499e65d2ce","wid":3350285,"pid":150778040,"billable":false,"start":"2019-04-05T06:53:05+00:00","stop":"2019-04-05T07:31:15+00:00","duration":2290,"description":"Installing docker","duronly":false,"at":"2019-04-05T07:31:16+00:00","uid":4756729},{"id":1153197853,"guid":"6582c40994b5851aba32c9c03ead8812","wid":3350285,"pid":150778040,"billable":false,"start":"2019-04-05T07:31:18+00:00","stop":"2019-04-05T08:55:41+00:00","duration":5063,"description":"planning","duronly":false,"at":"2019-04-05T08:55:42+00:00","uid":4756729},{"id":1153217712,"guid":"727268e4562f4d45ae202b5161295011","wid":3350285,"pid":150778040,"billable":false,"start":"2019-04-05T07:50:38+00:00","stop":"2019-04-05T08:05:56+00:00","duration":918,"description":"first task","duronly":false,"at":"2019-04-05T08:06:13+00:00","uid":4756729},{"id":1153235458,"guid":"80f9732980c73c13e7ff99e3924eadef","wid":3350285,"pid":150778040,"billable":false,"start":"2019-04-05T08:06:20+00:00","stop":"2019-04-05T09:19:36+00:00","duration":4396,"description":"second task","tags":["DEVELOP","ffdsa"],"duronly":false,"at":"2019-04-05T11:31:00+00:00","uid":4756729}]');
                end;
            }
        }
    }
}
