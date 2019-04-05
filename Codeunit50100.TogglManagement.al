codeunit 50100 "1CF Toggle Management"
{
    trigger OnRun()
    begin
    end;

    procedure GetInfoFromToggle(togglapi: text; togglID: text; togglPassword: text): Text
    var
        TempBlob: Record TempBlob temporary;
        Client: HttpClient;
        Headers: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        AuthText: text;
        ResponseText: text;
    begin
        RequestMessage.Method := Format('GET');
        RequestMessage.SetRequestUri(togglapi);

        RequestMessage.GetHeaders(Headers);
        AuthText := StrSubstNo('%1:%2', togglID, togglPassword);
        TempBlob.WriteAsText(AuthText, TextEncoding::Windows);
        Headers.Add('Authorization', StrSubstNo('Basic %1', TempBlob.ToBase64String()));

        Client.Send(RequestMessage, ResponseMessage);

        ResponseMessage.Content().ReadAs(responsetext);

        exit(responsetext);
    end;

    procedure FillTogglEntries()
    var
        togglentries: record "1CF Toggl Entry";
        togglesetup: Record "1CF Toggl Setup";
        togglprojects: Record "1CF Toggl Project";
        usersetup: Record "User Setup";
        jsonbuffer: Record "JSON Buffer" temporary;
        jsontextreader: Codeunit "Json Text Reader/Writer";
        row: Integer;
        JsonText: Text;
    begin
        RenewUserClients;

        togglesetup.Get();
        usersetup.get(UserId);
        JsonText := GetInfoFromToggle(togglesetup."Toggl Api Time Entries Link", usersetup."1CF Toggl Api Key", 'api_token');
        jsontextreader.ReadJSonToJSonBuffer(JsonText, jsonbuffer);
        row := 0;
        jsonbuffer.SetFilter(Path, '*[' + format(row) + ']*');
        if jsonbuffer.FindSet() then begin
            togglentries."User ID" := UserId;
            repeat
                togglentries.Init();
                jsonbuffer.SetFilter(Path, '*[' + format(row) + '].id*');
                jsonbuffer.SetRange("Token type", jsonbuffer."Token type"::Integer);
                if jsonbuffer.FindFirst() then begin
                    evaluate(togglentries."Entry No.", jsonbuffer.Value);
                end;
                jsonbuffer.SetFilter(Path, '*[' + format(row) + '].pid*');
                jsonbuffer.SetRange("Token type", jsonbuffer."Token type"::Integer);
                if jsonbuffer.FindFirst() then begin
                    togglentries.Projectid := jsonbuffer.Value;

                    togglprojects.SetRange(UserID, UserId);
                    togglprojects.SetRange(ProjectID, togglentries.Projectid);
                    if not togglprojects.FindFirst() and (togglentries.ProjectID <> '') then begin
                        togglentries.ClientID := FillProject(togglentries.Projectid);
                    end else begin
                        togglentries.ClientID := togglprojects.ClientID;
                    end;
                end;
                jsonbuffer.SetFilter(Path, '[' + format(row) + '].description*');
                jsonbuffer.SetRange("Token type", jsonbuffer."Token type"::String);
                if jsonbuffer.FindFirst() then begin
                    togglentries.Description := jsonbuffer.Value;
                end;
                jsonbuffer.SetFilter(Path, '[' + format(row) + '].start*');
                jsonbuffer.SetRange("Token type", jsonbuffer."Token type"::Date);
                if jsonbuffer.FindFirst() then begin
                    evaluate(togglentries."Start Date", jsonbuffer.Value);
                end;
                jsonbuffer.SetFilter(Path, '[' + format(row) + '].stop*');
                jsonbuffer.SetRange("Token type", jsonbuffer."Token type"::Date);
                if jsonbuffer.FindFirst() then begin
                    evaluate(togglentries."end Date", jsonbuffer.Value);
                end;
                jsonbuffer.SetFilter(Path, '[' + format(row) + '].tags[0]*');
                jsonbuffer.SetRange("Token type", jsonbuffer."Token type"::String);
                if jsonbuffer.FindFirst() then begin
                    evaluate(togglentries.Tag, jsonbuffer.Value);
                end;
                if not togglentries.get(UserId, togglentries."Entry No.") then begin
                    togglentries.Insert();
                end;
                row += 1;
                jsonbuffer.reset;
                jsonbuffer.SetFilter(Path, '*[' + format(row) + ']*');
            until jsonbuffer.FindSet() = false;
        end;
    end;

    procedure FillProject(ProjectID: Text): text;
    var
        togglesetup: Record "1CF Toggl Setup";
        usersetup: Record "User Setup";
        jsonbuffer: Record "JSON Buffer" temporary;
        toggproject: Record "1CF Toggl Project";
        jsontextreader: Codeunit "Json Text Reader/Writer";
        JsonText: Text;
    begin
        togglesetup.Get();
        usersetup.get(UserId);
        JsonText := GetInfoFromToggle(togglesetup."Toggl Api projects Link" + '/' + ProjectID, usersetup."1CF Toggl Api Key", 'api_token');
        jsontextreader.ReadJSonToJSonBuffer(JsonText, jsonbuffer);
        if jsonbuffer.FindSet() then begin
            repeat
                toggproject.init;
                toggproject.UserID := UserId;
                jsonbuffer.SetFilter(Path, 'data.id');
                jsonbuffer.SetRange("Token type", jsonbuffer."Token type"::Integer);
                if jsonbuffer.FindFirst() then begin
                    evaluate(toggproject.ProjectID, jsonbuffer.Value);
                end;
                jsonbuffer.SetFilter(Path, 'data.cid');
                jsonbuffer.SetRange("Token type", jsonbuffer."Token type"::Integer);
                if jsonbuffer.FindFirst() then begin
                    evaluate(toggproject.ClientID, jsonbuffer.Value);
                end;
                jsonbuffer.SetFilter(Path, 'data.name');
                jsonbuffer.SetRange("Token type", jsonbuffer."Token type"::String);
                if jsonbuffer.FindFirst() then begin
                    evaluate(toggproject.ProjectName, jsonbuffer.Value);
                end;
                toggproject.Insert();
            until jsonbuffer.next = 0;
        end;
        exit(toggproject.ClientID);
    end;

    procedure RenewUserClients()
    var
        togglesetup: Record "1CF Toggl Setup";
        usersetup: Record "User Setup";
        jsonbuffer: Record "JSON Buffer" temporary;
        toggclient: Record "1CF Toggl Client";
        jsontextreader: Codeunit "Json Text Reader/Writer";
        JsonText: Text;
        row: Integer;
    begin
        togglesetup.Get();
        usersetup.get(UserId);
        JsonText := GetInfoFromToggle(togglesetup."Toggl Api Clients Link", usersetup."1CF Toggl Api Key", 'api_token');
        jsontextreader.ReadJSonToJSonBuffer(JsonText, jsonbuffer);
        row := 0;
        jsonbuffer.SetFilter(Path, '*[' + format(row) + ']*');
        if jsonbuffer.FindSet() then begin
            repeat

                toggclient.init;
                toggclient.UserID := UserId;
                jsonbuffer.SetFilter(Path, '[' + format(row) + '].id');
                jsonbuffer.SetRange("Token type", jsonbuffer."Token type"::Integer);
                if jsonbuffer.FindFirst() then begin
                    evaluate(toggclient.clientid, jsonbuffer.Value);
                end;
                jsonbuffer.SetFilter(Path, '[' + format(row) + '].name');
                jsonbuffer.SetRange("Token type", jsonbuffer."Token type"::String);
                if jsonbuffer.FindFirst() then begin
                    evaluate(toggclient.ClientName, jsonbuffer.Value);
                end;
                if not toggclient.get(UserId, toggclient.ClientID) then begin
                    toggclient.Insert();
                end;
                row += 1;
                jsonbuffer.reset;
                jsonbuffer.SetFilter(Path, '*[' + format(row) + ']*');
            until jsonbuffer.FindSet() = false;
        end;
    end;

    procedure CreateTogglClient(Job: Record Job)
    var
        TempBlob: Record TempBlob temporary;
        TogglSetup: Record "1CF Toggl Setup";
        UserSetup: Record "User Setup";
        TogglClient: Record "1CF Toggl Client";
        TogglProject: Record "1CF Toggl Project";
        JobTask: Record "Job Task";
        Client: HttpClient;
        Headers: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Content: HttpContent;
        AuthText: text;
        ResponseText: text;
        JsonContent: JsonObject;
        JsonContent2: JsonObject;
        JToken: JsonToken;
        JArray: JsonArray;
        tempText: Text;
        TogglClientText: Text;
        TogglProjectText: Text;
    begin
        TogglSetup.Get();
        UserSetup.Get(UserId());
        TogglSetup.TestField("Toggl Api Clients Link");
        TogglSetup.TestField("Toggl Api Projects Link");
        RequestMessage.Method := Format('POST');
        RequestMessage.SetRequestUri(TogglSetup."Toggl Api Clients Link");

        RequestMessage.GetHeaders(Headers);
        AuthText := StrSubstNo('%1:%2', UserSetup."1CF Toggl Api Key", 'api_token');
        TempBlob.WriteAsText(AuthText, TextEncoding::Windows);
        Headers.Add('Authorization', StrSubstNo('Basic %1', TempBlob.ToBase64String()));
        JsonContent2.Add('name', Job."No.");
        JsonContent2.Add('wid', UserSetup."1CF Workspace ID");
        JsonContent.Add('client', JsonContent2);
        Content.GetHeaders(Headers);
        Headers.Remove('Content-Type');
        Headers.Add('Content-Type', 'application/json');
        JsonContent.WriteTo(tempText);
        Content.WriteFrom(tempText);
        RequestMessage.Content(Content);
        Client.Send(RequestMessage, ResponseMessage);
        if ResponseMessage.HttpStatusCode = 200 then begin
            Clear(JsonContent);
            ResponseMessage.Content.ReadAs(ResponseText);
            JsonContent.ReadFrom(ResponseText);
            JsonContent.Get('data', JToken);
            JToken.AsObject().Get('id', JToken);
            JToken.WriteTo(TogglClientText);
            if not TogglClient.Get(UserSetup."User ID", TogglClientText) then begin
                TogglClient.Init();
                TogglClient.validate(UserID, UserSetup."User ID");
                TogglClient.Validate(ClientID, TogglClientText);
                TogglClient.Validate(ClientName, job."No.");
                TogglClient.Insert(true);
            end;
        end
        else begin
            Error('Something went wrong:\%1 - %2', ResponseMessage.HttpStatusCode, ResponseMessage.ReasonPhrase);
        end;

        JobTask.Reset();
        JobTask.SetRange("Job No.", Job."No.");
        if JobTask.FindSet() then
            repeat
                Clear(RequestMessage);
                Clear(Headers);
                Clear(JsonContent2);
                Clear(JsonContent);
                Clear(Content);
                Clear(Client);
                Clear(ResponseMessage);

                RequestMessage.Method := Format('POST');
                RequestMessage.SetRequestUri(TogglSetup."Toggl Api Projects Link");
                RequestMessage.GetHeaders(Headers);
                AuthText := StrSubstNo('%1:%2', UserSetup."1CF Toggl Api Key", 'api_token');
                TempBlob.WriteAsText(AuthText, TextEncoding::Windows);
                Headers.Add('Authorization', StrSubstNo('Basic %1', TempBlob.ToBase64String()));

                JsonContent2.Add('name', JobTask."Job Task No.");
                JsonContent2.Add('wid', UserSetup."1CF Workspace ID");
                JsonContent2.Add('cid', TogglClient.ClientID);
                JsonContent.Add('project', JsonContent2);
                Content.GetHeaders(Headers);
                Headers.Remove('Content-Type');
                Headers.Add('Content-Type', 'application/json');
                JsonContent.WriteTo(tempText);
                Content.WriteFrom(tempText);
                RequestMessage.Content(Content);
                Client.Send(RequestMessage, ResponseMessage);
                Clear(TogglProjectText);
                if ResponseMessage.HttpStatusCode = 200 then begin
                    Clear(JsonContent);
                    ResponseMessage.Content.ReadAs(ResponseText);
                    JsonContent.ReadFrom(ResponseText);
                    JsonContent.Get('data', JToken);
                    JToken.AsObject().Get('id', JToken);
                    JToken.WriteTo(TogglProjectText);
                    if not TogglProject.Get(UserSetup."User ID", TogglClient.ClientID, TogglProjectText) then begin
                        TogglProject.Init();
                        TogglProject.Validate(UserID, UserSetup."User ID");
                        TogglProject.Validate(ClientID, TogglClient.ClientID);
                        // TogglProject.Validate(ClientName, TogglClient.ClientName);
                        TogglProject.Validate(ProjectID, TogglProjectText);
                        TogglProject.Validate(ProjectName, JobTask."Job Task No.");
                        TogglProject.Insert(true);
                    end
                    else begin

                    end;
                end;
            until JobTask.Next() = 0;
    end;
}