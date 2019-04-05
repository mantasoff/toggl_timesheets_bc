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
        field(10; "Toggl Api Time Entries Link"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Toggl Api Time Entries Link';
        }
        field(15; "Toggl Api Projects Link"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Toggl Api Projects Link';
        }
        field(20; "Toggl Api Clients Link"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Toggl Api Clients Link';
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