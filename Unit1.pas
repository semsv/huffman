unit Unit1;


interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Huffman, UAuxiliaryH, ExtCtrls, ComCtrls, Menus;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Pack: TButton;
    OpenDialog1: TOpenDialog;
    Label1: TLabel;
    Label2: TLabel;
    UnPack: TButton;
    Memo2: TMemo;
    Panel1: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Gauge1: TProgressBar;
    Gauge2: TProgressBar;
    Gauge3: TProgressBar;
    Label14: TLabel;
    Label15: TLabel;
    StopBtn: TButton;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    PassEdit: TEdit;
    Label16: TLabel;
    Huffman1: THuffman;
    procedure PackClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure UnPackClick(Sender: TObject);
    procedure Huffman1AfterLoadPrefics(PreficsCode: TPreficsCode);
    procedure Huffman1AfterCreatePrefics(PreficsCode: TPreficsCode);
    procedure Huffman1AfterSaveHeader;
    procedure Huffman1BeforePackBlock(ReadByte, PackByte: Integer);
    procedure Huffman1InitCodeTable(ProgressByte: Integer);
    procedure Huffman1OpenSourceFile;
    procedure Huffman1AfterLoadHeader;
    procedure Huffman1AfterUnPack;
    procedure Huffman1AfterPack;
    procedure Huffman1UnPackBlock(ProcessByte, UnPackByte: Integer);
    procedure StopBtnClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation
{$R *.dfm}
 Var
  FT : Cardinal;
  LT : Cardinal;

procedure TForm1.PackClick(Sender: TObject);
Var
 FileName    : String;
 maket_      : string;
 //SecurityKey : TSecurityKey;
 I           : Integer;
begin
 try
   Gauge1.Position := 0;
   Gauge2.Position := 0;
   Gauge3.Position := 0;
   UnPack.Enabled  := false;
   Pack.Enabled    := false;
   StopBtn.Enabled := true;
   Application.ProcessMessages;

   OpenDialog1.Filter:='*.*|*.*|';
   If not OpenDialog1.Execute then exit;
   FileName := OpenDialog1.FileName;
   maket_   := copy(StatusBar1.Panels.Items[0].Text, 1, POS(':', StatusBar1.Panels.Items[0].Text));
   StatusBar1.Panels.Items[0].Text := maket_ + ' ' + ExtractFileName(FileName);
   maket_   := copy(StatusBar1.Panels.Items[1].Text, 1, POS(':', StatusBar1.Panels.Items[1].Text));
   StatusBar1.Panels.Items[1].Text := maket_ + ' ' + ExtractFileName(DeleteFileExt(FileName) + '.srj');

   FT := GetTickCount;
   {--- Считываем из окна ввода (Edit) ключ для распаковки или запаковки данных --}
//   Huffman1.SecurityKeyLen := Length(PassEdit.Text);
//   For I := 1 to Huffman1.SecurityKeyLen do
//   SecurityKey[I]          := ORD(PassEdit.Text[I]);
//   Huffman1.SecurityKey    := SecurityKey;
   {}
   Huffman1.PackFile(FileName); // Архивация файла
 finally
   Gauge1.Position := 0;
   Gauge2.Position := 0;
   Gauge3.Position := 0;
   UnPack.Enabled  := true;
   Pack.Enabled    := true;
   StopBtn.Enabled := false;
 end;
end;

procedure TForm1.FormCreate(Sender: TObject);
 var
  InitialDir:String;
begin
 InitialDir:=ExtractFilePath(ParamStr(0));
 OpenDialog1.InitialDir:=InitialDir;
 Huffman1.WinHandle    := form1.Handle;
end;

procedure TForm1.UnPackClick(Sender: TObject);
 Var
  FileName    : String;
  maket_      : String;
  SecurityKey : TSecurityKey;
  I           : Integer;
begin
 try
   Gauge1.Position := 0;
   Gauge2.Position := 0;
   Gauge3.Position := 0;
   UnPack.Enabled  := false;
   Pack.Enabled    := false;
   StopBtn.Enabled := true;

   OpenDialog1.Filter:='*.srj|*.srj|';
   If Not OpenDialog1.Execute then Exit;
   FileName:=OpenDialog1.FileName;
   maket_   := copy(StatusBar1.Panels.Items[0].Text, 1, POS(':', StatusBar1.Panels.Items[0].Text));
   StatusBar1.Panels.Items[0].Text := maket_ + ' ' + ExtractFileName(FileName);
   maket_   := copy(StatusBar1.Panels.Items[1].Text, 1, POS(':', StatusBar1.Panels.Items[1].Text));
   StatusBar1.Panels.Items[1].Text := maket_ + ' ' + ExtractFileName(DeleteFileExt(FileName));

   FT:=GetTickCount;
   {--- Считываем из окна ввода (Edit) ключ для распаковки или запаковки данных --}
   Huffman1.SecurityKeyLen := Length(PassEdit.Text);
   For I := 1 to Huffman1.SecurityKeyLen do
   SecurityKey[I]          := ORD(PassEdit.Text[I]);
   Huffman1.SecurityKey    := SecurityKey;
   {}
   Huffman1.UnPackFile(FileName); // Дезархивация файла
 finally
   Gauge1.Position := 0;
   Gauge2.Position := 0;
   Gauge3.Position := 0;
   UnPack.Enabled  := true;
   Pack.Enabled    := true;
   StopBtn.Enabled := false;
 end;
