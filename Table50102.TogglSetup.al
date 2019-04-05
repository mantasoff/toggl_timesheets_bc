table 50102 "1CF Toggl Setup"
{
    DataClassification = ToBeClassified;
    Caption = 'Toggl Setup';
    fields
    {
        field(1; PrimaryKey; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Toggl Setup';
        }
        field(10; "Toggl Api Link"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Toggl Api Link';
        }
    }

    keys
    {
        key(PK; PrimaryKey)
        {
            Clustered = true;
        }
    }

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}