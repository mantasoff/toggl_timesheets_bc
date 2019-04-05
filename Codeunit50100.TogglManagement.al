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

        ResponseMessage.Content.ReadAs(responsetext);

        exit(responsetext);
    end;

    procedure FillTogglEntries(JsonText: Text)
    var
        togglentries: record "1CF Toggl Entries";
        jsonbuffer: Record "JSON Buffer" temporary;
        jsontextreader: Codeunit "Json Text Reader/Writer";
        row: Integer;
    begin
        jsontextreader.ReadJSonToJSonBuffer(JsonText, jsonbuffer);
        togglentries.DeleteAll();
        row := 0;
        jsonbuffer.SetFilter(Path, '*[' + format(row) + ']*');
        if jsonbuffer.FindSet() then begin
            togglentries."User ID" := UserId;
            repeat
                togglentries."Entry No." := 0;
                togglentries.Init();

                jsonbuffer.SetFilter(Path, '*[' + format(row) + '].wid*');
                jsonbuffer.SetRange("Token type", jsonbuffer."Token type"::Integer);
                if jsonbuffer.FindFirst() then begin
                    togglentries.Project := jsonbuffer.Value;
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
                jsonbuffer.SetRange("Token type", jsonbuffer."Token type"::Date);
                if jsonbuffer.FindFirst() then begin
                    evaluate(togglentries."end Date", jsonbuffer.Value);
                end;
                togglentries.Insert();
                row += 1;
                jsonbuffer.reset;
                jsonbuffer.SetFilter(Path, '*[' + format(row) + ']*');
            until jsonbuffer.FindSet() = false;
        end;
    end;
}