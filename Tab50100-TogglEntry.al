table 50100 "1CF Toggl Entry"
{
    DataClassification = ToBeClassified;
    Caption = '1CF Toggl Entries';

    fields
    {
        field(1; "User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Person';
        }
        field(5; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'uid';
        }
        field(12; "ClientID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Client';
        }
        field(13; "ProjectID"; Code[20])
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
            Caption = 'Start Date';
        }
        field(17; "End Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Caption = 'End Date';
        }
        field(18; "Project Name"; text[100])
        {

            Caption = 'Project Name';
            FieldClass = FlowField;
            CalcFormula = lookup ("1CF Toggl Project".ProjectName where (ProjectID = field (ProjectID), UserID = field ("User ID")));
        }
        field(19; "Client Name"; text[100])
        {

            Caption = 'Client Name';
            FieldClass = FlowField;
            CalcFormula = lookup ("1CF Toggl Client".ClientName where (clientid = field (clientid), UserID = field ("User ID")));
        }
    }

    keys
    {
        key(PK; "User ID", "Entry No.")
        {
            Clustered = true;
        }
    }
}
