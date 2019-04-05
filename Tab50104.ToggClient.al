table 50104 "1CF Toggl Client"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; UserID; Code[50])
        {
            DataClassification = ToBeClassified;

        }
        field(5; ClientID; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(20; ClientName; text[100])
        {
            DataClassification = ToBeClassified;

        }
    }

    keys
    {
        key(PK; Userid, ClientID)
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