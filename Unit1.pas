unit Unit1;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.UIConsts,
  System.Classes,
  System.Variants,
  System.Generics.Collections,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Controls.Presentation,
  FMX.StdCtrls, FMX.ScrollBox, FMX.Memo, FMX.Objects, FMX.ListBox, FMX.Layouts,
  FMX.TabControl,
  Lib.HTTPConsts,
  Net.Socket,
  Net.HTTPSocket;

type
  TForm1 = class(TForm)
    TabControl1: TTabControl;
    TabItem2: TTabItem;
    Memo2: TMemo;
    Layout3: TLayout;
    Button1: TButton;
    Circle2: TCircle;
    Button2: TButton;
    Button6: TButton;
    ComboBox2: TComboBox;
    TabItem3: TTabItem;
    Layout4: TLayout;
    Button7: TButton;
    Circle3: TCircle;
    Label1: TLabel;
    Button8: TButton;
    Button9: TButton;
    Memo3: TMemo;
    ComboBox3: TComboBox;
    TabItem1: TTabItem;
    ComboBox1: TComboBox;
    Layout1: TLayout;
    Image1: TImage;
    Memo1: TMemo;
    Splitter1: TSplitter;
    Layout2: TLayout;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Circle1: TCircle;
    TabItem4: TTabItem;
    Layout5: TLayout;
    Button10: TButton;
    Circle4: TCircle;
    Label2: TLabel;
    Button11: TButton;
    Button12: TButton;
    Memo4: TMemo;
    ComboBox4: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    TCPServer: TTCPSocket;
    TCPClients: TObjectList<TTCPSocket>;
    procedure OnTCPClientsListChange(Sender: TObject; const Client: TTCPSocket; Action: TCollectionNotification);
    procedure OnTCPServerListen(Sender: TObject);
    procedure OnTCPServerClose(Sender: TObject);
    procedure OnTCPServerExcept(Sender: TObject);
    procedure OnTCPServerAccept(Sender: TObject);
    procedure OnTCPServerClientReceived(Sender: TObject);
    procedure OnTCPServerClientClose(Sender: TObject);
    procedure OnTCPServerClientExcept(Sender: TObject);
  private
    HTTPClient: THTTPClient;
    FResponseIndex: Integer;
    procedure OnConnect(Sender: TObject);
    procedure OnClose(Sender: TObject);
    procedure OnExcept(Sender: TObject);
    procedure OnResponse(Sender: TObject);
    procedure SetConnect(Active: Boolean);
    procedure ShowBitmap;
    procedure HideBitmap;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure ScrollToBottom(Memo: TMemo);
begin
  Memo.ScrollBy(0,Memo.ContentBounds.Height-Memo.ViewportPosition.Y);
end;

procedure ToMemo(Memo: TMemo; const Message: string);
begin
  if not Application.Terminated then
  begin
    Memo.Lines.Add(Message);
    ScrollToBottom(Memo);
  end;
end;



procedure TForm1.FormCreate(Sender: TObject);
begin

  TCPServer:=TTCPSocket.Create;
  TCPServer.OnConnect:=OnTCPServerListen;
  TCPServer.OnClose:=OnTCPServerClose;
  TCPServer.OnExcept:=OnTCPServerExcept;
  TCPServer.OnAccept:=OnTCPServerAccept;

  TCPClients:=TObjectList<TTCPSocket>.Create;
  TCPClients.OnNotify:=OnTCPClientsListChange;
  OnTCPClientsListChange(nil,nil,cnAdding);

  HTTPClient:=THTTPClient.Create;

  HTTPClient.OnConnect:=OnConnect;
  HTTPClient.OnClose:=OnClose;
  HTTPClient.OnExcept:=OnExcept;
  HTTPClient.OnResponse:=OnResponse;

  ComboBox1.Items.Add('http://185.182.193.15/api/node/?identity=BFC9AA5719DE2F25E5E8A7FE5D21C95B');
  ComboBox1.Items.Add('http://www.ancestryimages.com/stockimages/sm0112-Essex-Moule-l.jpg');
  ComboBox1.Items.Add('http://www.ancestryimages.com/stockimages/sm0004-WorldKitchin1777.jpg');
  ComboBox1.Items.Add('http://www.picshare.ru/images/upload_but.png');
  ComboBox1.Items.Add('http://krasivie-kartinki.ru/images/dragocennosti_25_small.jpg');
  ComboBox1.Items.Add('http://i.artfile.ru/1366x768_1477274_[www.ArtFile.ru].jpg');
  ComboBox1.Items.Add('http://zagony.ru/admin_new/foto/2012-4-23/1335176695/chastnye_fotografii_devushek_100_foto_31.jpg');
  ComboBox1.Items.Add('http://localhost/2.jpg');
  ComboBox1.Items.Add('http://localhost:'+HTTP_PORT.ToString+'/2.jpg');
  ComboBox1.Items.Add('http://localhost:'+HTTP_PORT.ToString+'/9.jpg');
  ComboBox1.Items.Add('http://192.168.0.103:8080/');
  ComboBox1.Items.Add('http://192.168.0.106:80/');
  ComboBox1.Items.Add('http://192.168.0.106:8080/');
  ComboBox1.Items.Add('http://192.168.22.15:80/');
  ComboBox1.Items.Add('http://185.182.193.17:80/');
  ComboBox1.Items.Add('http://history-maps.ru/pictures/max/0/1764.jpg');
  ComboBox1.Items.Add('http://zagony.ru/admin_new/foto/2019-9-23/1569240641/festival_piva_oktoberfest2019_v_mjunkhene_22_foto_14.jpg');
  ComboBox1.Items.Add('');
  ComboBox1.Items.Add('');
  ComboBox1.Items.Add('');
  ComboBox1.Items.Add('');

  ComboBox1.ItemIndex:=2;


