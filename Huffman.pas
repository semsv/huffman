unit Huffman;
{--------------------------------------------------
����� ���������� ������������ �������� ��������*:
����������� ����� ������������
*�������� Huffman's ������������� ������� ����������.
*������� ���� ��������� �� ��������.
--------------------------------------------------}
            
interface
                   
uses
  Windows, Messages, SysUtils, Classes, UAuxiliaryH;

Type

  {--- ��� ��������� ������� --------------------------------------------}
  TEventOnReadInBuffer = Procedure (FirstRunRead:Boolean; Buffer : TBuffer; LastPart:Boolean) of Object;
  TEventOnBeforeReadInBuffer = Procedure (FirstRunRead:Boolean) of Object;
  {--- ��� ���������� ������� -------------------------------------------}
  TEventOnAfterUnPack = Procedure of Object;
  TEventOnAfterCreatePrefics = Procedure (PreficsCode:TPreficsCode) of Object;
  TEventOnAfterLoadPrefics = Procedure (PreficsCode:TPreficsCode) of Object;
  TEventOnAfterInitCodeTable =Procedure Of Object;
  TEventOnBeforePackBlock = Procedure (ReadByte:Integer; PackByte:Integer) Of Object;
  TEventOnAfterSaveHeader = Procedure Of Object;
  TEventOnInitCodeTable = Procedure (ProgressByte:Integer) Of Object;
  TEventOnOpenSourceFile = Procedure Of Object;
  TEventUnPackBlock = Procedure (ProcessByte : Integer; UnPackByte : Integer) Of Object;
  TEventOnAfterLoadHeader = Procedure Of Object;
  TEventOnAfterPack = Procedure Of Object;

  THuffman = class(TComponent)
  private
    { Private declarations }
   FOnReadInBuffer : TEventOnReadInBuffer; // ������� ����������� ��� ������ �� ����� � ������
   FOnBeforeReadInBuffer : TEventOnBeforeReadInBuffer;
   FOnAfterUnPack : TEventOnAfterUnPack;
   FOnAfterLoadPrefics : TEventOnAfterLoadPrefics;
   FOnAfterCreatePrefics : TEventOnAfterCreatePrefics;
   FOnBeforePackBlock : TEventOnBeforePackBlock;
   FOnAfterSaveHeader : TEventOnAfterSaveHeader;
   FOnInitCodeTable : TEventOnInitCodeTable;
   FOnOpenSourceFile:TEventOnOpenSourceFile;
   FOnUnPackBlock : TEventUnPackBlock;
   FOnAfterLoadHeader : TEventOnAfterLoadHeader;
   FOnAfterPack : TEventOnAfterPack;

   FRest            : String; // ������� - ������������ ��� ����������
   f_rest_bits      : String; // ������� - ������������ ��� ������� ���������� (������� ��������� ��� ������������� �������������� ������� � ��������� ������ ���)
   FLNFLB           : Byte;   // Length Not Full Last Byte / Special Mask
   FSeekFLNFLB      : Byte;   // �������� � �����
   FMASKBITS        : Byte;
   {-- ���������� �����. ��� ������ ����� -----}
   FFileHandle      : Cardinal;
   FFileSize        : Cardinal;
   FFileSizeHigh    : Cardinal;
   FFileOpen        : Boolean;
   FPPB             : TPackPreficsBuffer;
   FCodeTable       : TCodeTable;
   FPreficsCode     : TPreficsCode; // * ����� ������������ ��� ������������
   FWinHandle       : HWND;         // ���������� ���� windows ��� ������ ���������� �� �������
   FUnPackFileName  : String;
   {-------------------------------------------}
   FSFileName       : String;  // Source File Name
   FPackHeaderSize  : Integer; // ��� ����������� �������� � �������� - PackHeaderSize
   FConnectAPLCount : Boolean; // ���������� ������ �������� CountA1 , CountA2 � ��������� ������
   FTwoBCountP      : Boolean; // ���. - ������� ��� ���������� ����� �������� 1 ���� ?  ��� 2 �����? (True = 2 , False = 1)
   FExecuteError    : Boolean; // ������������� ������������� ������
   FFirstFlushPPB   : Boolean; // ���� ������ �� ����������� ����� ����������� � ������ ���
   FCurrentFilePos  : Integer;
   FSecurityKeyLen  : Integer;

   FStop            : Boolean;
   Procedure Init(TreeTable:TTreeTable);
  protected
    { Protected declarations }
   Procedure OpenFileToPack(FileName : String);
   Procedure OpenPackFile(PackFileName : String);

   Procedure ProcessError(ErrorCode:Integer; ErrorInProc:String; Break : Boolean);
   Procedure SaveByteA(A:TAuxiliaryA;FileName:String);

   Procedure FileReadInBuffer(FirstRunRead : Boolean; UnPack : Boolean; FileSeek : Int64);
   procedure PEventReadInBuffer(FirstRunRead: Boolean;
              Buffer: TBuffer; LastPart: Boolean);
   procedure PEventBeforeReadInBuffer(FirstRunRead: Boolean);
   procedure UnPackBlock(Block:TBuffer; LastPart:Boolean;  PreficsCode:TPreficsCode; PackFileName:String);
   Property OnReadInBuffer:TEventOnReadInBuffer read FOnReadInBuffer write FOnReadInBuffer;
   Property OnBeforeReadInBuffer:TEventOnBeforeReadInBuffer read FOnBeforeReadInBuffer write FOnBeforeReadInBuffer;
  public
    { Public declarations }
   Constructor Create(AOwner:TComponent);Override;
   Destructor Destroy; Override;
   procedure  Stop;

   Procedure CreateTree(CodeTable:TCodeTable; Var TreeTable:TTreeTable);
   Function GetAllusionsToItIndex(TreeTable:TTreeTable;
     Var CheckAItm:TCheckAItm):Boolean;  // ����� ������ ��� �������� � ��������
   Function GetCourseToIndex(Index:Integer;TreeTable:TTreeTable;
          CheckAItm:TCheckAItm):String;
   Procedure SortedRow(Row:Integer;Var TreeTable:TTreeTable);
   Function InitTable(Buffer:TBuffer;Var CodeTable:TCodeTable):Boolean;
   Procedure GetPreficsCode(TreeTable:TTreeTable;
    CheckAItm:TCheckAItm;Var PreficsCode:TPreficsCode);

   Procedure PackBuffer(Buffer:TBuffer;PreficsCode:TPreficsCode;
    Var PB   : String);
   Procedure PackPreficsBuffer( PB  : String;
    Var PPB : TPackPreficsBuffer );
   Function  FlushPPBToFile( Var PPB : TPackPreficsBuffer;
    FileName : String; LastPartBuff : Boolean ) : Boolean;
   Function CreatePackHeader(PreficsCode:TPreficsCode; Var Header:THeader):Boolean;
   Function SavePackHeader(Header:THeader; FileName:String):Boolean;

   Function LoadPackHeader(FileName:String; Var Header:THeader):Boolean;
   Procedure PreficsCodeOfH(H:THeader;Var PreficsCode:TPreficsCode);
   Procedure UnPackStringBuffer(PreficsCode:TPreficsCode;
           UNPB:String; UnPackFileN:String; Var CountByte : Integer);

   Procedure UnPackFile(PackFileName : String);

   Function SaveInHeaderLNFLB(FileName:String; LNFLB:Byte):Boolean;
   Procedure PackFile(FileName:String);
   Procedure CreatePreficsCode(CodeTable:TCodeTable; Var PreficsCode:TPreficsCode);
   Function TestPreficsCode(PreficsCode:TPreficsCode):Boolean;
   Procedure SortPreficsCodeToLength(Var PreficsCode:TPreficsCode);

   Property SourceFileSize : Cardinal read FFileSize;
   Property PackHeaderSize : Integer read FPackHeaderSize;
   property WinHandle      : HWND read FWinHandle write FWinHandle;
   property SecurityKeyLen : Integer read FSecurityKeyLen write FSecurityKeyLen;
  published
    { Published declarations }
   Property OnOpenSourceFile:TEventOnOpenSourceFile read FOnOpenSourceFile write FOnOpenSourceFile;
   Property OnInitCodeTable:TEventOnInitCodeTable read FOnInitCodeTable write FOnInitCodeTable;
   Property OnAfterCreatePrefics:TEventOnAfterCreatePrefics read FOnAfterCreatePrefics write FOnAfterCreatePrefics;
   Property OnAfterLoadHeader:TEventOnAfterLoadHeader read FOnAfterLoadHeader write FOnAfterLoadHeader;
   Property OnAfterSaveHeader:TEventOnAfterSaveHeader read FOnAfterSaveHeader write FOnAfterSaveHeader;
   Property OnBeforePackBlock:TEventOnBeforePackBlock read FOnBeforePackBlock write FOnBeforePackBlock;

   Property OnAfterLoadPrefics:TEventOnAfterLoadPrefics read FOnAfterLoadPrefics write FOnAfterLoadPrefics;
   Property OnAfterUnPack:TEventOnAfterUnPack read FOnAfterUnPack write FOnAfterUnPack;
   Property OnUnPackBlock:TEventUnPackBlock read FOnUnPackBlock write FOnUnPackBlock;
   Property OnAfterPack:TEventOnAfterPack read FOnAfterPack write FOnAfterPack;
  end;

