codeunit 50100 "1CF Toggle Management"
{
    trigger OnRun()
    begin
    end;

    procedure "1CFGetInfoFromToggle"(togglID: text; togglPassword: text): Text
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
}