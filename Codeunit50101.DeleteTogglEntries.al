codeunit 50101 "Delete Old Toggl Entries"
{
    trigger OnRun()
    begin
        DeleteOldTogglEntries();
    end;

    procedure DeleteOldTogglEntries()
    var
        TogglSetup: Record "1CF Toggl Setup";
        TogglEntries: Record "1CF Toggl Entries";
        PastDate: DateTime;
    begin
        TogglSetup.Get();
        PastDate := CreateDateTime(CalcDate(TogglSetup."Days to keep Toggl Entry", WorkDate()), 0T);
        TogglEntries.SetRange("End Date", 0DT, PastDate);
        TogglEntries.DeleteAll();
    end;
}
