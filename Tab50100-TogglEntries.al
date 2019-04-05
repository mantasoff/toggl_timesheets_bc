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
            AutoIncrement = true;
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
        field(16; "Start Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Caption ='Start Date';
        }
        field(17; "End Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Caption = 'End Date';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}