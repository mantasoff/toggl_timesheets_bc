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
        Client: HttpClient;
        Headers: HttpHeaders;
        // RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        Content: HttpContent;
        AuthText: text;
        ResponseText: text;
    begin
        TogglSetup.Get();
        TogglSetup.TestField("Toggl Api Clients Link");
        Client.Post(TogglSetup."Toggl Api Clients Link", Content, ResponseMessage);
    end;

    procedure GetWorkspaceID(apiKey: Text[250]): Text
    var
        myInt: Integer;
        jsonObject: JsonObject;
        userSetup: Record "User Setup";
        jsonText: Text;
        toggleSetup: Record "1CF Toggl Setup";
        url: text;
        jsonArray: JsonArray;
        jsonToken: JsonToken;
        idResult: Text;
    begin
        url := 'https://www.toggl.com/api/v8/workspaces';
        jsonText := GetInfoFromToggle(url, apiKey, 'api_token');
        jsonArray.ReadFrom(jsonText);
        jsonArray.Get(0, jsonToken);
        jsonObject := jsonToken.AsObject();
        jsonObject.Get('id', jsonToken);
        jsonToken.WriteTo(idResult);
        exit(idResult);
    end;
}