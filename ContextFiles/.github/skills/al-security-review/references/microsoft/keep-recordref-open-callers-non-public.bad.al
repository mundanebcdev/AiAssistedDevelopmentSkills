codeunit 50243 "Sec Sample RecordRef Bad"
{
    procedure ArchiveRecord(RecId: RecordId)
    var
        RecRef: RecordRef;
    begin
        RecRef.Open(RecId.TableNo);
        RecRef.Get(RecId);
        RecRef.Delete();
        RecRef.Close();
    end;
}
