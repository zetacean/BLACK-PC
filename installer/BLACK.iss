; BLACK PC installer (Inno Setup 6). Built by release.bat when ISCC is on the PATH:
;   ISCC /DStage=<folder with BLACK.exe, compiler\ ...> /DVersion=<x.y.z> installer\BLACK.iss
; It installs the port, asks for the player's game disc image, has BLACK.exe write the game's files beside itself and build
; the game's code from them (--setup), and removes the compiler folder that is no longer needed. The disc image is only
; read: it is not copied and not needed afterwards.
#ifndef Stage
  #error Define Stage, the folder to install from
#endif
#ifndef Version
  #define Version "dev"
#endif

[Setup]
AppName=BLACK PC
AppVersion={#Version}
AppPublisher=BLACK PC community build
DefaultDirName={localappdata}\Programs\BLACK PC
DefaultGroupName=BLACK PC
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
OutputDir=..
OutputBaseFilename=BLACK-PC-Setup
SetupIconFile=..\src\common\black.ico
UninstallDisplayIcon={app}\BLACK.exe
Compression=lzma2/normal
SolidCompression=yes
WizardStyle=modern
DisableProgramGroupPage=yes
DisableReadyPage=no

; The language chosen here is the game's language too: written to black.toml before the first run, its package
; downloaded during --setup. Indonesian, the game's eighth language, has no Inno Setup translation: it is chosen in
; the game (F10 > Language).
[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
Name: "es"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "fr"; MessagesFile: "compiler:Languages\French.isl"
Name: "de"; MessagesFile: "compiler:Languages\German.isl"
Name: "it"; MessagesFile: "compiler:Languages\Italian.isl"
Name: "ptbr"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "ru"; MessagesFile: "compiler:Languages\Russian.isl"

[CustomMessages]
en.IsoTitle=Your copy of BLACK
en.IsoSubtitle=The game is not included. Choose the disc image of your own copy.
en.IsoDescription=Choose the BLACK disc image (.iso) of the Xbox, USA or Europe release. It is only read; it is not copied and you can move it away afterwards.
en.IsoFilter=Xbox disc image (*.iso)|*.iso|All files (*.*)|*.*
en.IsoMissing=Choose the disc image of the game to continue.
en.Preparing=Preparing the game: extracting its files and building its code. This takes a few minutes and a window shows the progress.
en.SetupFailed=The game could not be prepared. The installed port is kept; run BLACK.exe to try again, and see logs\compile.log if it fails.
en.Run=Start BLACK now
es.IsoTitle=Tu copia de BLACK
es.IsoSubtitle=El juego no se incluye. Elige la imagen de disco de tu propia copia.
es.IsoDescription=Elige la imagen de disco (.iso) de BLACK para Xbox, edición USA o Europa. Solo se lee: no se copia y puedes moverla después.
es.IsoFilter=Imagen de disco de Xbox (*.iso)|*.iso|Todos los archivos (*.*)|*.*
es.IsoMissing=Elige la imagen de disco del juego para continuar.
es.Preparing=Preparando el juego: extrayendo sus archivos y construyendo su código. Tarda unos minutos y una ventana muestra el avance.
es.SetupFailed=No se pudo preparar el juego. El port queda instalado; ejecuta BLACK.exe para reintentar y mira logs\compile.log si falla.
es.Run=Iniciar BLACK ahora
fr.IsoTitle=Votre copie de BLACK
fr.IsoSubtitle=Le jeu n'est pas inclus. Choisissez l'image disque de votre propre copie.
fr.IsoDescription=Choisissez l'image disque (.iso) de BLACK pour Xbox, version USA ou Europe. Elle est seulement lue : elle n'est pas copiée et vous pourrez la déplacer ensuite.
fr.IsoFilter=Image disque Xbox (*.iso)|*.iso|Tous les fichiers (*.*)|*.*
fr.IsoMissing=Choisissez l'image disque du jeu pour continuer.
fr.Preparing=Préparation du jeu : extraction de ses fichiers et construction de son code. Cela prend quelques minutes ; une fenêtre montre l'avancement.
fr.SetupFailed=Le jeu n'a pas pu être préparé. Le portage reste installé ; lancez BLACK.exe pour réessayer, et consultez logs\compile.log en cas d'échec.
fr.Run=Lancer BLACK maintenant
de.IsoTitle=Ihre Kopie von BLACK
de.IsoSubtitle=Das Spiel ist nicht enthalten. Wählen Sie das Disc-Image Ihrer eigenen Kopie.
de.IsoDescription=Wählen Sie das Disc-Image (.iso) von BLACK für die Xbox, USA- oder Europa-Version. Es wird nur gelesen: Es wird nicht kopiert und kann danach verschoben werden.
de.IsoFilter=Xbox-Disc-Image (*.iso)|*.iso|Alle Dateien (*.*)|*.*
de.IsoMissing=Wählen Sie das Disc-Image des Spiels, um fortzufahren.
de.Preparing=Das Spiel wird vorbereitet: Dateien werden entpackt und der Spielcode erstellt. Das dauert einige Minuten; ein Fenster zeigt den Fortschritt.
de.SetupFailed=Das Spiel konnte nicht vorbereitet werden. Der Port bleibt installiert; starten Sie BLACK.exe für einen neuen Versuch und sehen Sie bei Fehlern logs\compile.log ein.
de.Run=BLACK jetzt starten
it.IsoTitle=La tua copia di BLACK
it.IsoSubtitle=Il gioco non è incluso. Scegli l'immagine del disco della tua copia.
it.IsoDescription=Scegli l'immagine del disco (.iso) di BLACK per Xbox, versione USA o Europa. Viene solo letta: non viene copiata e potrai spostarla dopo.
it.IsoFilter=Immagine disco Xbox (*.iso)|*.iso|Tutti i file (*.*)|*.*
it.IsoMissing=Scegli l'immagine del disco del gioco per continuare.
it.Preparing=Preparazione del gioco: estrazione dei file e creazione del codice. Richiede alcuni minuti e una finestra mostra l'avanzamento.
it.SetupFailed=Impossibile preparare il gioco. Il port resta installato; esegui BLACK.exe per riprovare e consulta logs\compile.log in caso di errore.
it.Run=Avvia BLACK ora
ptbr.IsoTitle=Sua cópia de BLACK
ptbr.IsoSubtitle=O jogo não está incluído. Escolha a imagem de disco da sua própria cópia.
ptbr.IsoDescription=Escolha a imagem de disco (.iso) de BLACK para Xbox, versão USA ou Europa. Ela só é lida: não é copiada e você pode movê-la depois.
ptbr.IsoFilter=Imagem de disco do Xbox (*.iso)|*.iso|Todos os arquivos (*.*)|*.*
ptbr.IsoMissing=Escolha a imagem de disco do jogo para continuar.
ptbr.Preparing=Preparando o jogo: extraindo seus arquivos e construindo seu código. Leva alguns minutos e uma janela mostra o progresso.
ptbr.SetupFailed=Não foi possível preparar o jogo. O port continua instalado; execute BLACK.exe para tentar de novo e veja logs\compile.log se falhar.
ptbr.Run=Iniciar BLACK agora
ru.IsoTitle=Ваша копия BLACK
ru.IsoSubtitle=Игра не входит в комплект. Выберите образ диска вашей собственной копии.
ru.IsoDescription=Выберите образ диска (.iso) BLACK для Xbox, версия USA или Europe. Он только читается: не копируется, и его можно потом переместить.
ru.IsoFilter=Образ диска Xbox (*.iso)|*.iso|Все файлы (*.*)|*.*
ru.IsoMissing=Выберите образ диска игры, чтобы продолжить.
ru.Preparing=Подготовка игры: извлечение файлов и сборка кода. Это займёт несколько минут; ход работы показывает отдельное окно.
ru.SetupFailed=Не удалось подготовить игру. Порт установлен; запустите BLACK.exe, чтобы повторить, а при ошибке смотрите logs\compile.log.
ru.Run=Запустить BLACK сейчас

[Files]
Source: "{#Stage}\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs ignoreversion

[Icons]
Name: "{group}\BLACK PC"; Filename: "{app}\BLACK.exe"
Name: "{autodesktop}\BLACK PC"; Filename: "{app}\BLACK.exe"; Tasks: desktopicon

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Run]
Filename: "{app}\BLACK.exe"; Description: "{cm:Run}"; Flags: nowait postinstall skipifsilent

[UninstallDelete]
; the game extracted beside the executable and what it makes
Type: filesandordirs; Name: "{app}\chars"
Type: filesandordirs; Name: "{app}\data"
Type: filesandordirs; Name: "{app}\export"
Type: filesandordirs; Name: "{app}\levels"
Type: filesandordirs; Name: "{app}\sound"
Type: filesandordirs; Name: "{app}\videos"
Type: files; Name: "{app}\default.xbe"
Type: files; Name: "{app}\GlobData.bin"
Type: filesandordirs; Name: "{app}\logs"
Type: filesandordirs; Name: "{app}\language"
Type: filesandordirs; Name: "{app}\translations"
Type: filesandordirs; Name: "{app}	ranslations"
Type: filesandordirs; Name: "{app}\compiler"
Type: files; Name: "{app}\Black.dll"
Type: files; Name: "{app}\black.toml"

[Code]
var
  IsoPage: TInputFileWizardPage;

procedure InitializeWizard;
begin
  IsoPage := CreateInputFilePage(wpSelectDir, CustomMessage('IsoTitle'), CustomMessage('IsoSubtitle'),
    CustomMessage('IsoDescription'));
  IsoPage.Add('', CustomMessage('IsoFilter'), '.iso');
  IsoPage.Values[0] := ExpandConstant('{param:ISO|}');  // /ISO="C:\game.iso" fills it in; with /SILENT it is the disc
end;

// the installer's language as the game's setting
function GameLanguage: String;
var
  L: String;
begin
  L := ActiveLanguage;
  Result := 'int';
  if L = 'es' then Result := 'esp'
  else if L = 'fr' then Result := 'fra'
  else if L = 'de' then Result := 'deu'
  else if L = 'it' then Result := 'ita'
  else if L = 'ptbr' then Result := 'pt-BR'
  else if L = 'ru' then Result := 'ru';
end;

function DiscPath: String;
begin
  Result := IsoPage.Values[0];
  if Result = '' then Result := ExpandConstant('{param:ISO|}');
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := True;
  if CurPageID = IsoPage.ID then
    if (IsoPage.Values[0] = '') or not FileExists(IsoPage.Values[0]) then
    begin
      MsgBox(CustomMessage('IsoMissing'), mbError, MB_OK);
      Result := False;
    end;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  Code: Integer;
begin
  if CurStep = ssPostInstall then
  begin
    Log('Installer language ' + ActiveLanguage + ', game language ' + GameLanguage);
    // the game reads its language from black.toml; one already there (a reinstall) keeps the player's settings
    if not FileExists(ExpandConstant('{app}\black.toml')) then
      SaveStringToFile(ExpandConstant('{app}\black.toml'), 'language = ''' + GameLanguage + '''' + #13#10, False);
    WizardForm.StatusLabel.Caption := CustomMessage('Preparing');
    WizardForm.ProgressGauge.Style := npbstMarquee;
    if not Exec(ExpandConstant('{app}\BLACK.exe'), '--setup "' + DiscPath + '"', ExpandConstant('{app}'),
                SW_SHOWNORMAL, ewWaitUntilTerminated, Code) or (Code <> 0) then
      MsgBox(CustomMessage('SetupFailed'), mbError, MB_OK);
    WizardForm.ProgressGauge.Style := npbstNormal;
  end;
end;