end;

procedure TForm1.Huffman1AfterLoadPrefics(PreficsCode: TPreficsCode);
begin
 ShowPreficsCode(PreficsCode , Memo2.Lines);
end;

procedure TForm1.Huffman1AfterCreatePrefics(PreficsCode: TPreficsCode);
begin
 ShowPreficsCode(PreficsCode , Memo1.Lines);
 Application.ProcessMessages;
end;

procedure TForm1.Huffman1AfterSaveHeader;
begin
 Gauge2.Position := Huffman1.PackHeaderSize;
 Application.ProcessMessages;
end;

procedure TForm1.Huffman1BeforePackBlock(ReadByte, PackByte: Integer);
begin
 Gauge1.Position:=Gauge1.Position+ReadByte; // Накапливаем кол-во прочитанных байт
 Gauge2.Position:=Gauge2.Position+PackByte; // Накапливаем кол-во упакованных байт

 Label5.Caption:=IntToStr(Gauge1.Position);
 Label6.Caption:=IntToStr(Gauge2.Position);

 LT              := GetTickCount;
 Label12.Caption := IntToStr((LT-FT) div 1000 div 60 div 60) + ':' +
                    IntToStr((LT-FT) div 1000 div 60 mod 60) + ':' +
                    IntToStr((LT-FT) div 1000 mod 60) + '';

 Application.ProcessMessages;
end;

procedure TForm1.Huffman1InitCodeTable(ProgressByte: Integer);
begin
 Gauge3.Position := Gauge3.Position + ProgressByte;
 Application.ProcessMessages;
end;

procedure TForm1.Huffman1OpenSourceFile;
begin
 Gauge1.Max := Huffman1.SourceFileSize;
 Gauge2.Max := Huffman1.SourceFileSize;
 Gauge3.Max := Huffman1.SourceFileSize;
 Application.ProcessMessages;
end;

procedure TForm1.Huffman1AfterLoadHeader;
begin
 //
 Gauge1.Position := Huffman1.PackHeaderSize;
 Application.ProcessMessages;
end;

procedure TForm1.Huffman1AfterUnPack;
begin
 LT              := GetTickCount;
 Label11.Caption := IntToStr((LT-FT) div 1000 div 60 div 60) + ':' +
                    IntToStr((LT-FT) div 1000 div 60 mod 60) + ':' +
                    IntToStr((LT-FT) div 1000 mod 60) + '';
 Application.ProcessMessages;
end;

procedure TForm1.Huffman1AfterPack;
begin
 LT               := GetTickCount;
 Label12.Caption  := IntToStr((LT-FT) div 1000 div 60 div 60) + ':' +
                     IntToStr((LT-FT) div 1000 div 60 mod 60) + ':' +
                     IntToStr((LT-FT) div 1000 mod 60) + '';
 Application.ProcessMessages;
end;

procedure TForm1.Huffman1UnPackBlock(ProcessByte, UnPackByte: Integer);
begin
 Gauge1.Position := Gauge1.Position + ProcessByte; // Накапливаем кол-во прочитанных байт
 if Gauge2.Position + UnPackByte > Gauge2.Max then
   Gauge2.Max    := Gauge2.Position + UnPackByte + 2;
 Gauge2.Position := Gauge2.Position + UnPackByte;  // Накапливаем кол-во разпакованных байт

 Label6.Caption  := IntToStr(Gauge1.Position);
 Label5.Caption  := IntToStr(Gauge2.Position);
 
 LT              := GetTickCount;
 Label11.Caption := IntToStr((LT-FT) div 1000 div 60 div 60) + ':' +
                    IntToStr((LT-FT) div 1000 div 60 mod 60) + ':' +
                    IntToStr((LT-FT) div 1000 mod 60) + '';
 Application.ProcessMessages;
end;

procedure TForm1.StopBtnClick(Sender: TObject);
begin
 Huffman1.stop;
end;

procedure TForm1.N2Click(Sender: TObject);
begin
 Close;
end;

procedure TForm1.N4Click(Sender: TObject);
begin
 UnPack.Click;
end;

procedure TForm1.N5Click(Sender: TObject);
begin
 Pack.Click;
end;

end.
