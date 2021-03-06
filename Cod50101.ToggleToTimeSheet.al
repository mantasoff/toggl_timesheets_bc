codeunit 50101 "1CF Toggle to Time Sheet"
{
    trigger OnRun()
    var
        CurrentSunday: Date;
        TogglClient: Record "1CF Toggl Client";
        TogglProject: Record "1CF Toggl Project";
        Resource: Record Resource;
        TogglEntries: Record "1CF Toggl Entry";
        TimeSheetLine: Record "Time Sheet Line";
        TimeSheetHeader: Record "Time Sheet Header";
        TimeSheetLineDetail: Record "Time Sheet Detail";
        StartDateTime: DateTime;
        EndDateTime: DateTime;
        CurrentWorkDate: Date;
        LineNo: Integer;
        SpentTime: Decimal;
        SpentDuration: Decimal;
    begin

        CurrentWorkDate := WorkDate();
        CurrentSunday := CalcDate('<CW - 1W>', CurrentWorkDate);
        //CurrentSunday := CalcDate('<CW>', CurrentWorkDate);

        TimeSheetHeader.SetRange("Ending Date", CurrentSunday);
        // TimeSheetHeader.SetRange("Resource No.", TogglEntries.Person);
        if TimeSheetHeader.FindSet() then
            repeat
                LineNo := 10000;
                StartDateTime := CreateDateTime(TimeSheetHeader."Starting Date", 0T);
                EndDateTime := CreateDateTime(TimeSheetHeader."Ending Date", 235959T);
                TogglEntries.SetRange("Start Date", StartDateTime, EndDateTime);
                //UPGBC
                //TogglEntries.SetRange(Person, TimeSheetHeader."Resource No.");
                Resource.Get(TimeSheetHeader."Resource No.");
                TogglEntries.SetRange("User ID", Resource."Time Sheet Owner User ID");
                //UPGBC
                if TogglEntries.FindSet() then
                    repeat
                        TimeSheetLine.Init();
                        TimeSheetLine.Validate("Time Sheet No.", TimeSheetHeader."No.");
                        TimeSheetLine."Line No." := LineNo;
                        TimeSheetLine.Validate(Type, TimeSheetLine.Type::Job);
                        //UPGBC
                        //TimeSheetLine.Validate("Job No.", TogglEntries.Client);
                        //TimeSheetLine.Validate("Job Task No.", TogglEntries.Project);
                        TogglEntries.CalcFields("Client Name", "Project Name");
                        TimeSheetLine.Validate("Job No.", TogglEntries."Client Name");
                        TimeSheetLine.Validate("Job Task No.", TogglEntries."Project Name");
                        //UPGBC                                                
                        TimeSheetLine.Validate(Description, TogglEntries.Description);
                        TimeSheetLine.Validate("Work Type Code", TogglEntries.Tag);
                        TimeSheetLineDetail.Init();
                        TimeSheetLineDetail.Validate("Time Sheet No.", TimeSheetLine."Time Sheet No.");
                        TimeSheetLineDetail.Validate("Time Sheet Line No.", TimeSheetLine."Line No.");
                        TimeSheetLineDetail.Validate(Date, DT2DATE(TogglEntries."Start Date"));
                        TimeSheetLineDetail.Validate(Type, TimeSheetLine.Type);
                        TimeSheetLineDetail.Validate("Job No.", TimeSheetLine."Job No.");
                        TimeSheetLineDetail.Validate("Job Task No.", TimeSheetLine."Job Task No.");
                        SpentDuration := TogglEntries."End Date" - TogglEntries."Start Date";
                        SpentTime := SpentDuration / 1000;
                        SpentTime := SpentTime / 60;
                        SpentTime := SpentTime / 60;
                        TimeSheetLineDetail.Validate(Quantity, SpentTime);
                        TimeSheetLineDetail.Insert;
                        TimeSheetLine.Insert(true);
                        LineNo := LineNo + 10000;

                    until TogglEntries.Next() = 0;
            until TimeSheetHeader.Next() = 0;
    end;
}