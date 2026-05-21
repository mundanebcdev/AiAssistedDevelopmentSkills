codeunit 50242 "Sec Sample RecordRef Good"
{
    internal procedure ArchiveRecord(RecId: RecordId)
    var
        RecRef: RecordRef;
    begin
        RecRef.Open(RecId.TableNo);
        RecRef.Get(RecId);
        RecRef.Delete();
        RecRef.Close();
    end;
}
