page 50130 "1CF Job Resource List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Job Resource";

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Job No."; "Job No.")
                {
                    ApplicationArea = All;
                }
                field(JobDescription; JobDescription)
                {
                    ApplicationArea = All;
                }
                field("Date"; Date)
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        Resource: Record Resource;
        Job: Record Job;
    begin
        Job.Get(Rec."Job No.");
        JobDescription := Job.Description;
        Resource.Get("Resource ID");
        Name := Resource.Name;
    end;

    var
        Name: Text;
        JobDescription: Text;
}