procedure Register;

implementation

Procedure ClearIOStatus;
 Var
  IO : Integer;
begin
 IO:=IOResult;
 IF IO <> 0 then ;
end;

Procedure THuffman.ProcessError(ErrorCode : Integer; ErrorInProc : String; Break : Boolean);
Var
 F     : TStringList;
begin
 try
  F := TStringList.Create;
  if fileexists('debug.txt') then F.LoadFromFile('debug.txt');
  F.Add('Error Code = ' + inttostr(ErrorCode) + '; ' + ErrorInProc);
  F.SaveToFile('debug.txt');
  F.Free;
 finally
  FExecuteError := true;
 end;
end;

Procedure THuffman.CreatePreficsCode(CodeTable:TCodeTable; Var PreficsCode:TPreficsCode);
// ��������� �������� ����������� ����
Var
 TreeTable:TTreeTable;
 CheckAItm:TCheckAItm;
begin
 CreateTree(CodeTable,TreeTable); // �������� ������ Huffman's
 GetAllusionsToItIndex(TreeTable, CheckAItm); // ����� ������ ��� ���� ��������� ������
 GetPreficsCode(TreeTable,CheckAItm,PreficsCode); // �������� ���������� ����
 FreeTreeTable(TreeTable); // ����������� ������
 FreeCheckAItm(CheckAItm); // ����������� ������
 SortPreficsCodeToLength(PreficsCode); // ���������� ����������� ���� �� ������
 If TestPreficsCode(PreficsCode) then // �������� ���� �� ���� ��� ������������
  begin
   If Assigned(FOnAfterCreatePrefics) then FOnAfterCreatePrefics(FPreficsCode);
    FileReadInBuffer(false, false, 0); // �������� ������ ����� (false = ������ ������) ��� ���������
  end;
end;

{--- ������������ ��������� �������  ---------------------------------}
procedure THuffman.PEventReadInBuffer(FirstRunRead: Boolean;
  Buffer: TBuffer; LastPart: Boolean);
// ������� ��������� ��� ������ � ����� ����� ������ �� �����
// ��������� ���� ������ ���������� � ���������� Buffer ������� �������� ��
// ���� � ������ ��������� ��������� �������.
Var
  PB          : String;
begin
If FirstRunRead then // ������ ������ (�������� ������ Huffman's)
 begin
  InitTable(Buffer, FCodeTable); // ������������� ������� �������
 If Assigned(FOnInitCodeTable) then FOnInitCodeTable(Buffer.BufSize); // ����� �������
  If LastPart then             // �������� ��������� ���� �����
   begin
   FreePreficsCode(FPreficsCode); // ����������� ������ ����������
   FreePackPreficsBuffer(FPPB);   // ���������� ������������ ������� ������
   {--- ������� ���������� ��� -----------------}
   CreatePreficsCode(FCodeTable , FPreficsCode);
    // ��������� ��� �� ��������� ������ ������
   {-------------------------------------------}
   end;
 end
  else
 Begin // ������ ������ (�������������)
  PackBuffer(Buffer,FPreficsCode,PB); // �������� ������� � ������ ����
  PackPreficsBuffer(PB,FPPB);

  If Assigned(FOnBeforePackBlock) then
   begin
    If not LastPart then
     FOnBeforePackBlock(Buffer.BufSize, FPPB.CountFullByte) else // ����� ������� ����� ��������� �����
     FOnBeforePackBlock(Buffer.BufSize, FPPB.Count); // ����� ������� ����� ��������� �����
   end;
   
  FlushPPBToFile(FPPB, FSFileName, LastPart);
  FFirstFlushPPB:=false; // ������ ����������� ���� ������ ��������

  If LastPart then // �������� ��������� ���� �����
   Begin
    FreePackPreficsBuffer(FPPB);    // ����������� ������
    FreeCodeTable(FCodeTable);      // ����������� ������
    FreePreficsCode(FPreficsCode);  // ����������� ������
   end;
 end;
end;

procedure THuffman.PEventBeforeReadInBuffer(FirstRunRead: Boolean);
// ��������� ��������� ����� ������� ����� ������ �� �����.
 Var
  Header      : THeader;
begin
 If FirstRunRead then FreeCodeTable(FCodeTable); // ����������� ������
 If not FirstRunRead then // ������ ������ ( ����� �������������� )
  begin
  {--- ������� ��������� ������ ------------------}
    CreatePackHeader(FPreficsCode, Header);
    SavePackHeader(Header, FSFileName);
    FreePackHeader(Header);
  end;
end;
{---------------------------------------------------------------------}

Procedure THuffman.OpenFileToPack(FileName : String);
 Var
  Error : Integer;
begin
 //
 FFileHandle := FileOpen(FileName, fmOpenReadWrite or fmShareDenyWrite);
 If (FFileHandle = 0) or (FFileHandle = INVALID_HANDLE_VALUE) Then
  begin
   ProcessError(-1, '������ ������� � �����: ' + 'OpenFileToPack', true);
   Exit; // ���������� ������ ����� - ������
  end;

 FFileSize := windows.GetFileSize(FFileHandle, @FFileSizeHigh); // ���������� ������ ����� � ������
 Error     := 0;
 if FFileSize = 0 then Error     := -1;
 If Error <> 0 then
  begin
   FExecuteError := true;
   ProcessError(Error, ' ������ ��� ������, �. - FileSize', true);
   Exit; // ���������� ������ ����� - ������
  end;

 If Assigned(FOnOpenSourceFile) then FOnOpenSourceFile;
 FFileOpen := true;
end;

Procedure THuffman.PackFile(FileName:String);
 Var
  ErrorStr : String;
  DF       : Boolean;
begin
 FPackHeaderSize := 0;
 FExecuteError   := false;
 FStop           := false;

 FSFileName := FileName;
 FSFileName := DeleteFileExt(FSFileName);
 FSFileName := FSFileName + '.srj'; // ��� ����� ��� ���������
 IF lowercase(FileName) = lowercase(FSFileName) then
    Begin
     ErrorStr := '��� �������� � ��������� ����� ��������� !!!';
     ProcessError(0, ErrorStr, false);
     MessageBox(FWinHandle, PChar(ErrorStr), '������', MB_ICONERROR);
     Exit;
    end;

 DF := True;
 If FileExists(FSFileName) then
  DF := DeleteFile(FSFileName);      // �������� ������������� ���. �����
 If Not DF then
  begin
   ErrorStr      := '�� ������� ������� ���. ���� !!!';
   ProcessError(0, ErrorStr, false);
   MessageBox(FWinHandle, PChar(ErrorStr), '������', MB_ICONERROR);
   Exit;
  end;

 OpenFileToPack(FileName);
 if FExecuteError then Exit;       // ������������� ��������� ��������

 FileReadInBuffer(True, false, 0); // �������� ������ ����� (True = ������ ������ )
 if FExecuteError then Exit;       // ������������� ��������� ��������


 If Assigned(FOnAfterPack) then FOnAfterPack;
 
 if (FFileHandle <> 0) and (FFileHandle <> INVALID_HANDLE_VALUE) Then
  begin
    CloseHandle(FFileHandle);
    FFileHandle := INVALID_HANDLE_VALUE;
  end;
end;


Procedure THuffman.FileReadInBuffer(FirstRunRead : Boolean; UnPack : Boolean; FileSeek : Int64);
{**********************************************************************}
// ��������� ���������� ����������� ���������� ������ ������ �� �����
// � �������� ��� ������� :
// OnBeforeReadInBuffer - ����� ������� � ������   (���������� Buffer)
// OnReadInBuffer       - �� ����� ������ � ������ (���������� Buffer)
{**********************************************************************}
 Var
  Buffer   : TBuffer;
  ReadB    : Int64;
  EReadB   : Int64;
  Ostatok  : Int64;
  LastPart : Boolean;
begin
 If Not UnPack then
 If Not FFileOpen then Exit;
 SysUtils.FileSeek(FFileHandle, FileSeek, FILE_BEGIN);

 If not UnPack then
 If Assigned(FOnBeforeReadInBuffer) then
 FOnBeforeReadInBuffer(FirstRunRead); // �������� ������� ����� ������� � ������

