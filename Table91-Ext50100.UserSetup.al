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
            begin
                // TODO
            end;
        }
        field(50101; "1CF Workspace ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Workspace ID';
        }
    }
}
