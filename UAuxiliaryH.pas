unit UAuxiliaryH;

interface
Uses Classes, SysUtils, Windows;

type
{--- Буфер для чтения данных из файла -------------}
 TBuffer = record
 Buf     : Array [1..12288*4] of Byte; // 12288 Байт = 10 КБайт
 BufSize : Integer;
 end;
{--------------------------------------------------}

 {--- Описание одного узла дерева ---}
 TRTree = record
  Code  : Byte;      // Код вхождения
  Value : Integer;   // Кол-во вхождений
  Right : Boolean;   // 0 / 1 направление ветки
  SI1   : Integer;   // Ссылка на элемент 1
  SI2   : Integer;   // Ссылка на элемент 2
 end;
 {-----------------------------------}

 TTreeTable = record
  Items    : Array of Array of TRTree; // Дерево Хаффмена (двумерный массив)
  RowCount : Integer;// Кол-во элементов (строк) в двумерном массиве
  ColCount : Integer;// Кол-во элементов (колонок) в двумерном массиве
 end;

 TItmPreficsCode = record
  Prefics  : String;    // Префикс для кода вхождения
  Code     : Byte;      // Код вхождения
  LengPref : INTEGER;
  Value    : Integer;   // Кол -во вхождений
 end;

 TPreficsCode = record
  A     : Array of TItmPreficsCode; // Массив префиксных кодов
  Count : Integer;                  // Кол-во элементов
 end;

// TSecurityKey = Array[1..256] of byte;

