table 50105 "1CF Toggl Project"
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
        field(10; ProjectID; text[50])
        {
            DataClassification = ToBeClassified;

        }
        field(20; ClientName; text[100])
        {

            FieldClass = FlowField;
            CalcFormula = lookup ("1CF Toggl Client".ClientName where (clientid = field (clientid), userid = field (userid)));

        }
        field(25; ProjectName; text[100])
        {

        }
    }

    keys
    {
        key(PK; UserID, ClientID, ProjectID)
        {
            Clustered = true;
        }
    }
}