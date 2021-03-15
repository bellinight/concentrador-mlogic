; Script by the Inno Setup Script.
; Concentrador | Mercadologic!

#define MyAppName "Concentrador"
#define MyApps "Instalar Programas"
#define MyUinAppName "Remover"
#define MySubAppName "Utilitario"
#define MyAppVersion "13.2.1"
#define MyAppPublisher "Processa Sistemas, inc"
#define MyAppURL "https:\\processasistemas.com.br"
#define MySubAppExeName "utilitario.bat"
#define MyAppExit "unins000.exe"
#define MyAppsExec "pacotes.bat"
#define MyAppExeName "concentrador.bat"
#define MyAppAssocName MyAppName + ""
#define MyAppAssocExt ".exe"
#define MyAppAssocKey StringChange(MyAppAssocName, " ", "") + MyAppAssocExt

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{EA25F56D-B143-4903-A6B4-2E5D6BB868DB}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
;AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName=C:\Mercadologic
DisableDirPage=no
ChangesAssociations=yes
DisableProgramGroupPage=yes
;LicenseFile=C:\Users\leonardo.belini\Documents\instalacoes-ex\licença.txt
;InfoBeforeFile=C:\Users\leonardo.belini\Documents\instalacoes-ex\Instruções-Iniciais.txt
;InfoAfterFile=C:\Users\leonardo.belini\Documents\instalacoes-ex\Instruções-Finais.txt
;Uncomment the following line to run in non administrative install mode (install for current user only.)
;PrivilegesRequired=lowest
OutputDir=C:\Users\leonardo.belini\Documents\Projetos\Executaveis
OutputBaseFilename=Setup_Concentrador_ML_8
SetupIconFile=C:\Users\leonardo.belini\Documents\Projetos\concentrador-mlogic\13.2.1\Concentrador\recursos\icones\Concentrador.ico
Compression=lzma2
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Dirs]
Name: "{app}\Importacao"; Permissions: users-modify
Name: "{app}\Mercadologic"; Permissions: users-modify
Name: "{app}\XMLs"; Permissions: users-modify
Name: "{app}\Importacao"; Permissions: users-modify


[Files]
Source: "C:\Users\leonardo.belini\Documents\Projetos\concentrador-mlogic\13.2.1\Concentrador\{#MyAppExeName}"; DestDir: "c:\Mercadologic\Concentrador\"; Flags: ignoreversion
Source: "C:\Users\leonardo.belini\Documents\Projetos\concentrador-mlogic\13.2.1\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Registry]
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocExt}\OpenWithProgids"; ValueType: string; ValueName: "{#MyAppAssocKey}"; ValueData: ""; Flags: uninsdeletevalue
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}"; ValueType: string; ValueName: ""; ValueData: "{#MyAppAssocName}"; Flags: uninsdeletekey
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName},0"
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""
Root: HKA; Subkey: "Software\Classes\Applications\{#MyAppExeName}\SupportedTypes"; ValueType: string; ValueName: ".myp"; ValueData: ""

[Icons]
Name: "{autoprograms}\Mercadologic\{#MyAppName}"; Filename: "{app}\Concentrador\{#MyAppExeName}"; IconFilename: "{app}\rec\icone.ico"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\Concentrador\{#MyAppExeName}"; Tasks: desktopicon; IconFilename: "{app}\rec\icone.ico"  
Name: "{autoprograms}\Mercadologic\{#MySubAppName}"; Filename: "{app}\Utilitario\{#MySubAppExeName}"; IconFilename: "{app}\rec\icone2.ico"
Name: "{autodesktop}\{#MySubAppName}"; Filename: "{app}\Utilitario\{#MySubAppExeName}"; Tasks: desktopicon; IconFilename: "{app}\rec\icone2.ico"
Name: "{autoprograms}\Mercadologic\{#MyUinAppName}"; Filename: "{app}\{#MyAppExit}"; IconFilename: "{app}\rec\icone3.ico"
Name: "{autoprograms}\Mercadologic\{#MyApps}"; Filename: "{app}\sys\{#MyAppsExec}"; IconFilename: "{app}\rec\icone3.ico"

[Run]
Filename: "{app}\sys\cli.bat"; Description: "Instalar Programas JAVA | Postgres | Instalador WINGET "; StatusMsg: "Adicionando Programas, este processo pode demorar....";  Flags: runhidden
Filename: "{app}\sys\netshare.bat"; StatusMsg: "Compartilhando pasta Mercadologic...";   Flags: runhidden 
Filename: "{app}\sys\var.bat"; Description: "Adicionando Variaveis de Sistema";StatusMsg: "Adicionando Variaveis de Ambiente...";  Flags: runhidden  waituntilterminated
Filename: "{app}\sys\database.bat"; Description: "Criar e Restaurar DBMercadologic";StatusMsg: "Criação e Restauração,em andamento... (senha do prompt: postgres)";
Filename: "{app}\sys\cp.bat"; Description: "Copiar Arquivos(java.security |Postgresql.conf)";StatusMsg: "Copiando arquivos (java.security |Postgresql.conf)";  Flags: postinstall
Filename: "{app}\sys\pga.bat"; Description: "Conferencia de Variaveis e Alteraçãode Senha Postgres";StatusMsg: "Em andamento, fique atento ao prompt!"; Flags: postinstall
Filename: "{app}\sys\pacotes.bat"; Description: "Instalar Programas - Notepad++ | Winrar | RemoteDesktop Manager"; StatusMsg: "Instalando Programas... Este passo pode demorar"; Flags: postinstall    waituntilterminated

 




