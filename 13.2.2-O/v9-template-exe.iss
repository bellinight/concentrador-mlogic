; Script by the Inno Setup Script.
; Concentrador | Mercadologic!

#define MyAppName "Concentrador"
#define MyAppBase "Criar Base de Dados (Cuidado)"
#define MyApps "Instalar Programas"
#define MyUinAppName "Remover"
#define MySubAppName "Utilitario"
#define MyAppVersion "13.2.2"
#define MyAppPublisher "Processa Sistemas, inc"
#define MyAppURL "https:\\processasistemas.com.br"
#define MySubAppExeName "utilitario.bat"
#define MyAppExit "unins000.exe"
#define MyAppsExec "pacotes.bat"
#define MyDBPDV "database.bat"
#define MyAppsID "{{BD03D57F-F40B-4B43-8342-8A7DC357BECD}"
#define MyAppExeName "concentrador.bat"
#define MyAppAssocName MyAppName + ""
#define MyAppAssocExt ".exe"
#define MyAppAssocKey StringChange(MyAppAssocName, " ", "") + MyAppAssocExt

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={#MyAppsID}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName=C:\Mercadologic
ChangesAssociations=yes
;LicenseFile=..\Documents\instalacoes-ex\licença.txt
;InfoBeforeFile=..\Documents\instalacoes-ex\Instruções-Iniciais.txt
;InfoAfterFile=..\Documents\instalacoes-ex\Instruções-Finais.txt
;Uncomment the following line to run in non administrative install mode (install for current user only.)
PrivilegesRequired=admin
OutputDir=C:\Users\leonardo.belini\Documents\Projetos\Executaveis
OutputBaseFilename=Concentrador_ML_{#MyAppVersion}_online
SetupIconFile=userdocs:Projetos\concentrador-mlogic\13.2.2-O\rec\icone.ico
Compression=lzma2/ultra
SolidCompression=yes
VersionInfoCopyright=Copyright (C) 2021 Processa Sistemas, Copyright (C) 2000-2021 Leonardo Bellini Oliveira
UninstallDisplayIcon={uninstallexe}
ArchitecturesInstallIn64BitMode=x64
CompressionThreads=2
WizardStyle=modern
WizardImageFile=userdocs:Projetos\concentrador-mlogic\13.2.2-O\rec\fundo-exe-concentrador.bmp
UninstallDisplayName=Concentrador Mlogic {#MyAppVersion}
WizardSmallImageFile=userdocs:Projetos\concentrador-mlogic\13.2.2-O\rec\icone-instalador.bmp
RestartIfNeededByRun=False
;EnableDirDoesntExistWarning=True
DefaultGroupName=Mercadologic {#MyAppVersion}
InternalCompressLevel=ultra
UninstallDisplaySize=2

;Seleciona o Idioma do Instalador

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

;Tarefa de Criação de atalhos
[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; 

;Pastas vazias criadas com permissões de modificação
[Dirs]
Name: "{app}\Mercadologic"; Permissions: users-modify
Name: "{app}\Atualizacao\{#MyAppVersion}\"; Permissions: users-modify
Name: "{app}\Atualizacao\{#MyAppVersion}\Programas\"; Permissions: users-modify
Name: "{app}\XMLs"; Permissions: users-modify
Name: "{app}\Importacao"; Permissions: users-modify
Name: "{app}\temp"; Flags: deleteafterinstall
Name: "{app}\backup-update"; Permissions: users-modify



;Fontes de arquivos

[Files]
;Source: "..\concentrador-mlogic\13.2.2\Concentrador\{#MyAppExeName}"; DestDir: "c:\Mercadologic\Concentrador\"; Flags: ignoreversion 64bit
Source: "C:\Users\leonardo.belini\Documents\Projetos\concentrador-mlogic\13.2.2-O\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs; Components: Concentrador

;Esta fonte e para arquivos de Download
Source: "{tmp}\install-cli.appxbundle"; DestDir: "{app}\temp\"; Flags: external; Components: Aplicativos
Source: "{tmp}\postgresql-12.exe"; DestDir: "{app}\temp\"; Flags: external; Components: PostgreSql
Source: "{tmp}\postgresql-12.exe"; DestDir: "{app}\Atualizacao\{#MyAppVersion}\Programas\"; Flags: external
Source: "{tmp}\concentrador.zip"; DestDir: "{app}\temp"; Flags: external; Components: Concentrador; AfterInstall: ExtractMe('{app}\temp\concentrador.zip', '{app}')
Source: "{tmp}\utilitario-2-4-0.zip"; DestDir: "{app}\temp"; Flags: external; Components: Concentrador; AfterInstall: ExtractMe('{app}\temp\utilitario-2-4-0.zip', '{app}')
Source: "{tmp}\databridge-1-6.msi"; DestDir: "{app}\Atualizacao\{#MyAppVersion}\Programas\"; Flags: external; Components: Databridge
Source: "{tmp}\spack-conc-1322.exe"; DestDir: "{app}\Atualizacao\{#MyAppVersion}\Programas\"; Flags: external; Components: ScriptPackConc
Source: "{tmp}\spack-pdv-1322.exe"; DestDir: "{app}\Atualizacao\{#MyAppVersion}\Programas\"; Flags: external; Components: ScriptPackPDV
Source: "{tmp}\spack-scantech-1322.exe"; DestDir: "{app}\Atualizacao\{#MyAppVersion}\Programas\"; Flags: external; Components: ScriptPackScantech
Source: "{tmp}\backup-pdv-1011.msi"; DestDir: "{app}\Atualizacao\{#MyAppVersion}\Programas\"; Flags: external; Components: BackupPDV
Source: "{tmp}\concentrador.zip"; DestDir: "{app}\Atualizacao\{#MyAppVersion}\Programas\"; Flags: external; AfterInstall: ExtractMe('{app}\temp\concentrador.zip', '{app}\Atualizacao\{#MyAppVersion}\Programas\')

[Registry]
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocExt}\OpenWithProgids"; ValueType: string; ValueName: "{#MyAppAssocKey}"; ValueData: ""; Flags: uninsdeletevalue
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}"; ValueType: string; ValueName: ""; ValueData: "{#MyAppAssocName}"; Flags: uninsdeletekey
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName},0"
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""
Root: HKA; Subkey: "Software\Classes\Applications\{#MyAppExeName}\SupportedTypes"; ValueType: string; ValueName: ".myp"; ValueData: ""

;Cria icones no desktop e startmenu
[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\Concentrador\{#MyAppExeName}"; IconFilename: "{app}\rec\icone.ico"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\Concentrador\{#MyAppExeName}"; IconFilename: "{app}\rec\icone.ico"; Tasks: desktopicon
Name: "{group}\{#MySubAppName}"; Filename: "{app}\Utilitario\{#MySubAppExeName}"; IconFilename: "{app}\rec\icone2.ico"
Name: "{autodesktop}\{#MySubAppName}"; Filename: "{app}\Utilitario\{#MySubAppExeName}"; IconFilename: "{app}\rec\icone2.ico"; Tasks: desktopicon
Name: "{group}\{#MyApps}"; Filename: "{app}\sys\{#MyAppsExec}"; IconFilename: "{app}\rec\icone3.ico"
Name: "{group}\{#MyUinAppName}"; Filename: "{app}\{#MyAppExit}"; IconFilename: "{app}\rec\icone4.ico"
Name: "{group}\{#MyAppBase}"; Filename: "{app}\sys\{#MyDBPDV}"; IconFilename: "{app}\rec\icone3.ico"

; Executa scripts em lote (Descrição na Linha)

[Run]
Filename: "{app}\temp\install-cli.appxbundle"; Flags: nowait shellexec skipifsilent; Description: "Instalador WINGET"; StatusMsg: "Instalando CLI"; Components: Aplicativos; Tasks: desktopicon
Filename: "{app}\temp\postgresql-12.exe"; Description: "Instalador Postgres"; StatusMsg: "Instalando PostgreSql"; Components: PostgreSql; Tasks: desktopicon
Filename: "{app}\sys\java13.bat"; Flags: runhidden; Description: "Instalar Programas OpenJDK 13"; StatusMsg: "Instalando OpenJDK 13"; Components: Programas
Filename: "{app}\sys\netshare.bat"; Flags: runhidden; StatusMsg: "Compartilhando pasta Mercadologic..."; Components: Configuracao
Filename: "{app}\sys\var.bat"; Flags: runhidden; Description: "Adicionando Variaveis de Sistema"; StatusMsg: "Adicionando Variaveis de Ambiente..."; Components: Configuracao
Filename: "{app}\sys\cp.bat"; Flags: postinstall; Description: "Copiar Arquivos pré-configurados(java.security |postgresql.conf)"; StatusMsg: "Copiando arquivos (java.security |Postgresql.conf)"; Components: Configuracao
Filename: "{app}\sys\database.bat"; Flags: postinstall; Description: "Criar e Restaurar Banco de Dados(DBMercadologic)"; StatusMsg: "Configurações em andamento...!"; Components: DBMercadologic; Tasks: desktopicon
Filename: "{app}\sys\pacotes.bat"; Flags: postinstall; Description: "Instalar Adicionais - Notepad++ | Winrar | UltraVNC"; StatusMsg: "Instalando Programas... Este passo pode demorar! (Coffee Break)"; Components: Programas
Filename: "{app}\sys\database_backup_update.bat"; Description: "Criar e Restaurar Banco ********"; StatusMsg: "Configurações em andamento...!"; Components: Backuprestore
Filename: "{app}\sys\database_restore_create.bat"; Description: "Criar e Restaurar Banco ********"; StatusMsg: "Configurações em andamento...!"; Components: Backuprestore



;Download Arquivos Executaveis

[Types]
Name: "Completo"; Description: "Instalação completa"
Name: "Atualização"; Description: "Atualizar o Concentrador"
Name: "Customizada"; Description: "Selecione os Pacotes"; Flags: iscustom

[Components]
Name: "Concentrador"; Description: "Instalação do Concentrador {#MyAppVersion}"; Types: Completo Atualização
Name: "Configuradores"; Description: "Compartilhamento de Pastas | Variaveis do Sistema |  JAVA 13"; Types: Completo Atualização
Name: "PostgreSql"; Description: "Instalação do PostgreSql"; Types: Completo Atualização
Name: "Aplicativos"; Description: "Instalador CLI para Windows 10"; Types: Completo
Name: "Programas"; Description: "Winrar | Notepad | Ulta VNC"; Types: Completo Customizada Atualização
Name: "Configuracao"; Description: "Copia pghba e Postgres.conf"; Types: Completo Atualização
Name: "DBMercadologic"; Description: "Cria e Restaura o DBMercadologic no PostgreSql"; Types: Completo Customizada
Name: "Databridge"; Description: "Databridge 1.6"; Types: Atualização
Name: "ScriptPackConc"; Description: "Script Pack Concentrador 13.2.2"; Types: Atualização
Name: "ScriptPackPDV"; Description: "Script Pack PDV 13.2.2"; Types: Completo Atualização
Name: "ScriptPackScantech"; Description: "Script Pack Scantech 13.2.2"; Types: Atualização Completo
Name: "Copiacertificado"; Description: "Copia certificado da pasta"; Types: Atualização
Name: "Copiacertificado"; Description: "Copia certificado da pasta"; Types: Atualização
Name: "BackupPDV"; Description: "Backup PDV 1.0.11"; Types: Completo Atualização
Name: "Backuprestore"; Description: "Backup e Restaura DBMercadologic para DBTeste"; Types: Atualização
Name: "java13"; Description: "Instalador JAVA 13"; Types: Completo Atualização

[UninstallDelete]
Type: filesandordirs; Name: "{app}\*"

[Code]
var
  DownloadPage: TDownloadWizardPage;

function OnDownloadProgress(const Url, FileName: String; const Progress, ProgressMax: Int64): Boolean;
begin
  if Progress = ProgressMax then
    Log(Format('Baixado com sucesso para {tmp}: %s', [FileName]));
  Result := True;
end;

procedure InitializeWizard;
begin
  DownloadPage := CreateDownloadPage(SetupMessage(msgWizardPreparing), SetupMessage(msgPreparingDesc), @OnDownloadProgress);
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  if CurPageID = wpReady then begin
    DownloadPage.Clear;
    DownloadPage.Add('https://github.com/microsoft/winget-cli/releases/download/v-0.2.10191-preview/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.appxbundle', 'install-cli.appxbundle', '');
    DownloadPage.Add('https://www.dropbox.com/s/yp8458lo05a8wuh/postgresql-12.5-1-windows-x64.exe?dl=1', 'postgresql-12.exe', '');
    DownloadPage.Add('https://sparkjf.com/dist/Concentrador-13-2-2.zip', 'concentrador.zip', '');
    DownloadPage.Add('https://www.dropbox.com/s/ask64i1wi2vm1s3/Utilitário_2.4.0.rar?dl=1', 'utilitario-2-4-0.zip', '');
    DownloadPage.Add('https://www.dropbox.com/s/y6mp0ysp748bx8x/DataBridge-1.6.0.msi?dl=1', 'databridge-1-6.msi', '');
    DownloadPage.Add('https://www.dropbox.com/s/p3ya3yefcjg9a3e/ml-concentrador-13.2.2.exe?dl=1', 'spack-conc-1322.exe', '');
    DownloadPage.Add('https://www.dropbox.com/s/mixqxvrsvvwhby8/ml-pdv-13.2.2.exe?dl=1', 'spack-pdv-1322.exe', '');
    DownloadPage.Add('https://www.dropbox.com/s/6piofe3ouqv21f7/ml-pdv-ativacao-scanntech.exe?dl=1', 'spack-scantech-1322.exe', '');
    DownloadPage.Add('https://www.dropbox.com/s/kkf6up3zy9yxmwi/Mlogic-1.0.11_r23077-Setup.msi?dl=1', 'backup-pdv-1011.msi', '');
    DownloadPage.Add('https://www.dropbox.com/s/4g8q6d2jep79m37/Biblioteca%20Elgin-9.rar?dl=1', 'elgin9-lib.rar', '');
    DownloadPage.Add('https://www.dropbox.com/s/ul49h4q3smzcvdr/Tef.rar?dl=1', 'tef-1322.rar', '');
    DownloadPage.Show;
    try
      try
        DownloadPage.Download;
        Result := True;
      except
        SuppressibleMsgBox(AddPeriod(GetExceptionMessage), mbCriticalError, MB_OK, IDOK);
        Result := False;
      end;
    finally
      DownloadPage.Hide;
    end;
  end else                                         
    Result := True;
end;


//Descompactador ZIP
const
  SHCONTCH_NOPROGRESSBOX = 4;
  SHCONTCH_RESPONDYESTOALL = 16;

procedure Unzip(ZipFile, TargetFolder: String); 
var
  ShellObj, SrcFile, DestFolder: Variant;
begin
  ShellObj := CreateOleObject('Shell.Application');
  SrcFile := ShellObj.NameSpace(ZipFile);
  DestFolder := ShellObj.NameSpace(TargetFolder);
  DestFolder.CopyHere(SrcFile.Items, SHCONTCH_NOPROGRESSBOX or SHCONTCH_RESPONDYESTOALL)
end;

procedure ExtractMe(src, target : String); 
begin
  // Add extra application code here, then:
  Unzip(ExpandConstant(src), ExpandConstant(target));
end;
