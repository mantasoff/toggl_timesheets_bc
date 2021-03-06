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
        field(30; "Days to keep Toggl Entry"; DateFormula)
        {
            DataClassification = ToBeClassified;
            Caption = 'Period after delete Toggl Entry';
            Description = 'DateFormula, e. g. -30D';

        }
        field(40; "Toggl Api Workspace Link"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Toggl Api Workspace Link';
        }
    }
    keys
    {
        key(PK; PrimaryKey)
        {
            Clustered = true;
        }
    }
}