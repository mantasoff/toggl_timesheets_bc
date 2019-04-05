tableextension 50101 "1CF User Setup" extends "User Setup"
{
    fields
    {
        field(50100; "1CF Toggl Api Key"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Toggl Api Key';
            ExtendedDatatype = Masked;
            trigger OnValidate()
            var
                toggleManagement: Codeunit "1CF Toggle Management";
            begin
                "1CF Workspace ID" := toggleManagement.GetWorkspaceID("1CF Toggl Api Key");
            end;
        }
        field(50101; "1CF Workspace ID"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Workspace ID';
        }
    }
}
