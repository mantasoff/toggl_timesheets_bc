codeunit 50100 "1CF Toggle Management"
{
    trigger OnRun()
    begin
    end;

    procedure GetInfoFromToggle(togglID: text; togglPassword: text): Text
    var
        TempBlob: Record TempBlob temporary;
        ToggSetup: Record "1CF Toggl Setup";
        Client: HttpClient;
        Headers: HttpHeaders;
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
        AuthText: text;
        ResponseText: text;
    begin
        ToggSetup.Get();

        RequestMessage.Method := Format('GET');
        RequestMessage.SetRequestUri(ToggSetup."Toggl Api Link");

        RequestMessage.GetHeaders(Headers);

        AuthText := StrSubstNo('%1:%2', togglID, togglPassword);
        TempBlob.WriteAsText(AuthText, TextEncoding::Windows);
        Headers.Add('Authorization', StrSubstNo('Basic %1', TempBlob.ToBase64String()));

        Client.Send(RequestMessage, ResponseMessage);

        ResponseMessage.Content().ReadAs(responsetext);

        exit(responsetext);
    end;

    procedure FillTogglEntries(JsonText: Text)
    var
        togglentries: record "1CF Toggl Entries";
        jsonbuffer: Record "JSON Buffer" temporary;
        jsontextreader: Codeunit "Json Text Reader/Writer";
    begin
        jsontextreader.ReadJSonToJSonBuffer(JsonText, jsonbuffer);
        jsonbuffer.SetRange("Token type", jsonbuffer."Token type"::String);
        jsonbuffer.Setfilter(Path, '*description');
        togglentries.DeleteAll();
        if jsonbuffer.FindSet() then begin
            repeat
                togglentries.Init();
                togglentries."Entry No." := 0;
                togglentries.Description := format(jsonbuffer."Token type") + '__' + jsonbuffer.Path + '__' + jsonbuffer.Value;
                togglentries.Insert();
            until jsonbuffer.Next() = 0;
        end;
    end;
}