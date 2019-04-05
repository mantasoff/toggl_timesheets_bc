tableextension 50100 UserSetupext extends "User Setup"
{
    fields
    {
        field(50100; "Toggl Api Key"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Toggl Api Key';
            ExtendedDatatype = Masked;
        }
    }

    var
        myInt: Integer;
}