end;

procedure TForm1.FormDestroy(Sender: TObject);
begin

  TCPServer.Terminate;
  TCPClients.Free;
  TCPServer.Free;

  HTTPClient.Terminate;
  HTTPClient.Free;

end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  TCPServer.Start(5555);
end;

procedure TForm1.OnTCPServerListen(Sender: TObject);
begin
  Circle3.Fill.Color:=claGreen;
end;

procedure TForm1.OnTCPServerClose(Sender: TObject);
begin
  if not Application.Terminated then
  Circle3.Fill.Color:=claRed;
end;

procedure TForm1.OnTCPServerExcept(Sender: TObject);
begin
  ToMemo(Memo3,TCPServer.E.Message);
end;

procedure TForm1.OnTCPClientsListChange(Sender: TObject; const Client: TTCPSocket; Action: TCollectionNotification);
begin
  if Action=TCollectionNotification.cnRemoved then Client.Terminate;
  if not Application.Terminated then
  Label1.Text:=TCPClients.Count.ToString;
end;

procedure TForm1.OnTCPServerAccept(Sender: TObject);
var Client: TTCPSocket;
begin
  Client:=TTCPSocket.Create(TCPServer.Accept);
  Client.OnReceived:=OnTCPServerClientReceived;
  Client.OnClose:=OnTCPServerClientClose;
  Client.OnExcept:=OnTCPServerClientExcept;
  Client.Connect;
  TCPClients.Add(Client);
  ToMemo(Memo3,'Connected RemoteAddress: '+Client.RemoteAddress);
end;

procedure TForm1.OnTCPServerClientReceived(Sender: TObject);
begin
  ToMemo(Memo3,TTCPSocket(Sender).ReceiveString);
end;

procedure TForm1.OnTCPServerClientClose(Sender: TObject);
begin
  TCPClients.Remove(TTCPSocket(Sender));
  ToMemo(Memo3,'Disconnected');
end;

procedure TForm1.OnTCPServerClientExcept(Sender: TObject);
begin
  ToMemo(Memo3,TTCPSocket(Sender).E.Message);
end;



////////
///
///

procedure TForm1.ShowBitmap;
begin
  Image1.Visible:=True;
  Splitter1.Visible:=True;
  ScrollToBottom(Memo1);
end;

procedure TForm1.HideBitmap;
begin
  Splitter1.Visible:=False;
  Image1.Bitmap.Assign(nil);
  Image1.Visible:=False;
  ScrollToBottom(Memo1);
end;

procedure TForm1.SetConnect(Active: Boolean);
begin
  if not Application.Terminated then
  if Active then
  begin
    Circle1.Fill.Color:=claGreen;
    ToMemo(Memo1,'Connected ['+HTTPClient.Handle.ToString+'] to '+HTTPClient.Address);
  end else begin
    Circle1.Fill.Color:=claRed;
    ToMemo(Memo1,'Disconnected');
  end;
end;


procedure TForm1.OnConnect(Sender: TObject);
begin
  SetConnect(True);
end;

procedure TForm1.OnClose(Sender: TObject);
begin
  SetConnect(False);
end;

procedure TForm1.OnExcept(Sender: TObject);
begin
  if not Application.Terminated then
  ToMemo(Memo1,HTTPClient.E.Message);
end;

procedure TForm1.OnResponse(Sender: TObject);
begin

  Inc(FResponseIndex);

  ToMemo(Memo1,'---'+FResponseIndex.ToString+'---');
  ToMemo(Memo1,HTTPClient.Response.ResultCode.ToString+' '+HTTPClient.Response.ResultText);
  ToMemo(Memo1,HTTPClient.Response.Headers.Text);

  var ContentType:=HTTPClient.Response.Headers.ContentType;

  if ContentType.StartsWith('image') then
  begin

    var Stream:=TBytesStream.Create(HTTPClient.Response.Content);

    try
      Image1.Bitmap.LoadFromStream(Stream);
      ShowBitmap;
    finally
      Stream.Free;
    end;

  end else begin

    HideBitmap;

    if ContentType.StartsWith('text') or ContentType.EndsWith('json') then

      ToMemo(Memo1,TEncoding.ANSI.GetString(HTTPClient.Response.Content));

  end;

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Image1.Bitmap.Assign(nil);
  HTTPClient.Get(ComboBox1.Items[ComboBox1.ItemIndex]);
  //HTTPSocket.Get(ComboBox1.Items[ComboBox1.ItemIndex]);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  HTTPClient.Disconnect;
  SetConnect(False);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  FResponseIndex:=0;
  Memo1.Lines.Clear;
  HideBitmap;
end;

end.
