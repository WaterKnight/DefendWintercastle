unit UnitGenerator;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    NameEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Edit2: TEdit;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label3: TLabel;
    ComboBox3: TComboBox;
    Label4: TLabel;
    Edit3: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    Label7: TLabel;
    Edit6: TEdit;
    Label8: TLabel;
    Edit7: TEdit;
    Label9: TLabel;
    ComboBox4: TComboBox;
    Label10: TLabel;
    Edit8: TEdit;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Edit9: TEdit;
    Edit10: TEdit;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Edit11: TEdit;
    Edit12: TEdit;
    Edit13: TEdit;
    Label18: TLabel;
    Label19: TLabel;
    Edit14: TEdit;
    Label20: TLabel;
    Edit15: TEdit;
    Label21: TLabel;
    Edit16: TEdit;
    Label22: TLabel;
    ComboBox5: TComboBox;
    Label23: TLabel;
    Edit17: TEdit;
    Label24: TLabel;
    Edit18: TEdit;
    Label25: TLabel;
    Edit19: TEdit;
    Label26: TLabel;
    Label27: TLabel;
    Edit20: TEdit;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Edit21: TEdit;
    Edit22: TEdit;
    Label31: TLabel;
    Label32: TLabel;
    Edit23: TEdit;
    Edit24: TEdit;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Edit25: TEdit;
    Edit26: TEdit;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Edit27: TEdit;
    Edit28: TEdit;
    Edit29: TEdit;
    Edit30: TEdit;
    Edit31: TEdit;
    Label42: TLabel;
    Edit32: TEdit;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Edit33: TEdit;
    Edit34: TEdit;
    Label46: TLabel;
    Label47: TLabel;
    Edit35: TEdit;
    Edit36: TEdit;
    Label48: TLabel;
    Label49: TLabel;
    Edit37: TEdit;
    Edit38: TEdit;
    Label50: TLabel;
    Edit39: TEdit;
    Label51: TLabel;
    Edit40: TEdit;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    Edit41: TEdit;
    Edit42: TEdit;
    Edit43: TEdit;
    Label55: TLabel;
    ComboBox6: TComboBox;
    Edit44: TEdit;
    Label56: TLabel;
    Label57: TLabel;
    Edit45: TEdit;
    Label58: TLabel;
    Edit46: TEdit;
    Edit47: TEdit;
    Label59: TLabel;
    Label60: TLabel;
    Edit48: TEdit;
    Label61: TLabel;
    Label62: TLabel;
    Edit49: TEdit;
    Edit50: TEdit;
    Label63: TLabel;
    Edit51: TEdit;
    Label64: TLabel;
    Edit52: TEdit;
    Edit53: TEdit;
    Label65: TLabel;
    Edit54: TEdit;
    Edit55: TEdit;
    Label66: TLabel;
    Label67: TLabel;
    Edit56: TEdit;
    Edit57: TEdit;
    Edit58: TEdit;
    Edit59: TEdit;
    Edit60: TEdit;
    Label68: TLabel;
    Edit61: TEdit;
    Edit62: TEdit;
    Label69: TLabel;
    Edit63: TEdit;
    Label70: TLabel;
    ComboBox7: TComboBox;
    Output: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private-Deklarationen}
  public
    { Public-Deklarationen}
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Output.Lines.Add(NameEdit.Text);
end;

end.