{-----------------------------------------------------}
 TRCodeTable = record
  Code  : Byte;     // Значение
  Count : Integer; // Кол-во одинаковых значений для переменной Code
 end;

 TCodeTable = record
  Items : array of TRCodeTable;  // Масив содержащий коды вхождений и кол-ва вхождений кода
  Count : Integer;               // Кол-во элементов в массиве
 end;
{-------------------------------}
 TCheckItm = record
  Col       : Integer; // колонка
  Row       : Integer; // строка
  ParentCol : Integer; // индекс колонки родителя
  ParentRow : Integer; // индекс строки "родителя"
  Check     : Boolean; // узел проверен / не проверен
 end;

 TStopItm = record
  Col : Integer; // индекс колонки на которой произошла остановка проверки
  Row : Integer; // индекс строки
 end;

 TAStopItm = record
  AItm  : Array of TStopItm; // Элементы на которых произошла остановка проверки
  Count : Integer;
 end;

 TACheckAItm = record
  AItm  : Array of TCheckItm;
  Count : Integer;
 end;

 TCheckAItm = record
 ACheckAItm : TACheckAItm;
 AStopItm   : TAStopItm;
 end;
{-------------------------------}
 {TRPPB = record
  B    : Byte;  // Упакованный байт
  LNFB : Byte;  // Длинна не полного байта в разрядах (Length Not Full Byte)
 end;{}

 TPackPreficsBuffer = record
  AB            : Array of BYTE;
  ALNFB         : Array of BYTE;
  Count         : Integer;
  CountFullByte : Integer;
 end;

 THeader = record
  Signature      : WORD;          // специальный признак
  UnPackFileName : String;        // имя распакованного файла
  ValueCode      : Array of Byte; // массив значений вхождения
  Prefics        : Array of Byte; // массив префиксных кодов
  APL            : Array of Byte; // массив длинны префиксных кодов (Array Prefics Length)
  CountV         : Word;          // Count Value   ( in File (0..255) Length Byte)
  CountA1        : Word;          // Count APL     ( in File (0..255) Length Byte)
  CountA2        : Word;          // Count APL     ( in File (0..255) Length Byte)
  CountP         : Word;          // Count Prefics 0..FFFF
  EndH           : Integer;       // для смещения указателя на конец заголовка
  LNFLB          : Byte;          // Length Not Full Last Byte
 end;

 TAuxiliaryA = record // Вспомогательный массив (Auxiliary Array)
  A     : Array of Byte;
  Count : Integer;
 end;

 TAuxiliaryA2 = record // Вспомогательный массив 2 (Auxiliary Array)
  A1     : Array of Byte;
  Count1 : Integer;
  A2     : Array of Byte;
  Count2 : Integer;
 end;
{-------------------------------}
TBits=Set Of (b0,b1,b2,b3,b4,b5,b6,b7,b8);

   Function DeleteFileExt(FileName:String):String; // удалить расширение файла
   Function  ReversStr(Str:String):String; // переворот строки c зада наперед
 {---- Подпрограммы работы с битовыми наборами данных --}
   Procedure SetBits(NBits:TBits;Var Res:Byte);
   Procedure SetBit(NBits:Byte;Var Res:Byte);
   Function  BinToInt(Bin:String):Integer;
   Function  IntToBin(Int:Byte):String; overload;
   Function  IntToBin(Int:Byte; NR:Byte; CountR:Byte):String; overload;

   Procedure DisTwoByte(SourceB:Byte; Var DB1,DB2:Byte); // Разъединить байт на два
                                       // DB1, DB2 = Destination Byte 1, 2
   Procedure ConnectTwoByte(SB1,SB2 : Byte; Var DB1:Byte); // Соединить в один два байта
                         // SB1, SB2 = Source Byte 1, 2
 {--- Подпрограммы работы со вспомагательным массивом ---}
   Procedure FreeAuxiliaryA(Var A:TAuxiliaryA);
   Procedure AddItemToAuxiliaryA(Var A:TAuxiliaryA; B:Byte);
   Procedure EditItemAuxiliaryA(Var A:TAuxiliaryA; Item : Integer; B:Byte);
 {--- Подпрограммы распаковки длинн префиксных кодов -----}
   Procedure PackAPL(Var Header:THeader);
   Procedure UnPackAPL(Var Header:THeader);
 {------------------------------------------------------}
 {--- Процедуры освобождения памяти ----------------------}
   Procedure FreeCodeTable(Var CodeTable:TCodeTable);
   Procedure FreeTreeTable(Var TreeTable:TTreeTable);
   Procedure FreeCheckAItm(Var CheckAItm:TCheckAItm);
   Procedure FreePreficsCode(Var PreficsCode:TPreficsCode);
   Procedure FreePackPreficsBuffer(Var PPB:TPackPreficsBuffer);
   Procedure FreePackHeader(Var Header:THeader);
 {--- Подпрограммы отображения информации и данных -------}
   Procedure ShowPackPreficsBuffer(PPB:TPackPreficsBuffer;Lines:TStrings);
   Procedure ShowTreeTable(TreeTable:TTreeTable;Lines:TStrings);
   Procedure ShowPreficsCode(TreeTable:TTreeTable;
    CheckAItm:TCheckAItm;Lines:TStrings);Overload;// показать префиксные коды
   Procedure ShowPreficsCode(PreficsCode:TPreficsCode;
    Lines:TStrings);Overload;// показать префиксные коды
 {--- Подпрограммы работы с деревом Huffman's ------------}
   Function GetCourseToIndex(Index:Integer;TreeTable:TTreeTable;
             CheckAItm:TCheckAItm):String;
   Function GetMin1Min2(TreeTable:TTreeTable;RowF:Integer;
             Var Min1,Min2,MinPos1,MinPos2:Integer):Boolean;
 {--------------------------------------------------------}
implementation

Procedure DisTwoByte(SourceB:Byte; Var DB1,DB2:Byte);
// Разделить байт на две равные части
Var
 B1 , B2 : Byte;
begin
 Asm
  PUSH AX
  MOV  AL , SourceB
  MOV  B1 , AL
  XOR  AX , AX
  MOV  AL , B1
  SHL  AX , 4
  SHR  AL , 4
  MOV  B1 , AL
  MOV  B2 , AH
  POP  AX
 end;
DB1:=B1;
DB2:=B2;
end;

Procedure ConnectTwoByte(SB1,SB2 : Byte; Var DB1:Byte);
// Соединить два байта в один
Var
 B1 : Byte;
begin
  Asm
   PUSH AX
   XOR AX , AX
   MOV AL  , SB1
   MOV AH  , SB2
   SHL AL  , 4
   SHR AX  , 4
   MOV B1 , AL
   POP AX
  end;
DB1:=B1;
end;

Procedure FreeAuxiliaryA(Var A:TAuxiliaryA);
begin
 If Assigned(A.A) then
  begin
  SetLength(A.A , 0);
  A.A:=nil;
  A.Count:=0;
  end;
end;

Procedure AddItemToAuxiliaryA(Var A:TAuxiliaryA; B:Byte);
begin
 If not Assigned(A.A) then
  begin
   A.A:=nil;
   A.Count:=0;
  end;

  A.Count:=A.Count+1;
  SetLength(A.A , A.Count);
  A.A[A.Count-1]:=B;
end;

Procedure EditItemAuxiliaryA(Var A:TAuxiliaryA; Item : Integer; B:Byte);
begin

If not Assigned(A.A) then
  begin
   A.A:=nil;
   A.Count:=0;
  end;

If Item > A.Count-1 then
 begin
  If A.Count<=0 then A.Count:=1;
  A.Count:=A.Count+(Item-(A.Count-1))+(1024*4); // Буффер создаваемый для скорости
  SetLength(A.A, A.Count);
 end;

 A.A[Item]:=B;
end;

Procedure FreeAuxiliaryA2(Var AuxiliaryA2:TAuxiliaryA2);
begin
 If Assigned(AuxiliaryA2.A1) then
  begin
   SetLength(AuxiliaryA2.A1 , 0);
   AuxiliaryA2.Count1:=0;
   AuxiliaryA2.A1:=nil;
  end;

 If Assigned(AuxiliaryA2.A2) then
  begin
   SetLength(AuxiliaryA2.A2 , 0);
   AuxiliaryA2.Count2:=0;
   AuxiliaryA2.A2:=nil;
  end;
end;

Procedure UnPackAPL(Var Header:THeader);
 Var
   A        : Array of Byte;
   CountA   : Integer;
   A1 , A2  : Array of Byte;
   CountA1  : Integer;
   CountA2  : Integer;

   I , J   : Integer;
   B1 , B2 : Byte;
   ItmSch  : Integer;
   SCH     : Integer;
 begin
  {---------------------}
  A1:=nil;
  CountA1:=Header.CountA1;
  SetLength(A1 , CountA1);
  {---------------------}
  {---------------------}
  A2:=nil;
  CountA2:=Header.CountA2;
  SetLength(A2 , CountA2);
  {---------------------}

  For i:=0 to Header.CountA1-1 do A1[i]:=Header.APL[i];
  For i:=0 to Header.CountA2-1 do A2[I]:=Header.APL[I+Header.CountA1];

  ItmSch:=0;
  For I:=0 to CountA2-1 do ItmSch:=ItmSch+A2[i];

   {-------------------}
   A:=nil;
   CountA:=ItmSch;
   SetLength(A,CountA);
   {-------------------}
   SCH:=0; ItmSch:=0;
   {-------------------------------------------------}
   For i:=0 to CountA1-1 do
    begin
     B1:=A1[I];
     DisTwoByte(B1, B1,B2); // разъединить байт B1
                            // на два байта b1, b2
     For J:=0 to A2[SCH]-1 do
      begin
       ItmSch:=ItmSch+1;
       If ItmSch-1 <= CountA-1 then
        A[ItmSch-1]:=B1;{}
      end;
     SCH:=SCH+1;

     For J:=0 to A2[SCH]-1 do
      begin
       ItmSch:=ItmSch+1;
       If (ItmSch-1 <= CountA-1) and (b2 <> 0) then
        A[ItmSch-1] := B2 else
        A[ItmSch-1] := 16;
      end;
     SCH:=SCH+1;
    end;
   {-------------------------------------------------}
   CountA:=ItmSch;
   SetLength(Header.APL , CountA);
   Header.CountA1:=CountA;
   Header.CountA2:=0;

  For I:=0 to CountA-1 do Header.APL[I]:=A[i];

  If Assigned(A) then
   begin
    SetLength(A , 0);
    A:=nil;
   end;

  If Assigned(A1) then
    begin
     SetLength(A1 , 0);
     A1:=nil;
    end;

   If Assigned(A2) then
    begin
     SetLength(A2 , 0);
     A2:=nil;
    end;
     
end;

Procedure PackAPL(Var Header:THeader);
  Var
   A       : TAuxiliaryA;
   A2      : TAuxiliaryA2;

   I , J   : Integer;
   B1 , B2 : Byte;
   Sch     : Integer;
   ItmSch  : Integer;
   CountA2 : Integer;
begin
  {-----------------------------}
  FreeAuxiliaryA2(A2);
  A2.Count1:=Header.CountV;
  SetLength(A2.A1 , A2.Count1);
  A2.Count2:=Header.CountV;
  SetLength(A2.A2 , A2.Count2);
  {-----------------------------}
  CountA2:=0;
  For J:=0 to Header.CountV-1 do
   begin
    B1:=Header.APL[J]; Sch:=0;
    IF B1 <> 0 then
     begin
      For I:=J+1 to Header.CountV-1 do
       begin
        IF I<>J then
        IF (B1 = Header.APL[I]) and (Header.APL[I]<>0) Then
         Begin
          Header.APL[I]:=0;
          Sch:=Sch+1;
         end;
       end;

      Header.APL[J]:=0;
      SCH:=SCH+1;
      A2.A1[CountA2]:=B1;  // Значение
      A2.A2[CountA2]:=SCH; // Кол - во
      CountA2:=CountA2+1;
     end;
   end;
  {------------------------------------}
  A2.Count1:=CountA2;
  FreeAuxiliaryA(A);
  SetLength(A.A , A2.Count1);
  A.Count:=A2.Count1;
  {-------------------------------}
  SCH:=0; B2:=0; B1:=0; ItmSch:=0;
  For I:=0 to A.Count-1 do
   begin
    Sch:=Sch+1;
     Case Sch of
      1: B1:=A2.A1[I];
      2: B2:=A2.A1[I];
     end;
     If Sch=2 then
      begin
       ConnectTwoByte(B1,B2,B1); // Соединить два байта
                                 // рез. в  B1
       A.A[ItmSch]:=b1;
       ItmSch:=ItmSch+1;{}
       Sch:=0;
      end;
   end;
  If Sch<>0 then
   begin
    A.A[ItmSch]:=b1;
    ItmSch:=ItmSch+1;
   end;
  {-------------------------------}
  Header.CountA1:=ItmSch;

  For I:=0 to A.Count-1 do
   begin
    B1:=A2.A2[I];
    IF ItmSch > A.Count-1 then AddItemToAuxiliaryA(A,0);
    A.A[ItmSch]:=b1;
    ItmSch:=ItmSch+1;{}
   end;

  SetLength(Header.APL , ItmSch);
  Header.CountA2:=ItmSch - Header.CountA1;


  For i:=0 to ItmSch-1 do Header.APL[i]:=A.A[I];

  FreeAuxiliaryA(A);
end;


Procedure SetBits(NBits:TBits;Var Res:Byte);
Var
 A : Byte;
begin
 A:=0;
 If b0 in NBits then a:=a+1;
 If b1 in NBits then a:=a+2;
 If b2 in NBits then a:=a+4;
 If b3 in NBits then a:=a+8;
 If b4 in NBits then a:=a+16;
 If b5 in NBits then a:=a+32;
 If b6 in NBits then a:=a+64;
 If b7 in NBits then a:=a+128;
 Res:=a;
end;

Procedure SetBit(NBits:Byte;Var Res:Byte);
Var
 A : Byte;
begin
 A:=0;
 Case NBits of
 0: a:=a+1;
 1: a:=a+2;
 2: a:=a+4;
 3: a:=a+8;
 4: a:=a+16;
 5: a:=a+32;
 6: a:=a+64;
 7: a:=a+128;
 end;
 Res:=A;
end;

Function BinToInt(Bin:String):Integer;
Var
 i   : Integer;
 A   : Integer;
 Res : Integer;
begin
A:=1; Res:=0;
 For i:=Length(Bin) downto 1 do
  begin
   if Bin[i]='1' then Res:=Res+a;
    A:=A*2;
  end;
Result:=res;
end;{}

Function ReversStr(Str:String):String;
 Var
  I   : Integer;
  Res : String;
begin
 Result:=Str; Res:='';
 For i:=Length(Str) DownTo 1 do Res:=Res+Str[i];
 Result:=Res;
end;

Function IntToBin(Int:Byte):String; overload;
Var
 i   : Byte;
 A   : Byte;
 Res : String;
 B   : Boolean;
begin
Res:=''; A:=1;
  For i:=1 to 8 do
   begin
    asm
     PUSH AX     // Сохранить Ax
     PUSH CX     // Сохранить Cx

     MOV  AL , Int
     MOV  CL , A   // CL содержит бит установленный в 1 для проверки
     TEST AL , CL  // путем логического умнажения разрядов
     JNZ  @False
     MOV  B , -1 // B:=True;  // бит не совпал
     JMP  @Exit
     @False:
     MOV  B , 0  // B:=False; // бит совпал
     @Exit:
     MOV AH , 1  // A:=A*2; (1..I); Циклическое умножение A на 2
     MOV CL , I  // путем сдвига A влево на I кол-во разрядов.
     SHL AH , CL // цель установить в единицу I бит
     MOV A  , AH // и оставить нулем все остальные.

     POP CX      // Востановить Cx
     POP AX      // Востановить Ax
    end;
    If B then Res:='0'+Res else Res:='1'+Res;
   end;

Result:=Res;
end;

Function IntToBin(Int:Byte; NR:Byte; CountR:Byte):String; overload;
Var
 i   : Byte;
 A   : Byte;
 Res : String;
 B   : Boolean;
begin
 Res:=''; Result:=Res;
 If CountR > 8 Then Exit;
 IF NR     > 7 then Exit;

 Asm
  PUSHAD

  MOV AL , 128
  MOV CL , NR
  SHR AL , CL
  MOV A , AL

  POPAD
 end;

  For i:=0  to CountR-1 do
   begin
    asm
     PUSH AX     // Сохранить Ax
     PUSH CX     // Сохранить Cx

     MOV  AL , Int
     MOV  CL , A   // CL содержит бит установленный в 1 для проверки
     TEST AL , CL  // путем логического умнажения разрядов
     JNZ  @False
     MOV  B , -1 // B:=True;  // бит не совпал
     JMP  @Exit
     @False:
     MOV  B , 0  // B:=False; // бит совпал
     @Exit:

     MOV AH , A
     SHR AH , 1  // деление на два
     MOV A  , AH

     POP CX      // Востановить Cx
     POP AX      // Востановить Ax
    end;
    If B then Res:=Res+'0' else Res:=Res+'1';
   end;

Result:=Res;
end;

{--- Процедуры освобождения памяти ----------------------}
Procedure FreeCodeTable(Var CodeTable:TCodeTable);
begin
 If Assigned(CodeTable.Items) then
  begin
  SetLength(CodeTable.Items,0);
  CodeTable.Count:=0;
  CodeTable.Items:=nil;
  end;
end;

Procedure FreeTreeTable(Var TreeTable:TTreeTable);
begin
//
 If Assigned(TreeTable.Items) then
  begin
  SetLength(TreeTable.Items,0);
  TreeTable.ColCount:=0;
  TreeTable.RowCount:=0;
  TreeTable.Items:=nil
  end;
end;

Procedure FreeCheckAItm(Var CheckAItm:TCheckAItm);
begin
//
 If Assigned(CheckAItm.ACheckAItm.AItm) then
  begin
   SetLength(CheckAItm.ACheckAItm.AItm,0);
   CheckAItm.ACheckAItm.Count:=0;
   CheckAItm.ACheckAItm.AItm:=nil;
  end;
  If Assigned(CheckAItm.AStopItm.AItm) then
   begin
    SetLength(CheckAItm.AStopItm.AItm,0);
    CheckAItm.AStopItm.Count:=0;
    CheckAItm.AStopItm.AItm:=nil;
   end;
end;

Procedure FreePreficsCode(Var PreficsCode:TPreficsCode);
begin
 If Assigned(PreficsCode.A) then
  begin
   SetLength(PreficsCode.A,0);
   PreficsCode.A:=nil;
   PreficsCode.Count:=0;
  end;
end;

Procedure FreePackPreficsBuffer(Var PPB:TPackPreficsBuffer);
begin
 // FLNFLB:=0; // длина в разрядах последнего упакованного байта
 If Assigned(PPB.AB) And
    Assigned(PPB.ALNFB) then
  begin
   SetLength(PPB.AB , 0);
   SetLength(PPB.ALNFB , 0);
   PPB.AB:=nil;
   PPB.ALNFB:=nil;
   PPB.CountFullByte:=0;
   PPB.Count:=0;
  end;
end;

Procedure FreePackHeader(Var Header:THeader);
begin
 If Assigned(Header.ValueCode) then
  begin
   //
   SetLength(Header.ValueCode , 0);
   Header.CountV:=0;
   Header.ValueCode:=nil;
  end;
 If Assigned(Header.Prefics) then
  begin
   //
   SetLength(Header.Prefics , 0);
   Header.CountP:=0;
   Header.Prefics:=nil;
  end;
end;
{---------------------------------------------------------------}
Procedure ShowPackPreficsBuffer(PPB:TPackPreficsBuffer;Lines:TStrings);
 Var
  I : Integer;
begin
Lines.Add('----------------------------');
 For I:=0 to PPB.Count-1 do
  begin
   Lines.Add('PPB = '+IntToStr(PPB.AB[i]));
  end;
Lines.Add('----------------------------');
end;

Procedure ShowTreeTable(TreeTable:TTreeTable;Lines:TStrings);
Var
 I,J  : Integer;
 S    : String;
 R    : String;
 SI1  : String;
 SI2  : String;
begin
If Not Assigned(TreeTable.Items) then Exit;
S:='';
 For J:=0 To TreeTable.RowCount-1 do
  begin
  S:='';R:=''; SI1:=''; SI2:='';
   For I:=0 to TreeTable.ColCount-1 do
    begin
    S:=S+IntToStr(TreeTable.Items[i,j].Value)+' ';
    R:=R+BoolToStr(TreeTable.Items[i,j].Right)+' ';
    SI1:=SI1+IntToStr(TreeTable.Items[i,j].SI1)+' ';
    SI2:=SI2+IntToStr(TreeTable.Items[i,j].SI2)+' ';
    end;
  Lines.Add(S+' | ' );{}
  end;
end;

Function GetCourseToIndex(Index:Integer;TreeTable:TTreeTable;
          CheckAItm:TCheckAItm):String;
  {------------------------------------------------}
  Function GetIndexToAItm(Col,Row:Integer):Integer;
  Var
   FCol,FRow:Integer;
   I:Integer;
  begin
   Result:=0;
   For I:=0 to CheckAItm.ACheckAItm.Count-1 do
    begin
    FCol:=CheckAItm.ACheckAItm.AItm[i].Col;
    FRow:=CheckAItm.ACheckAItm.AItm[i].Row;
    If (FCOL=Col) and (FRow=Row) then
       begin
       Result:=I;
       Break;
       end;
    end;
  end;
  {------------------------------------------------}
  Function GetFirstRow(Col:Integer):Integer;
  Var
  I:Integer;
  begin
   Result:=0;
   For i:=0 To CheckAItm.AStopItm.Count-1 do
    begin
     If CheckAItm.AStopItm.AItm[I].Col=Col then
      begin
      Result:=CheckAItm.AStopItm.AItm[I].Row;
      Break;
      end;
    end;
  end;
  Var
   i:Integer;
   SI:Integer;
   FCol,FRow:Integer; //FirstCol , FirstRow
   R:Boolean;
   S:String;
   Value,SValue:Integer;
  begin
   result:=''; S:='';

   FCol:=Index; FRow:=GetFirstRow(FCol); SValue:=-1;


   For i:=0 to CheckAItm.ACheckAItm.Count-1 do
    begin
     SI:=GetIndexToAItm(FCol,FRow);

     R:=TreeTable.Items[FCol,FRow].Right;
     Value:=TreeTable.Items[FCol,FRow].Value;

     If Value=SValue then
      begin
      Delete(S,Length(s),1);
      S:=S+IntToStr(StrToInt(BooltoStr(R))*-1);
      end else
      S:=S+IntToStr(StrToInt(BooltoStr(R))*-1);


     SValue:=TreeTable.Items[FCol,FRow].Value;
     FCol:=CheckAItm.ACheckAItm.AItm[Si].ParentCol;
     FRow:=CheckAItm.ACheckAItm.AItm[Si].ParentRow;
     If (FCol=-1) or (FRow=-1) then Break;
    end;

 Result:=ReversStr(S);
end;

Procedure ShowPreficsCode(TreeTable:TTreeTable;
 CheckAItm:TCheckAItm;Lines:TStrings);
Var
 I : Integer;
 S : String;
Begin
If Not Assigned(TreeTable.Items) then Exit;
If Not Assigned(CheckAItm.AStopItm.AItm) then Exit;
If Not Assigned(CheckAItm.ACheckAItm.AItm) then Exit;

 Lines.Add('-------------------------------------');{}
 For i:=0 to TreeTable.ColCount-1 do
  begin
  S:='№ ' + IntToStr(i)+' | '+GetCourseToIndex(I,TreeTable,CheckAItm);
  S:=S    + ' Code = '+IntToStr(TreeTable.Items[I,0].Code);
  If TreeTable.Items[I,0].Code <> 0 then
   S:=S    + ' CHR = '+Chr(39)+Chr(TreeTable.Items[I,0].Code)+Chr(39)
    else
   S:=S    + ' CHR = '+Chr(39)+'NIL (Not Char)'+Chr(39);
  S:=S    + ' Value = '+IntToStr(TreeTable.Items[I,0].Value);
  Lines.Add(S);
  end;
 Lines.Add('-------------------------------------');{}
end;

Procedure ShowPreficsCode(PreficsCode:TPreficsCode;
           Lines:TStrings);
Var
 I : Integer;
 S : String;
begin
 If Not Assigned(PreficsCode.A) then Exit;
 Lines.Add('-------------------------------------');{}
 For i:=0 to PreficsCode.Count-1 do
  begin
   S:='№ '+ IntToStr(i)+' | '+PreficsCode.A[i].Prefics;
   S:=S   + ' Code = '+IntToStr(PreficsCode.A[i].Code);
   If PreficsCode.A[i].Code <> 0 then
   S:=S   + ' CHR = '+Chr(39)+Chr(PreficsCode.A[i].Code)+Chr(39)
    else S:=S   + ' CHR = '+Chr(39)+'NIL (Not Char)'+Chr(39);
   S:=S   + ' Value = '+IntToStr(PreficsCode.A[i].Value);
   Lines.Add(S);
  end;
 Lines.Add('-------------------------------------');{}
end;
{-------------------------------------------------------------------}
Function GetMin1Min2(TreeTable:TTreeTable;RowF:Integer;
          Var Min1,Min2,MinPos1,MinPos2:Integer):Boolean;
Const
 MaxInteger=$7FFFFFFF;
Var
 I,J     : Integer;
 MP1,MP2 : Integer;
Begin
Result:=False;
J:=RowF;
 Min1:=MaxInteger;
 Min2:=MaxInteger;
 MinPos1:=0;
 MinPos2:=0;
 {--Ищем два минимальных элемента--}
 MP1:=-1; // Позиция первого минимального элемента
 For i:=0 to TreeTable.ColCount-1 do
  begin
  If TreeTable.Items[I,J].Value <> 0 then
  If Min1>TreeTable.Items[I,J].Value then
     begin
     Min1:=TreeTable.Items[I,J].Value;
     MP1:=I;
     end;
  end;

  MP2:=-1; // Позиция второго минимального элемента
  For i:=0 to TreeTable.ColCount-1 do
   begin
   If I<>MP1 then
   If (Min2>=TreeTable.Items[I,J].Value) and
      (TreeTable.Items[I,J].Value <> 0 )
   then
      Begin
      Min2:=TreeTable.Items[I,J].Value;{}
      MP2:=I;
      end;
   end;
 {---------------------------------}
MinPos1:=MP1;
MinPos2:=MP2;
If (MP1<>-1) and (MP2<>-1) then
 Result:=True;
end;
{-------------------------------------------------------------------}

Function DeleteFileExt(FileName:String):String; // удалить расширение файла
  Var
   S    : String;
   Leng : Integer;
 begin
   S:=FileName;
   Leng:=Length(S);
   If Leng-3 > 0 then
    If S[Leng-3]='.' then
    Delete(S, Leng-3, 4);
   Result:= S;
 end;{}

end.
