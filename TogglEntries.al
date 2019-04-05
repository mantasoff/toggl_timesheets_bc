table 50100 "1CF Toggl Entries"
{
    DataClassification = ToBeClassified;
    Caption = '1CF Toggl Entries';
    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Entry No.';
        }
        field(11; "Person"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Person';
        }
        field(12; "Client"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Client';
        }
        field(13; "Project"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Project';
        }
        field(14; "Tag"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Tag';
        }
        field(15; "Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    var

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