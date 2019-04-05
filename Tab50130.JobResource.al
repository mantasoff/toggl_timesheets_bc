table 50103 "Job Resource"
{
    DataClassification = ToBeClassified;
    Caption = 'Job Resource';

    fields
    {
        field(1; "Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Job No.';
        }
        field(2; Date; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date';
        }
        field(3; "Resource ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Resource ID';
        }
    }

    keys
    {
        key(PK; "Job No.", Date, "Resource ID")
        {
            Clustered = true;
        }
    }
}