{------------------------------------}
If UnPack then
ReadB := 1024 else
ReadB := 1024*20;
{------------------------------------}

EReadB:=0;

FFirstFlushPPB:=True;

If FFileSize-FileSeek <= ReadB then // ���� ����� ��������� ��������� � ������
 begin
  SysUtils.FileRead(FFileHandle, Buffer.Buf, FFileSize- FileSeek );
  Buffer.BufSize:=FFileSize - FileSeek; // ������ ������ = ������� �����
  LastPart:=true;

  If not UnPack then
  If Assigned(FOnReadInBuffer) then FOnReadInBuffer(FirstRunRead, Buffer, LastPart);

  If UnPack then UnPackBlock(Buffer,LastPart,FPreficsCode,FUnPackFileName);
 end else
 begin
  While FFileSize-FileSeek > EReadB+ReadB do // ������ �. ������ �����. ����.
   begin                            // � ������ ���� + ������ �������
    SysUtils.FileRead(FFileHandle, Buffer.Buf, ReadB);
    Buffer.BufSize := ReadB;
    EReadB         := EReadB + Buffer.BufSize; // ����������� ���-�� ����������� ����
    If FFileSize-FileSeek <> EREadB then LastPart:=false
     else LastPart:=True;

    If not UnPack then
    If Assigned(FOnReadInBuffer) then FOnReadInBuffer(FirstRunRead, Buffer, LastPart);
    if FExecuteError then exit;

    If UnPack then UnPackBlock(Buffer,LastPart,FPreficsCode,FUnPackFileName);
    if FStop then break;
   end;
  If FFileSize - FileSeek <= EReadB+ReadB then
   begin
   // ��������� ������� = (���-�� ����������� �. + ���-�� �������� � ������ �) - ������ �.
   Ostatok:= (EReadB+ReadB) - (FFileSize - FileSeek);
   // ���-�� �������� � ������ �. - ���-�� "������" ���� (Ostatok)
   ReadB:= ReadB - Ostatok;
   Buffer.BufSize:=ReadB;
   SysUtils.FileRead(FFileHandle, Buffer.Buf, ReadB);
   LastPart:=true;

   If not UnPack then
   If Assigned(FOnReadInBuffer) then FOnReadInBuffer(FirstRunRead, Buffer, LastPart);

   If UnPack then UnPackBlock(Buffer,LastPart,FPreficsCode,FUnPackFileName);
   end;
 end;
{------------------------------------}
// CloseFile(FFileHandle);{$I+}
// IoResult;
end;

Procedure THuffman.PackBuffer(Buffer:TBuffer;PreficsCode:TPreficsCode;
           Var PB:String);
 {----------------------------------}
 Function GetPreficsToCode(Code:Byte;PreficsCode:TPreficsCode):String;
  Var
   I : Integer;
 begin
  Result:='';
  For i:=0 to PreficsCode.Count-1 do
   begin
    If Code=PreficsCode.A[i].Code then
     begin
      Result := PreficsCode.A[i].Prefics;
      Break;
     end;
   end;
 end;
 {----------------------------------}
 Var
  I            : Integer;
  SPreficsCode : String;
begin
PB:='';
 For i:=1 to Buffer.BufSize do
  begin
   // ��������� ����������� ���� ��� �������� �������
   SPreficsCode:=GetPreficsToCode(Buffer.Buf[i] XOR FMASKBITS, PreficsCode );
   PB := PB + SPreficsCode;
  end;
end;

Function THuffman.CreatePackHeader(PreficsCode:TPreficsCode;
          Var Header:THeader):Boolean;
{--------------------------------------------}
 Procedure ADDPItmHeader(PItm:Byte;Var Header:THeader);
 begin
  If not Assigned(Header.Prefics) then
   begin
    Header.CountP:=0;
    Header.Prefics:=nil;
   end;
  Header.CountP:=Header.CountP+1;
  SetLength(Header.Prefics,Header.CountP);
  Header.Prefics[Header.CountP-1]:=PItm;
 end;
 Procedure PreficsCodeInHeader(PreficsCode:TPreficsCode;
          Var Header:THeader);
 Var
  I    : Integer;
  PB   : String;
  Leng : Integer;
  SPB  : String;
  PPB  : TPackPreficsBuffer;
 begin
  If Not Assigned(PreficsCode.A) then Exit;
  SPB:=''; PB:='';
  SetLength(Header.APL , PreficsCode.Count);
  For I:=0 to PreficsCode.Count-1 do
   begin
    Pb:=PreficsCode.A[I].Prefics;
    SPB:=SPB+PB;
    Leng:=Length(Pb);
    Header.APL[I]:=Leng;
   end;

 PackPreficsBuffer(SPB,PPB);
  If not Assigned(PPB.AB) or
     not Assigned(PPB.ALNFB) then Exit;
  For I:=0 to PPB.Count-1 do
   ADDPItmHeader(PPB.AB[i] , Header);
  FreePackPreficsBuffer(PPB); // ����������� ������
 end;
{--------------------------------------------}
 Var
  I    : Integer;
begin
 Result:=False;
 If not Assigned(PreficsCode.A) then Exit;
 FreePackHeader(Header);

 Header.Signature:=$4D48;(* = HM *)
 {-- ������ �������� ����� ��������� ���� --}
 Header.CountV:=PreficsCode.Count;
 SetLength(Header.ValueCode,Header.CountV);
 For i:=0 to Header.CountV-1 do
  Header.ValueCode[I]:=PreficsCode.A[I].Code;
 {------------------------------------------}

PreficsCodeInHeader(PreficsCode , Header);
Result:=True;
end;

Function THuffman.SavePackHeader(Header:THeader; FileName:String):Boolean;
 Var
   IOError : Integer;
   F       : File;
// Size    : Integer;
   B1 , B2 : Byte;
begin
Result:=false;
 If not Assigned(Header.ValueCode) then Exit;
 If not Assigned(Header.Prefics) then exit;
 {$I-}
 AssignFile(f,FileName);
 If FileExists(FileName) then Reset(f,1) else Rewrite(f,1);
 IOError:=IOResult;
 If IOError <> 0 then Exit;
 //Size:=FileSize(f);

 // If Size >0 then Seek(F,Size);
 IOError:=IOResult;
 If IOError <> 0 then Exit;

 {Header.FileName:=UnPackFileName; // ���������� ��� ����� {}
 Header.LNFLB:=0;
 PackAPL(Header);

 DEC(Header.CountV,1);
 DEC(Header.CountA1,1);
 DEC(Header.CountA2,1);
 DEC(Header.CountP,1);

 BlockWrite(F , Header.Signature, 2);
 BlockWrite(F , Header.LNFLB, 1);

 BlockWrite(F , Header.CountV, 1); // CountV Uses To Value

 FConnectAPLCount:=False; // ��� �������� ��� ������������ ������� �� ���������

 IF (Header.CountA1 > 15) or
    (Header.CountA2 > 15) then
   begin
    BlockWrite(F , Header.CountA1, 1);  // Count APL
    BlockWrite(F , Header.CountA2, 1);
   end else
   begin
    B1:=Header.CountA1;
    B2:=Header.CountA2;
    ConnectTwoByte(B1,B2, B1);
    BlockWrite(F , B1, 1);
    FConnectAPLCount:= True;
   end;

 FTwoBCountP:=False;
 If Header.CountP > 255 then
  begin
   FTwoBCountP:=true; // ���������� �������� ������������ ������
   BlockWrite(F , Header.CountP, 2);
  end else
  begin
   BlockWrite(F , Header.CountP, 1);
  end;

 INC(Header.CountV,1);
 INC(Header.CountA1,1);
 INC(Header.CountA2,1);
 INC(Header.CountP,1);

 BlockWrite(F,Header.ValueCode[0],Header.CountV);{}
 BlockWrite(F,Header.APL[0],Header.CountA1+Header.CountA2);{}
 BlockWrite(F,Header.Prefics[0],Header.CountP);{}

 Result:=True;
 FPackHeaderSize:=FilePos(F);
 //
 CloseFile(f);{$I+}
 IoError:=IOresult;
 If Assigned(FOnAfterSaveHeader) then FOnAfterSaveHeader;
 If IOError <> 0 then Exit;
end;

Function THuffman.LoadPackHeader(FileName:String; Var Header:THeader):Boolean;
 Var
 // IOError    : Integer;
 // F          : File;
  M , L       : Byte;
  A1 , A2     : Byte;
  ConnectA    : Boolean;
  TwoBCountP  : Boolean;
  cntbyteread : Int64;
  I           : Integer;
begin
 Result       := False;
 cntbyteread  := 0;
 FreePackHeader(Header);
 {$I-}
// AssignFile(f,FileName);Reset(f,1);
// IOError:=IOResult;
// If IOError<>0 then exit;

 sysutils.FileSeek(FFileHandle, 0, FILE_BEGIN);

 Header.CountV   := 0;
 Header.CountA1  := 0;

 cntbyteread :=
  cntbyteread + sysutils.FileRead(FFileHandle, Header.Signature, 2);
 If Header.Signature <> $4D48 then exit;
 cntbyteread :=
  cntbyteread + sysutils.FileRead(FFileHandle, Header.LNFLB ,1);

 DisTwoByte(Header.LNFLB, L , M);
 Header.LNFLB := L; // LNFLB=length not full last byte (������ �� ������� ���������� ����� � ���-�� �����)
 {--- ����������� ������ ��� ����� ---}
  asm
   PUSH AX
   XOR AX,AX

   MOV  AH , M
   MOV  AL , 1
   TEST AH , AL
   JNZ @TRUE // ��� ������
    MOV CONNECTA, 0  // ConnectA:=false;
    JMP @EXIT
   @TRUE:
    MOV CONNECTA, -1 // ConnectA:=True;
   @EXIT:

   POP AX
  end;
 {--- ����������� ������ ��� ����� ---}
  asm
   PUSH AX
   XOR AX,AX

   MOV  AH , M
   MOV  AL , 2
   TEST AH , AL
   JNZ @TRUE // 2 ��� ������
    MOV TwoBCountP , 0 // TwoBCountP:=false;
    JMP @EXIT
   @TRUE:
    MOV TwoBCountP , -1 // TwoBCountP:=True;
   @EXIT:

   POP AX
  end;
 {------------------------------------}
 cntbyteread :=
  cntbyteread + sysutils.FileRead(FFileHandle, Header.CountV, 1); // CountV Uses To Value
 If not ConnectA then
  begin
   cntbyteread :=
    cntbyteread + sysutils.FileRead(FFileHandle, Header.CountA1, 1); // Count A1
   cntbyteread :=
    cntbyteread + sysutils.FileRead(FFileHandle, Header.CountA2, 1); // Count A2
  end else
  begin
   cntbyteread :=
    cntbyteread + sysutils.FileRead(FFileHandle, Header.CountA1, 1); // Count A1
   A1             :=  Header.CountA1;
   DisTwoByte(A1, A1, A2);
   Header.CountA1 :=  A1;
   Header.CountA2 :=  A2;
  end;

 IF TwoBCountP then
  cntbyteread :=
   cntbyteread + sysutils.FileRead(FFileHandle, Header.CountP, 2) else // CountP Uses To Prefics
  cntbyteread :=
   cntbyteread + sysutils.FileRead(FFileHandle, Header.CountP, 1);


 INC(Header.CountV,1);   // ����������� �� 1
 INC(Header.CountA1,1);  // ����������� �� 1
 INC(Header.CountA2,1);  // ����������� �� 1
 INC(Header.CountP,1);   // ����������� �� 1

 SetLength(Header.ValueCode , Header.CountV);
 SetLength(Header.APL , Header.CountA1 + Header.CountA2 );
 SetLength(Header.Prefics   , Header.CountP);

 cntbyteread :=
  cntbyteread + sysutils.FileRead(FFileHandle, Header.ValueCode[0],Header.CountV);{}
 cntbyteread :=
  cntbyteread + sysutils.FileRead(FFileHandle, Header.APL[0],Header.CountA1 + Header.CountA2);{} // APL = Array Prefics Length
 UnPackAPL(Header); // ������������� ������ ����� ����������� �����
 cntbyteread :=
  cntbyteread + sysutils.FileRead(FFileHandle, Header.Prefics[0],Header.CountP);{}

// FOR I := 1 to Header.CountP do
//  begin
//    Header.Prefics[I] := Header.Prefics[I] XOR FMASKBITS;
//  end;

 Header.EndH  :=  cntbyteread;   // ���. ���. ���������
 FLNFLB       :=  Header.LNFLB; // ������ ���������� �� ������� �����

// CloseFile(F);{$I+}

 FPackHeaderSize := Header.EndH;
 If Assigned(FOnAfterLoadHeader) then FOnAfterLoadHeader;

// IOError:=IOResult;
 RESULT := True;
// If IOError<>0 then exit;
end;

Procedure THuffman.PreficsCodeOfH(H:THeader;Var PreficsCode:TPreficsCode);
 Var
  I    : Integer;
  PB   : String;
  S    : String;
  Leng : Integer;
  LI   : Integer;
begin
 FreePreficsCode(PreficsCode);
 PB:='';
 For i:=0 to H.CountP-1 do
  begin
   S:=IntToBin(H.Prefics[i]);
   PB:=PB+S;
  end;

 SetLength(PreficsCode.A , H.CountV);
 PreficsCode.Count:=H.CountV;

 LI:=1;
 For i:=0 to H.CountV-1 do
  begin
   Leng:=H.APL[i];
   PreficsCode.A[i].Prefics  := Copy(PB,LI,Leng);
   PreficsCode.A[i].LengPref := Length(PreficsCode.A[i].Prefics);
   PreficsCode.A[i].Code     := H.ValueCode[i];
   LI:=LI+Leng;
  end; 
end;

Procedure THuffman.OpenPackFile(PackFileName : String);
 Var
  Error       : Integer;
begin
 {}
 if (FFileHandle <> 0) and (FFileHandle <> INVALID_HANDLE_VALUE) Then
  begin
    CloseHandle(FFileHandle);
    FFileHandle := INVALID_HANDLE_VALUE;
  end;
 {}
 FFileHandle := FileOpen(PChar(PackFileName), fmOpenReadWrite or fmShareDenyWrite);
 If (FFileHandle = 0) or (FFileHandle = INVALID_HANDLE_VALUE) Then
  begin
   ProcessError(-1, '������ ������� � �����: ' + 'THuffman.OpenPackFile', true);
   Exit; // ���������� ������ ����� - ������
  end;

 FFileSize := windows.GetFileSize(FFileHandle, @FFileSizeHigh); // ���������� ������ ����� � ������
 Error     := 0;
 if FFileSize = 0 then Error     := -1;
 If Error <> 0 then
  begin
   MessageBox(FWinHandle, '������: ���� ��������� ������ ������!', '������', MB_ICONERROR);
   ProcessError(Error, ' ������ ��� ������: THuffman.OpenPackFile, �. - windows.FileSize ������� �������� 0', true);
   Exit; // ���������� ������ ����� - ������
  end;

 //CloseFile(FFileHandle); Error:=Ioresult;
 //If Error<>0 then
 // begin
 //  ProcessError(Error,'CloseFile',False); {$I+}
 //  Exit;
 // end;
 {}
end;

Procedure THuffman.UnPackFile(PackFileName : String);
Var
 Header      : THeader;
begin
 OpenPackFile(PackFileName);
 IF FExecuteError then Exit; // ������������� ������

 FStop           := false;
 f_rest_bits     := '';

 If Assigned(FOnOpenSourceFile) then FOnOpenSourceFile;
 {--- �������� ��������� ������ ---}
 if LoadPackHeader(PackFileName, Header) then
   {-- ����������� ���������� ���� --}
   PreficsCodeOfH(Header, FPreficsCode) else
   if (FWinHandle <> 0) and (FWinHandle <> INVALID_HANDLE_VALUE) then
    begin
      MessageBox(FWinHandle, '�� ���� ��������� ��������� ������ !', '������', MB_ICONERROR);
      exit;
    end;
   {---------------------------------}
 {---------------------------------}


 If Assigned(FOnAfterLoadPrefics) then FOnAfterLoadPrefics(FPreficsCode);

 PackFileName := ExtractFileName(PackFileName);
 PackFileName := DeleteFileExt(PackFileName);
 If FileExists(PackFileName) then
  begin
   if not DeleteFile(PackFileName) then
    begin
     MessageBox(WinHandle, '������ ������ ������� ������������� ���� ����� ��������� ���������� ������', '������', MB_ICONERROR);
     exit;
    end;
  end;

 FUnPackFileName := PackFileName;
 FRest := '';
 FileReadInBuffer(false, True, Header.EndH);

 FreePackHeader(Header); // ����������� ������
 If Assigned(FOnAfterUnPack) then FOnAfterUnPack;
 {--- ��������� ���������� ����� --}
 if (FFileHandle <> 0) and (FFileHandle <> INVALID_HANDLE_VALUE) Then
  begin
    CloseHandle(FFileHandle);
    FFileHandle := INVALID_HANDLE_VALUE;
  end;
 {}
end;

Function GetRStr (Block : TBuffer;Var NB:Integer;
         Var NR : Byte; Leng : Integer) : String;
 Var
  B  : Byte;
  ERead  : Byte; {}
  ARead  : Byte;
  Rest   : Byte;
  S  : String;
begin
S:='';

  B:=Block.Buf[NB];
  {If Leng <= 8 - NR then
   begin
    S:=IntToBin(B , NR , Leng);
    NR:=NR + Leng;
   end
  else
   begin{}
    ERead:=0; ARead:=8;
    While ERead+(ARead - NR) <= Leng do
     begin
      S := S + IntToBin(B , NR , ARead - NR);
      ERead:=ERead + (ARead - NR);

      NR:=NR + (ARead - NR);
      NB:=NB + 1;
      IF NB > Block.BufSize then
       begin
        Result:=S;
        Exit;
       end;
      B:=Block.Buf[NB];
      NR:=0;
     end;
    If ERead+(ARead - NR) > Leng Then
     begin
      Rest:=ERead + ARead - Leng;
      ARead:=ARead - Rest;
      S := S + IntToBin(B , NR , ARead);
      NR:=NR + ARead;
     end;
  {end;{}

Result:=S;
end;

{-- ���������� ���������������� ������� � ����,
    �������� ����������� ������ --}
Procedure THuffman.SaveByteA(A:TAuxiliaryA;FileName:String);
  Var
   F:FIle;
   Error:Integer;
 begin
  // exit;
  {$I-}
  AssignFile(F , FileName); Error:=IoResult;
  If Error<>0 then ProcessError(Error,'537: Before Reset',False);

  If FileExists(FileName) then
   Reset(f,1) else Rewrite(F,1); Error:=IoResult;
  If Error<>0 then ProcessError(Error,'541: Reset or Rewrite', True);

  If FileSize(F) > 0 then
   Seek(F,FileSize(F)); Error:=IoResult;
  If Error<>0 then ProcessError(Error,'545: Seek', True);

  BlockWrite(F,A.A[0] , A.Count);
  CloseFile(f); Error:=IoResult;
  If Ioresult<>0 then ProcessError(Error,'549: Close',False);{$I+}
 end;

 
(*��������� ���������������� ������� � ���������� ��� � � ����. *)
Procedure THuffman.UnPackStringBuffer(PreficsCode:TPreficsCode;
           UNPB:String; UnPackFileN:String; Var CountByte : Integer);
 Var
  I     : Integer;
  SUNPB : String; //Save UnPack Prefics Buffer
  Leng  : Integer;
  FP    : Boolean;
  Code  : Byte;
  A     : TAuxiliaryA;
  SCH   : Integer;
  p_ind : integer;
begin
FreeAuxiliaryA(A);
 CountByte := 0;
 Code      := 0;
 Sch       := 0;
 p_ind     := 1;
 Insert(FRest, UNPB, 1);

Repeat
 FP := False;

 For I := 0 to PreficsCode.Count-1 do
  begin
   Leng  := Length(PreficsCode.A[I].Prefics);
   SUNPB := '';
   SUNPB := Copy(UNPB, p_ind, Leng);

   If SUNPB = PreficsCode.A[I].Prefics then
    begin
     FP    := true;
     Code  := PreficsCode.A[I].Code;
     p_ind := p_ind + Leng;
     Break;
    end;
  end;

FRest:='';
If FP then
 begin
  EditItemAuxiliaryA(A ,SCH, Code);
  SCH := SCH + 1;
 end;

Until (Not FP) or (SUNPB='');
If Not FP then FRest := Copy(UNPB, p_ind, Length(UNPB));

A.Count   := SCH;
CountByte := A.Count;
 for I := 0 to A.Count-1 do
  begin
   A.A[I] := A.A[I] XOR FMASKBITS;
  end;
SaveByteA(A , UnPackFileN);
FreeAuxiliaryA(A);
end;

procedure THuffman.Stop;
begin
 FStop := true;
end;



Procedure THuffman.UnPackBlock(Block:TBuffer; LastPart:Boolean;
           PreficsCode:TPreficsCode; PackFileName:String);
 Var
  UNPB            : String;
  NR              : Byte;
  NB              : Integer;
  CFR             : Byte;{}
  CountUnPackByte : Integer;
begin
 NB := 1; NR := 0;
 UNPB:=GetRStr(Block,NB,NR,Block.BufSize*8);
 If LastPart then
    begin
     CFR:=8 - FLNFLB;
      If CFR <> 0 then
       Delete(UNPB,(Length(UNPB)-CFR)+1,CFR); // ������� ��������� �������
    end;
 {}
 UnPackStringBuffer(PreficsCode, UNPB, PackFileName, CountUnPackByte);{}
(**)
If Assigned(FOnUnPackBlock) then FOnUnPackBlock(Block.BufSize, CountUnPackByte);
end;

Function THuffman.SaveInHeaderLNFLB(FileName:String; LNFLB:Byte):Boolean;
 Var
  F       : File;
  IOError : Integer;
  M       : Byte;
begin
 Result:=false;
 {$I-}
 ClearIOStatus;
 AssignFile(f,FileName);
 Reset(f,1);
 IOError:=IOResult;
 If IOError <> 0 then
  begin
   ProcessError(IOError, '������ ������� � �����, �. - Reset', True);
   Exit;
  end;

 Seek(f , FSeekFLNFLB); // ������ � ����� ���� ����������������� �����
 IOError:=IOResult;
 If IOError <> 0 then
  begin
   ProcessError(IOError, '������ ��� ������, �. - Seek', True);
   Exit;
  end;
  
 IF FConnectAPLCount then
  M:=1 else M:=0;
 If FTwoBCountP then M:=M+2;  

 ConnectTwoByte(LNFLB,M, LNFLB); 

 BlockWrite(F,LNFLB,1);
 IOError:=IOResult;
 If IOError <> 0 then
  Begin
   ProcessError(IOError,'������ ��� ������, �. - BlockWrite',True);
   Exit;
  end;

 CloseFile(F); {$I+}
 ClearIOStatus;
end;

Function THuffman.FlushPPBToFile(Var PPB:TPackPreficsBuffer;
        FileName : String; LastPartBuff:Boolean) : Boolean;
Var
 I            : Integer;
 SCH          : Integer;
 F            : File;
 NewLengthPPB : Integer;
 IOError      : Integer;
 PCount       : Integer;
begin
Result:=false;
If Not Assigned(PPB.AB) or
   Not Assigned(PPB.ALNFB) then Exit;
{$I-} //
 AssignFile(f,FileName);
 If FileExists(FileName) then Reset(f,1) else
    Rewrite(F,1);

 IOError:=IOResult;
 If IOError <> 0 then
  Begin
   FExecuteError := true;
   ProcessError(IOError, '������ ������� � �����, �. - Reset ��� Rewrite', True);
   Exit;
  end;

 IF FFirstFlushPPB then
  FCurrentFilePos:=FPackHeaderSize;

 If FCurrentFilePos <> 0 then
  Seek(F, FCurrentFilePos); // ��������� � ���. FCurrentFilePos

 IOError:=IOResult;
 If IOError <> 0 then
  begin
   ProcessError(IOError,'������ ��� ������, �. - Seek', True);
   Exit;
  end;

 If LastPartBuff then        // ���� ������������ ��������� ����� �������
  PCount:=PPB.Count else     // ���. ����� ���-�� ���� �����
  PCount:=PPB.CountFullByte; // ������ ���-�� ������ ����
 {***
  � ���� ����� �����
  ���������� ������� ����������
  ������ ������ ����. (��� ���������� ������)
  ***}
 BlockWrite(F,PPB.AB[0],PCount);
 IOError:=IOResult;
 If IOError <> 0 then
  begin
   ProcessError(IOError,'������ ��� ������, �. - BlockWrite', True);
   Exit;
  end;

 FCurrentFilePos:=FilePos(F);

 CloseFile(F);{$I+}
 ClearIOStatus; // �������� ��������� ����� - ������ (������������� ������)

 If LastPartBuff then // ���� ������������ ��������� ����� �������
  begin
   FLNFLB:=PPB.ALNFB[PCount-1];        // ��������� �������� � ��������� ������
   SaveInHeaderLNFLB(FileName,FLNFLB); // ������ � �������� ���������� �� ������� �����
   FreePackPreficsBuffer(PPB);
   Result:=True;
   Exit;
  end;

 SCH:=0;
 For i:=PPB.Count-1 downto PPB.CountFullByte do
  begin
   PPB.AB[SCH]:=PPB.AB[I];
   PPB.ALNFB[SCH]:=PPB.ALNFB[I];
   SCH:=SCH+1;
  end;

 NewLengthPPB:=PPB.Count - PPB.CountFullByte;
 SetLength(PPB.AB    , NewLengthPPB);
 SetLength(PPB.ALNFB , NewLengthPPB);

 PPB.Count:=NewLengthPPB;
 PPB.CountFullByte:=0;

 Result:=True;
end;

Procedure THuffman.PackPreficsBuffer(PB:String;
              Var PPB:TPackPreficsBuffer);
{-----------------------------------------------}
Procedure AddPPBItem(PByte:Byte;FullByte:Boolean;
           LNFB:Byte; Var PPB:TPackPreficsBuffer);
Var
 FSB:Byte;   // Free Space Byte (���-�� ��������� �������� � �����)
 SByte:Byte; // Save Byte
begin
 If not Assigned(PPB.AB) or
    not Assigned(PPB.ALNFB) then
  begin
   PPB.Count:=0;
   PPB.CountFullByte:=0;
   PPB.AB:=nil;
   PPB.ALNFB:=nil;
  end;

 If PPB.Count - PPB.CountFullByte = 0 then
  Begin
   PPB.Count:=PPB.Count+1;
   SetLength(PPB.AB    , PPB.Count);
   SetLength(PPB.ALNFB , PPB.Count);

   If FullByte then
    PPB.CountFullByte:=PPB.CountFullByte+1;
   PPB.AB[PPB.Count-1]:=PByte;
   PPB.ALNFB[PPB.Count-1]:=LNFB; // Length Not Full Byte (������ �� ������� �����)
  end else
 If PPB.Count-PPB.CountFullByte = 1 then // �����. ���������� "�����������"
  begin
   FSB:=8-PPB.ALNFB[PPB.Count-1]; //���-�� ��������� �������� � �������� �����
   SByte:=PPB.AB[PPB.Count-1];
   If FSB > 0 then
    begin
     If FullByte then // ���� ���������� ������������ ������ ����
      begin  
         asm // BEGIN ASM BLOCK
          PUSH AX
          PUSH CX
          {-------------}
          MOV CH , FSB
          MOV CL , LNFB  // CL = LNFB = 8
          SUB CL , FSB   // CL = LNFB - FSB
          {--------------}
          MOV AH , SBYTE // AH = ���� � �������� �����. ������������ PBYTE
          {--------------}
          MOV AL , PBYTE // ������������� ����
          MOV CH , CL    // CH = ���-��  �������� ������� "�� ������".
          MOV CL , LNFB
          SUB CL , CH    // CL = ���-�� �������� � ������ �����
          SHR AH , CL    // � AH ���������� �����. ���-�� ��������
          SHL AX , CL    // ����� AX �� CL ��������
          MOV SBYTE , AH
          MOV PBYTE , AL
          {-------------}
          MOV CH , CL
          MOV CL , LNFB
          SUB CL , CH
          MOV LNFB , CL  // �������� ������ PByte

          POP CX
          POP AX
         end; // ASM BLOCK END
       PPB.AB[PPB.Count-1]:=SByte;
       PPB.ALNFB[PPB.Count-1]:=8;
       PPB.CountFullByte:=PPB.CountFullByte+1;
       {-------------------------------------}
       PPB.Count:=PPB.Count+1;
       SetLength(PPB.AB    , PPB.Count);
       SetLength(PPB.ALNFB , PPB.Count);

       If LNFB <> 8 then FullByte:=false;
       If FullByte then
        PPB.CountFullByte:=PPB.CountFullByte+1;
       PPB.AB[PPB.Count-1]    := PByte;
       PPB.ALNFB[PPB.Count-1] := LNFB; // Length Not Full Byte (������ �� ������� �����)
      end else
      begin // ���� ���������� ������������ �� ������ ����
       If FSB - LNFB >= 0 then // ���-�� ��������� �������� � �������� ����� - ������ � �������� ��������������� ����� ("������" ���� = 0)
        begin //
         SByte:=PPB.AB[PPB.Count-1];
         asm   // BEGIN ASM BLOCK
          PUSH AX
          PUSH CX
          {-------------}
          MOV AH , SBYTE  // AH = ���� � �������� �����. ������������ PBYTE
          {-------------}
          MOV AL , PBYTE  // ������������� ����
          MOV CL , LNFB   // ������ PBYTE
          MOV CH , FSB
          SUB CH , CL     // ��������� ������� �������� � ����� ������������ �����
          ADD CL , CH     // ����������� CL �� ���-�� ��������� ��������

          SHR AH , CL     // � AH ���������� �����. ���-�� ��������
          SHL AX , CL     // ����� AX �� CL ��������
          {-------------} // ��������� � AH
          MOV SBYTE , AH
          MOV LNFB , CH   // ������� �������� � ����� ������������ �����
          POP CX
          POP AX
         end; {} // ASM BLOCK END
         PPB.AB[PPB.Count-1]:=SByte;
         PPB.ALNFB[PPB.Count-1]:=8-LNFB;
         If 8-PPB.ALNFB[PPB.Count-1] = 0 then  //  ���-�� �������� � ����������� ����� = 8
         PPB.CountFullByte:=PPB.CountFullByte+1;
       {-------------------------------------}
        end // END to (If FSB - LNFB >= 0 then)
         else // (���� "�� ������")
        begin
         asm // BEGIN ASM BLOCK
          PUSH AX
          PUSH CX
          {-------------}
          MOV CH , FSB
          MOV CL , LNFB
          SUB CL , FSB   // CL = LNFB - FSB (�������� ���-�� �������� ������� "������")
          {--------------}
          MOV AH , SBYTE // AH = ���� � �������� �����. ������������ PBYTE
          {--------------}
          MOV AL , PBYTE // ������������� ����
          MOV CH , CL    // CH = ���-��  �������� ������� "�� ������".
          PUSH CX        // ��������� CX
          MOV CL , LNFB
          SUB CL , CH    // CL = ���-�� �������� � ������ �����
          SHR AH , CL    // � AH ���������� �����. ���-�� ��������
          SHL AX , CL    // ����� AX �� CL ��������
          {-------------}
          MOV SBYTE , AH
          POP CX         // ������������ CX
          MOV LNFB  , CH
          MOV PBYTE , AL

          POP CX
          POP AX
         end; // ASM BLOCK END
        PPB.AB[PPB.Count-1]:=SByte;
        PPB.ALNFB[PPB.Count-1]:=8;
        PPB.CountFullByte:=PPB.CountFullByte+1;
       {-------------------------------------}
        PPB.Count:=PPB.Count+1;
        SetLength(PPB.AB    , PPB.Count);
        SetLength(PPB.ALNFB , PPB.Count);
        If LNFB <> 8 then FullByte:=false;
        If FullByte then
         PPB.CountFullByte:=PPB.CountFullByte+1;
        PPB.AB[PPB.Count-1]    := PByte;
        PPB.ALNFB[PPB.Count-1] := LNFB; // Length Not Full Byte (������ �� ������� �����)
        end; // END TO BEGIN
      end;   //END TO BEGIN
    end else // END TO (If FSB > 0 then)
    begin
     PPB.Count:=PPB.Count+1;
     PPB.CountFullByte:=PPB.CountFullByte+1;
     SetLength(PPB.AB    , PPB.Count);
     SetLength(PPB.ALNFB , PPB.Count);
     If FullByte then
      PPB.CountFullByte:=PPB.CountFullByte+1;
     PPB.AB[PPB.Count-1]    := PByte;
     PPB.ALNFB[PPB.Count-1] := LNFB; // Length Not Full Byte (������ �� ������� �����)
    end;
  end;
end;
{-----------------------------------------------}
Var
 SPB      : String;  // Save Pack Buffer (to PB)
 BInt     : Byte;    // Pack Byte
 I        : Integer; // For Loop
 Leng     : Integer; // Length String
 OST      : Integer; // �������
 RBofS    : Integer; // Read Byte of String
 ARBofS   : Integer; // Read Byte of String A
 SHL1     : Byte;    // ��� ������ ����� � ����
begin
 Leng:=Length(Pb);
 i:=1; RBofS:=0; ARBofS:=8;
 While i+ARBofS-1<=Leng do
  begin
  SPB:='';
  SPB:=Copy(Pb,i,ARBofS);
  BInt:=BinToInt(SPB);
  // �����. ����. BInt
  AddPPBItem(BInt,true,ARBofS,PPB);
  i:=i+ARBofS;
  RBofS:=I-1;
  end;
 If Leng <= RBofS+ARBofS then
  begin
   Ost:=RBofS + ARBofS - Leng;
   ARBofS:=ARBofS - OST;
   SHL1:=8 - ARBofS; // ���������� �������� �� ������� �����. �������� ���� � ����
   SPB:=Copy(Pb,RBofS+1,ARBofS);
   BInt:=BinToInt(SPB);
    asm
     PUSH AX
     PUSH CX
     {--------}
     XOR  AX   , AX    // AX = 0
     XOR  CX   , CX    // CX = 0
     MOV  AH   , BInt  // ���������� ����
     MOV  CL   , SHL1  // ���-�� �������� ��� ������
     SHL  AH   , CL    // ����� �����
     MOV  BInt , AH
     {--------}
     POP CX
     POP AX
    end;
  // �����. ����. BInt
  AddPPBItem(BInt,false,ARBofS,PPB);
  end;
end;

Function THuffman.InitTable(Buffer:TBuffer;Var CodeTable:TCodeTable):Boolean;
Var
 I , J    : Integer;
 SchI     : Integer;
 NextCode : Byte;
 NextItem : Boolean;
begin
 If Not Assigned(CodeTable.Items) then
  begin
   CodeTable.Count:=0;//���-�� ��������� � �������
   CodeTable.Items:=nil;
  end;

 SchI:=CodeTable.Count; //������� ������� ��� �������

 For i:=1 to Buffer.BufSize do
  begin
   NextCode:=Buffer.Buf[i]  XOR FMASKBITS;
   NextItem:=True; //����. ����������. ��. � �������
   For j:=0 to CodeTable.Count-1 do
    begin
     If NextCode=CodeTable.Items[j].Code then
      begin
       NextItem:=False;
       CodeTable.Items[j].Code  := NextCode;
       CodeTable.Items[j].Count := CodeTable.Items[j].Count+1;
       Break;//���������� ����
      end;
    end;

   If NextItem then
    begin
     CodeTable.Count:=CodeTable.Count+1;
     SetLength(CodeTable.Items,CodeTable.Count);
     CodeTable.Items[SchI].Code:=NextCode;
     CodeTable.Items[SchI].Count:=1;
     SchI:=SchI+1;
    end;
  end;

Result:=True;
end;

Procedure THuffman.GetPreficsCode(TreeTable:TTreeTable;
    CheckAItm:TCheckAItm;Var PreficsCode:TPreficsCode);
Var
 I : Integer;
 S : String;
begin

 If Not Assigned(TreeTable.Items) then Exit;
 If Not Assigned(CheckAItm.AStopItm.AItm) then Exit;
 If Not Assigned(CheckAItm.ACheckAItm.AItm) then Exit;

 If Not Assigned(PreficsCode.A) then
  begin
   PreficsCode.A:=nil;
   PreficsCode.Count:=0;
  end else
  begin
   FreePreficsCode(PreficsCode); // ����������� ������
  end;

 S:='';
 For i:=0 to TreeTable.ColCount-1 do
  begin
   S:=GetCourseToIndex(I,TreeTable,CheckAItm);
   PreficsCode.Count:=PreficsCode.Count+1;
   //
   SetLength(PreficsCode.A,PreficsCode.Count);
   PreficsCode.A[i].Prefics  := S;
   PreficsCode.A[i].LengPref := Length(S);
   PreficsCode.A[i].Code     := TreeTable.Items[I,0].Code;
   PreficsCode.A[i].Value    := TreeTable.Items[I,0].Value;
  end;
//
end;

Procedure THuffman.SortPreficsCodeToLength(Var PreficsCode:TPreficsCode);
// ���������� ����������� ���� �� ������
  Var
   I , J : Integer;
   Leng1 : Integer;
   Leng2 : Integer;
   Str1  : String;
   Str2  : String;
Begin
 For I:=0 to PreficsCode.Count-1 do
  begin
   Str1:=PreficsCode.A[I].Prefics;
   Leng1:=Length(Str1);
    For J:=I+1 to PreficsCode.Count-1 do
     begin
      Str2:=PreficsCode.A[J].Prefics;
      Leng2:=Length(Str2);
       If Leng1 > Leng2 then
        begin
         PreficsCode.A[J].Prefics  := Str1;
         PreficsCode.A[J].LengPref := Length(Str1);
         PreficsCode.A[I].Prefics  := Str2;
         PreficsCode.A[I].LengPref := Length(Str2);
         Break; // ���������� �����. ����
        end;
     end;
  end;
end;

Function THuffman.TestPreficsCode(PreficsCode:TPreficsCode):Boolean;
// �������� ���� �� ���� ��� ������������
 Var
  I , J   : Integer;
  Leng    : Integer;
  Prefics : String;
  Str     : String;
begin
Result:=True;
 For J:=0 to PreficsCode.Count-1 do
  begin
   Prefics:=PreficsCode.A[J].Prefics;
   Leng:=Length(Prefics);
   For I:=J + 1 To PreficsCode.Count-1 do
    begin
     Str:=PreficsCode.A[i].Prefics; // ������ ����� ��������� ����
     Str:=Copy(Str,1,Leng); // �� ������ ��������� � ������� �����
                            // �������� ���� (���� ��� ��� �� ��� ����������)
     If Str=Prefics then    // ����� ��� �� ����������
      begin
       //
       Result:=False;
       Break;
      end;
    end;
  end;
end;

Procedure THuffman.Init(TreeTable:TTreeTable);
 Var
  I,J : Integer;
begin
 For J:=0 to TreeTable.RowCount-1 do
  For i:=0 to TreeTable.ColCount-1 do
   begin
    TreeTable.Items[i,j].SI1:=-1;
    TreeTable.Items[i,j].SI2:=-1;
   end;
end;

Procedure THuffman.SortedRow(Row:Integer;Var TreeTable:TTreeTable);
Var
 I,i1,J : Integer;
 Value  : Integer;
 R      : Boolean;
begin
J:=Row;
For i1:=0 to TreeTable.ColCount-2 do
 For i:=0 to TreeTable.ColCount-2 do
  begin
   Value:=TreeTable.Items[I,J].Value;
   If Value<TreeTable.Items[I+1,J].Value then
     begin
      TreeTable.Items[I,J].Value:=TreeTable.Items[I+1,J].Value;
      TreeTable.Items[I+1,J].Value:=Value;

      Value:=TreeTable.Items[I,J].Code;
      TreeTable.Items[I,J].Code:=TreeTable.Items[I+1,J].Code;
      TreeTable.Items[I+1,J].Code:=Value;

      Value:= TreeTable.Items[I,J].SI1;
      TreeTable.Items[I,J].SI1:=TreeTable.Items[I+1,J].SI1;
      TreeTable.Items[I+1,J].SI1:=Value;

      Value:= TreeTable.Items[I,J].SI2;
      TreeTable.Items[I,J].SI2:=TreeTable.Items[I+1,J].SI2;
      TreeTable.Items[I+1,J].SI2:=Value;

      R:=TreeTable.Items[I,J].Right;
      TreeTable.Items[I,J].Right:=TreeTable.Items[I+1,J].Right;
      TreeTable.Items[I+1,J].Right:=R;{}
     end;
  end;
//
end;

Procedure THuffman.CreateTree(CodeTable:TCodeTable;
           Var TreeTable:TTreeTable);
Var
 I,J       : Integer;
 Min1,Min2 : Integer;
 MP1,MP2   : Integer;
 Sum       : Integer;
 CSCH      : Integer; // ColCount SCH
 SMP1      : Integer; // Save MP1
begin
 TreeTable.ColCount:=-1;
 TreeTable.RowCount:=-1;
 TreeTable.Items:=nil;
 If CodeTable.Count<=1 then Exit;

 SetLength(TreeTable.Items,CodeTable.Count);
 TreeTable.ColCount:=CodeTable.Count;

 For I:=0 to TreeTable.ColCount-1 do
 SetLength(TreeTable.Items[I],CodeTable.Count-1);
 TreeTable.RowCount:=CodeTable.Count-1;

 {------------------------------------------------}
 J:=0; Sum:=0;
 CSCH:=TreeTable.ColCount;
 SMP1:=0;
 Init(TreeTable);
 For i:=CSCH-1 downto 0 do
   begin
     //������ ���� ������ ������
     TreeTable.Items[I,J].Value:=CodeTable.Items[i].Count; // ���-�� ���������
     TreeTable.Items[I,J].Code:=CodeTable.Items[i].Code; // ��� ���������
   end;
 SortedRow(J,TreeTable);//��������� ������ ������

 Repeat
  If (J<>0) and
     (MP1<=TreeTable.ColCount-1) and
     (MP1>=0) then
     begin
     TreeTable.Items[MP1,J].Value:=Sum;
     TreeTable.Items[MP1,J].SI1:=SMP1;
     TreeTable.Items[MP1,J].SI2:=MP2;
     end;

  {---------------------------------------------}
  GetMin1Min2(TreeTable,J,Min1,Min2,MP1,MP2);
  If (Mp1=-1) or (MP2=-1) then
   Break;

  Sum:=Min1+Min2;
  {---������������ ��� �������� ����� ��� � ������� ������ = MP1, MP2 --}
  For i:=0 to TreeTable.ColCount-1 do
   begin
   TreeTable.Items[i,j].Right:=False;

   IF J+1<=TreeTable.RowCount-1 then
   IF (I<>MP1) and (I<>MP2) then
    begin
     TreeTable.Items[I,J+1].Value:=TreeTable.Items[I,J].Value;
     TreeTable.Items[I,J+1].SI1:=TreeTable.Items[I,J].SI1;
     TreeTable.Items[I,J+1].SI2:=TreeTable.Items[I,J].SI2;
    end else
    If (I=MP1) or (I=MP2) then
      TreeTable.Items[I,J+1].Value:=0;
   end;
  {---------------------------------------------------------------------}

  {--------------------------------}
  If MP1>Mp2 then
   begin
    TreeTable.Items[Mp2,J].Right:=False;
    TreeTable.Items[Mp1,J].Right:=True;
   end else
   begin
    TreeTable.Items[Mp1,J].Right:=False;
    TreeTable.Items[Mp2,J].Right:=True;
   end;
  {--------------------------------}

  SMP1:=MP1;
  If MP1>MP2 then MP1:=MP2;
  CSCH:=CSCH-1;
  j:=J+1;
 Until CSCH=1;
//
end;

Function THuffman.GetAllusionsToItIndex(TreeTable : TTreeTable;
 Var CheckAItm : TCheckAItm) : Boolean;  // ����� ������ ��� ���� ���������
{-------------------------------------------}
 Function Stop(CheckAItm : TCheckAItm) : Boolean;
  Var
   I : Integer;
  begin
   Result:=True;
   For i:=0 to CheckAItm.ACheckAItm.Count-1 do
    begin
     If not CheckAItm.ACheckAItm.AItm[i].Check then
        begin
         Result:=false;
         Break;
        end;
    end;
  end;
  Procedure AddCheckItm(Var CheckAItm:TCheckAItm;
  Col,Row:Integer;PCol,PRow:Integer;Check:Boolean);
   Var
    Count : Integer;
  begin
   If Not Assigned(CheckAItm.ACheckAItm.AItm) then
    begin
     CheckAItm.ACheckAItm.Count:=0;
     CheckAItm.ACheckAItm.AItm:=nil;
    end;
   CheckAItm.ACheckAItm.Count:=CheckAItm.ACheckAItm.Count+1;
   SetLength(CheckAItm.ACheckAItm.AItm , CheckAItm.ACheckAItm.Count);
   Count:=CheckAItm.ACheckAItm.Count;

   CheckAItm.ACheckAItm.AItm[Count-1].Col:=Col;
   CheckAItm.ACheckAItm.AItm[Count-1].Row:=Row;
   CheckAItm.ACheckAItm.AItm[Count-1].ParentCol:=PCol;
   CheckAItm.ACheckAItm.AItm[Count-1].ParentRow:=PRow;
   CheckAItm.ACheckAItm.AItm[Count-1].Check:=Check;
  end;

  Procedure EditCheckItm(Var CheckAItm:TCheckAItm;Col,Row:Integer;Check:Boolean);
   Var
    I : Integer;
  begin
   If Not Assigned(CheckAItm.ACheckAItm.AItm) then exit;
    For I:=0 To CheckAItm.ACheckAItm.Count-1 do
     Begin
     If (CheckAItm.ACheckAItm.AItm[I].Col=Col) and
        (CheckAItm.ACheckAItm.AItm[I].Row=Row) then
        begin
         CheckAItm.ACheckAItm.AItm[I].Check:=Check;
         Break;
        end;
     end;
  end;

  Function GetCheckItm(CheckAItm:TCheckAItm;Var Col,Row:Integer):Boolean;
   Var
    I : Integer;
  begin
   Result:=false;
   If not Assigned(CheckAItm.ACheckAItm.AItm) then Exit;
    For I:=0 to CheckAItm.ACheckAItm.Count-1 do
     begin
      If not CheckAItm.ACheckAItm.AItm[i].Check then
       begin
        Col:=CheckAItm.ACheckAItm.AItm[i].Col;
        Row:=CheckAItm.ACheckAItm.AItm[i].Row;
        Result:=True;
        Break;
       end;
     end;
  end;

  Procedure SaveStopPoint(Var CheckAItm:TCheckAItm;Col,Row:Integer);
   Var
    Count : Integer;
  begin
   If not Assigned(CheckAItm.AStopItm.AItm) then
     begin
      CheckAItm.AStopItm.AItm:=nil;
      CheckAItm.AStopItm.Count:=0;
     end;
   CheckAItm.AStopItm.Count:=CheckAItm.AStopItm.Count+1;
   Count:=CheckAItm.AStopItm.Count;
   SetLength(CheckAItm.AStopItm.AItm , Count);
   CheckAItm.AStopItm.AItm[Count-1].Col:=Col;
   CheckAItm.AStopItm.AItm[Count-1].Row:=Row;
  end;

  Procedure GetRootItems(TreeTable:TTreeTable; Var CheckAItm:TCheckAItm);
   Var
    I   : Integer;
    Row : Integer;
    Sch : Integer;
  begin
   Row:=TreeTable.RowCount-1;
   Sch:=0;
   For I:=0 to TreeTable.ColCount-1 do
    begin
     If TreeTable.Items[I,Row].Value <> 0 then
      begin
       Sch:=Sch+1;
       AddCheckItm(CheckAItm,I,Row,-1,-1,False);
       If Sch=2 then Break; // ���������� ����
      end;
    end;
  end;
{-------------------------------------------}
Var
 SI1        :Integer; // ������ �� ������� 1
 SI2        :Integer; // ������ �� ������� 2
 A1         :Integer;
 ACol,ARow  :Integer;
 SaveRow    :Integer;
 Row        :Integer;
begin
Result:=false;

CheckAItm.ACheckAItm.AItm:=nil;
CheckAItm.ACheckAItm.Count:=0;

If Not Assigned(TreeTable.Items) then
   begin
    exit;
   end;
   
GetRootItems(TreeTable,CheckAItm);
A1  := 0;
Row := 0;

Repeat

 If GetCheckItm(CheckAItm,ACol,Arow) then
   begin // ����� ������ � ������� �� ������������ ��������
    A1:=ACol;
    Row:=ARow;
   end;

  SI1:=TreeTable.Items[A1,Row].SI1;{}
  If SI1<>-1 then
   begin
    SaveRow:=Row;
    Row:=Row-1;
    If TreeTable.Items[SI1,Row].Value <> 0 then
     begin
      //��������� �� ����������� ����  (SI1 , Row)
      AddCheckItm(CheckAItm,SI1,Row,A1,SaveRow,false);
     end;
    Row:=Row+1;
   end else
   begin
    // ��������� ����� ��������� ������� ������
    SaveStopPoint(CheckAItm,A1,Row);
   end;

  SI2:=TreeTable.Items[A1,Row].SI2;
  If SI2<>-1 then
   Begin
    SaveRow:=Row;
    Row:=Row-1;
    If TreeTable.Items[SI2,Row].Value <> 0 then
      begin
      //��������� �� ����������� ����  (SI1 , Row)
       AddCheckItm(CheckAItm,SI2,Row,A1,SaveRow,false);
      end;
    Row:=Row+1;
   end else
   begin
    // ��������� ����� ��������� ������� ������
    SaveStopPoint(CheckAItm,A1,Row);
   end;

   EditCheckItm(CheckAItm,A1,Row,True);

Until Stop(CheckAItm);
             
end;

Function THuffman.GetCourseToIndex(Index : Integer; TreeTable : TTreeTable;
          CheckAItm : TCheckAItm):String;
begin
 Result := UAuxiliaryH.GetCourseToIndex(Index, TreeTable, CheckAItm);
end;

Constructor THuffman.Create(AOwner:TComponent);
begin
// ��������� ������������� ����������
FLNFLB          := 0;
FSeekFLNFLB     := 3 - 1;
FPackHeaderSize := 0;
FWinHandle      := 0;
FMASKBITS       := $AA;
FExecuteError   := false;
FStop           := false;
// ������������ ��������� ��� ���������� �������
OnReadInBuffer       := PEventReadInBuffer;       // ������ � ����� �� �����
OnBeforeReadInBuffer := PEventBeforeReadInBuffer; // ��� ���������� �������
//
Inherited Create(AOwner);
end;

Destructor THuffman.Destroy;
begin
 FreePackPreficsBuffer(FPPB);    // ����������� ������
 FreeCodeTable(FCodeTable);      // ����������� ������
 FreePreficsCode(FPreficsCode);  // ����������� ������
 
 Inherited Destroy;
end;

procedure Register;
begin
  RegisterComponents('Samples', [THuffman]);
end;

end.
