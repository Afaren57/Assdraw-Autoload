#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Owlolf.ico
#AutoIt3Wrapper_Outfile_x64=[Owlolf] Assdraw Autoload v 1.4.exe
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Comment=Logiciel d automatisation de l ouverture d assdraw pour les cleans
#AutoIt3Wrapper_Res_Fileversion=1.4.0.0
#AutoIt3Wrapper_Res_Language=1036
#AutoIt3Wrapper_Run_AU3Check=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <MsgBoxConstants.au3>
#include <StaticConstants.au3>
#include <String.au3>
#include <File.au3>

Global $drive = @WorkingDir ; Trouve le chemin dans lequel se situe le présent exe
Global $options = "[Owlolf] Options.ini" ; Nom du fichier d'options
Global $OptionPath = $drive & "\" & $options ; Donne le chemin du fichier d'options dans le dossier du présent exe
Global $Largeur_Ecran = @DesktopWidth ; Donne la largeur de l'écran
Global $Hauteur_Ecran = @DesktopHeight ; Donne la longueur de l'écran

Global $AvecOuSans, $p1TagsSend, $gui_Pos[4][2], $stop, $boucle, $Definition, $sCleanHotkey, $sp1Hotkey, $DoBoth, $CleanOrP1, $CleanOrP1HK, $DIY
; pour p1, Clean,... la première colonne correspond à : 0 = x et 1 = y 
; pour CleanOrP1 : 0 = Clean et 1 = p1
; pour Gui_Pos : 0 = AA, 1 = AA_Options, 2 = HK, 3 = APP1 et APC

Global $AA, $AA_Options, $HK, $APP1, $APC

Opt("GUIOnEventMode", 1)

Global $iFileExists = FileExists($options) ; Vérifie si le fichier d'options existe


If $iFileExists Then

	Parametres() ; Fonction qui récupère les paramètres et qui va appeler la fonction pour les enregistrer dans les bonnes variables

Else

	Defaut() ; Si aucun fichier d'option présent, crée le fichier de base

EndIf

AssdrawAutoload()

Func AssdrawAutoload() ; Fenêtre principale avec lancement des fonctions Clean et p1 ainsi que la fenêtre des options, le choix des sous-titres et des tags

	Local $AA_Exist = WinExists("[Owlolf] Assdraw Autoload")
	Opt("WinTitleMatchMode", 2)

	If $AA_Exist = 1 Then
		
		GUIDelete($AA)
		
	EndIf
	
	Global $AA = GUICreate("[Owlolf] Assdraw Autoload", 269, 94, $gui_Pos[0][0], $gui_Pos[0][1])
		GUISetFont(10, 400, 0, "Arial")
		GUISetOnEvent($GUI_EVENT_CLOSE, "On_Close_MainGui")
		
	Global $AA_Clean = GUICtrlCreateButton("Clean", 0, 0, 83, 33)
		GUICtrlSetOnEvent(-1, "On_Clean")
		
	Global $AA_p1 = GUICtrlCreateButton("p1", 96, 0, 83, 33)
		GUICtrlSetOnEvent(-1, "On_p1")
		
	Global $AA_Options = GUICtrlCreateButton("Options", 192, 0, 75, 33)
		GUICtrlSetOnEvent(-1, "AA_Options")
		
	If $AvecOuSans = 1 Then ; Checkbox dynamique
	
		Global $AvecOuSansCheckbox = GUICtrlCreateCheckbox("Copier avec sous-titres", 8, 40, 153, 17)
		GUICtrlSetState(-1, $GUI_CHECKED)
		GUICtrlSetOnEvent(-1, "On_AvecOuSansCheck")
		
	Else
	
		Global $AvecOuSansCheckbox = GUICtrlCreateCheckbox("Copier sans sous-titres", 8, 40, 153, 17)
		GUICtrlSetState(-1, $GUI_UNCHECKED)
		GUICtrlSetOnEvent(-1, "On_AvecOuSansCheck")
	
	EndIf
		
	Global $p1Tags = GUICtrlCreateInput("", 112, 64, 153, 24)
	Global $AA_T1 = GUICtrlCreateLabel("Ajouter tags à p1 :", 0, 66, 111, 20)

	GUISetState(@SW_SHOW)
	WinSetOnTop("[Owlolf] Assdraw Autoload", "", 1)

	While 1
		Sleep(10)
	WEnd

EndFunc

Func AA_Options() ; Fenêtre des options, simplifiée par rapport à l'ancien script
	
	Local $Options_Exist = WinExists("[Owlolf] Options")
	Opt("WinTitleMatchMode", 2)

	If $Options_Exist = 1 Then
		
		GUIDelete($AA_Options)
		
	EndIf
	
	FileOpen($OptionPath, 1)

	ReadIniFile()
	
	Global $AA_Options = GUICreate("[Owlolf] Options", 229, 182, 1266, 0)
		GUISetFont(10, 400, 0, "Arial")
		GUISetOnEvent($GUI_EVENT_CLOSE, "On_Close_Gui")
		
	Global $AAO_R = GUICtrlCreateGroup("Réinitialiser les paramètres", 0, 120, 225, 57)
	Global $Reinitialiser = GUICtrlCreateButton("Défaut", 72, 144, 73, 25)
		GUICtrlSetOnEvent(-1, "Defaut")
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		
	Global $AAO_SetGuiPos = GUICtrlCreateGroup("Enregistrer les positions des fenêtres", 0, 56, 225, 57)
	Global $SaveGuiPos = GUICtrlCreateButton("OK", 72, 80, 81, 25)
		GUICtrlSetOnEvent(-1, "On_SaveGuiPos")
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		
	Global $AAO_Hotkey = GUICtrlCreateGroup("Gestion des raccourcis clavier", 0, 0, 225, 57)
	Global $CleanHotKeyButton = GUICtrlCreateButton("Clean", 24, 24, 73, 25)
		GUICtrlSetOnEvent(-1, "HotKeyClean")
		
	Global $p1HotkeyButton = GUICtrlCreateButton("p1", 120, 24, 81, 25)
		GUICtrlSetOnEvent(-1, "HotKeyP1")
		GUICtrlCreateGroup("", -99, -99, 1, 1)

	GUISetState(@SW_SHOW)
	
EndFunc

Func HotKey()

	Local $HK_Exist = WinExists("Raccourci de la fonction")
	Opt("WinTitleMatchMode", 2)

	If $HK_Exist = 1 Then
		
		GUIDelete($HK)
		
	EndIf
	
	If $CleanOrP1HK = 1 Then
	
		Global $HK = GUICreate("Raccourci de la fonction P1", 341, 149, $gui_Pos[2][0], $gui_Pos[2][1])
			GUISetFont(10, 400, 0, "Arial")
			GUISetOnEvent($GUI_EVENT_CLOSE, "On_Close_Gui")
			
	Else
	
		Global $HK = GUICreate("Raccourci de la fonction Clean", 341, 149, $gui_Pos[2][0], $gui_Pos[2][1])
			GUISetFont(10, 400, 0, "Arial")
			GUISetOnEvent($GUI_EVENT_CLOSE, "On_Close_Gui")
	
	EndIf
		
	Global $HK_T1 = GUICtrlCreateLabel("Sélectionnez le raccourci que vous souhaitez utiliser :", 0, 0, 315, 20)
	Global $HK_T2 = GUICtrlCreateLabel("Ou choisissez une touche spéciale dans la liste suivante :", 0, 56, 340, 20)
	Global $HK_T3 = GUICtrlCreateLabel("Ou bien :", 8, 122, 57, 20)
	Global $HK_Graphic1 = GUICtrlCreateGraphic(0, 51, 337, 2, $SS_BLACKFRAME)
	Global $HK_Graphic2 = GUICtrlCreateGraphic(0, 110, 337, 2, $SS_BLACKFRAME)
	
	Global $HK_CtrlCheckBox = GUICtrlCreateCheckbox("Ctrl", 0, 28, 41, 17)
	Global $HK_AltCheckBox = GUICtrlCreateCheckbox("Alt", 48, 28, 41, 17)
	Global $HK_ShiftCheckBox = GUICtrlCreateCheckbox("Shift", 96, 28, 49, 17)
	
	Global $HK_Key = GUICtrlCreateInput("", 152, 24, 105, 24)
	
	Global $HK_Combobox = GUICtrlCreateCombo("", 48, 80, 169, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
		GUICtrlSetData(-1, "F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|Pause|Arrêt Défil (Scroll Lock)")
		
	Global $HK_Set1 = GUICtrlCreateButton("Set", 264, 24, 73, 24)
		GUICtrlSetOnEvent(-1, "On_SetHK1")
		
	Global $KH_Set2 = GUICtrlCreateButton("Set", 224, 80, 73, 24)
		GUICtrlSetOnEvent(-1, "On_SetHK2")
		
	Global $HK_Reinit = GUICtrlCreateButton("Supprimer le raccourci", 64, 120, 161, 25)
		GUICtrlSetOnEvent(-1, "HK_Reset")
		
	Global $HK_Cancel = GUICtrlCreateButton("Annuler", 232, 120, 105, 25)
		GUICtrlSetOnEvent(-1, "HK_Cancel")
	
	GUISetState(@SW_SHOW)

EndFunc

;Début des fonctions, fin des gui

Func On_SaveGuiPos()
		
	FileOpen($OptionPath, 1)
	
	Local $AA_Exist = WinExists("[Owlolf] Assdraw Autoload")
	Opt("WinTitleMatchMode", 2)

	If $AA_Exist = 1 Then
		
		Local $AA_Pos[4] = WinGetPos("[Owlolf] Assdraw Autoload")
		Opt("WinTitleMatchMode", 2)
		IniWrite($options, "gui_Pos", "AA_x", $AA_Pos[0])
		IniWrite($options, "gui_Pos", "AA_y", $AA_Pos[1])
		
	EndIf
	
	Local $Options_Exist = WinExists("[Owlolf] Options")
	Opt("WinTitleMatchMode", 2)

	If $Options_Exist = 1 Then
		
		Local $AAO_Pos[4] = WinGetPos("[Owlolf] Options")
		Opt("WinTitleMatchMode", 2)
		IniWrite($options, "gui_Pos", "AAO_x", $AAO_Pos[0])
		IniWrite($options, "gui_Pos", "AAO_y", $AAO_Pos[1])
		
	EndIf
	
	Local $HK_Exist = WinExists("Raccourci de la fonction")
	Opt("WinTitleMatchMode", 2)

	If $HK_Exist = 1 Then
	
		Local $HK_Pos[4] = WinGetPos("Raccourci de la fonction")
		Opt("WinTitleMatchMode", 2)
		IniWrite($options, "gui_Pos", "HK_x", $HK_Pos[0])
		IniWrite($options, "gui_Pos", "HK_y", $HK_Pos[1])
		
	EndIf
	
	Local $AP_Exist = WinExists("Assistant de paramétrage")
	Opt("WinTitleMatchMode", 2)

	If $AP_Exist = 1 Then
		
		Local $AP_Pos[4] = WinGetPos("Assistant de paramétrage")
		Opt("WinTitleMatchMode", 2)
		IniWrite($options, "gui_Pos", "AP_x", $AP_Pos[0])
		IniWrite($options, "gui_Pos", "AP_y", $AP_Pos[1])	
		
	EndIf

	ReadIniFile()
	FileClose($options)
	
EndFunc

Func HotKeyClean()
	
	$CleanOrP1HK = 0
	HotKey()
	$CleanOrP1 = "Clean"
	
EndFunc

Func HotKeyP1()
	
	$CleanOrP1HK = 1
	HotKey()
	$CleanOrP1 = "p1"
	
EndFunc

Func HK_Reset()
	
	FileOpen($OptionPath, 1)
	ReadIniFile()
	
	If $CleanOrP1HK = 0 Then
	
		HotKeySet("x")
		IniWrite($options, "Raccourcis", "Clean", "")
		
	ElseIf $CleanOrP1HK = 1 Then
	
		HotKeySet("x")
		IniWrite($options, "Raccourcis", "p1", "")
		
	EndIf
	
	$sCleanHotkey = IniRead($options, "Raccourcis", "Clean", "")
	$sp1Hotkey = IniRead($options, "Raccourcis", "p1", "")
	FileClose($options)
	GUIDelete($HK)

EndFunc

Func HK_Cancel()

	GUIDelete($HK)

EndFunc

Func Parametres() ; To Do : à voir s'il n'y a pas moyen de le simplifier en une seule fonction

	FileOpen($OptionPath, 1)
	ReadIniFile()
	$sCleanHotkey = IniRead($options, "Raccourcis", "Clean", "")
	$sp1Hotkey = IniRead($options, "Raccourcis", "p1", "")
	FileClose($options)

EndFunc

Func ReadIniFile() ; Stocke les différentes valeurs présentes dans le fichier d'option dans les bonnes variables
	
	$gui_Pos[0][0] = IniRead($options, "gui_Pos", "AA_x", "991")
	$gui_Pos[0][1] = IniRead($options, "gui_Pos", "AA_y", "0")
	$gui_Pos[1][0] = IniRead($options, "gui_Pos", "AAO_x", "1266")
	$gui_Pos[1][1] = IniRead($options, "gui_Pos", "AAO_y", "0")
	$gui_Pos[2][0] = IniRead($options, "gui_Pos", "HK_x", "920")
	$gui_Pos[2][1] = IniRead($options, "gui_Pos", "HK_y", "122")
	$gui_Pos[3][0] = IniRead($options, "gui_Pos", "AP_x", "1267")
	$gui_Pos[3][1] = IniRead($options, "gui_Pos", "AP_y", "143")
	
	$AvecOuSans = IniRead($options, "Checkbox", "AvecOuSans", "4")
EndFunc

Func On_AvecOuSansCheck() ; Fonction de checkbox dynamique pour avoir avec ou sans les sous-titres

	$AvecOuSans = GUICtrlRead($AvecOuSansCheckBox)
	
	If $AvecOuSans = 1 Then
	
		GUICtrlSetData($AvecOuSansCheckBox, "Copier avec sous-titres")
		GUICtrlSetOnEvent($AvecOuSansCheckBox, "On_AvecOuSansCheck")
		
		FileOpen($OptionPath, 1)
		ReadIniFile()
		IniWrite($options, "Checkbox", "AvecOuSans", "1")
		FileClose($options)
	
	ElseIf $AvecOuSans = 4 Then
	
		GUICtrlSetData($AvecOuSansCheckBox, "Copier sans sous-titres")
		GUICtrlSetOnEvent($AvecOuSansCheckBox, "On_AvecOuSansCheck")
		
		FileOpen($OptionPath, 1)
		ReadIniFile()
		IniWrite($options, "Checkbox", "AvecOuSans", "4")
		FileClose($options)
	
	EndIf

	$AvecOuSans = 0
	
EndFunc

Func Defaut() ; Si aucun fichier d'options n'est trouvé, trouve la résolution de l'écran pour découvrir si des options préexistantes sont connues.

	FileOpen($OptionPath, 1) ; Crée un fichier options avec droits d'écriture dans le dossier de l'exe

	IniWrite($options, "Raccourcis", "Clean", "") ; Écriture des différentes options
	IniWrite($options, "Raccourcis", "p1", "")
	
	IniWrite($options, "Checkbox", "AvecOuSans", "4")
	
	IniWrite($options, "gui_Pos", "AA_x", "991")
	IniWrite($options, "gui_Pos", "AA_y", "0")
	IniWrite($options, "gui_Pos", "AAO_x", "1266")
	IniWrite($options, "gui_Pos", "AAO_y", "0")
	IniWrite($options, "gui_Pos", "HK_x", "920")
	IniWrite($options, "gui_Pos", "HK_y", "122")
	IniWrite($options, "gui_Pos", "AP_x", "1267")
	IniWrite($options, "gui_Pos", "AP_y", "143")

	FileClose($options)

	Parametres()
	ReadIniFile()
EndFunc

Func On_Clean() ; Ouvre Assdraw avec l'image en cours sur Aegisub
	
	Local $Fenetre
	ReadIniFile()
	
	$Fenetre = WinActive("Aegisub")
	Opt("WinTitleMatchMode", 2)
	
	If $Fenetre <> 0 Then
	
	; Aegisub est bien la fenêtre actuelle, on peut continuer
	
	Else
	; Aegisub n'est pas la fenêtre actuelle, vérification si elle existe
		$Fenetre = WinExists("Aegisub")
		
		If $Fenetre = 1 Then
		; Aegisub est bien ouvert, tentative d'ouverture
			WinActivate("Aegisub") ; La fenêtre la plus récente va être ouverte pour la suite
			
		Else
		
			MsgBox($MB_ICONERROR, "Erreur", "Aucune fenêtre d'Aegisub trouvée, vérifiez que vous l'avez bien lancé et veuillez réessayer.")
			Return
		
		EndIf
		
	EndIf
	
	ControlClick("Aegisub", "", "[TEXT:GLCanvasNR; INSTANCE:1]", "secondary")
	Opt("WinTitleMatchMode", 2)
	
	Dim $MousePos = MouseGetPos()

	If $AvecOuSans = 1 Then

		MouseClick("primary", $MousePos[0]+50, $MousePos[1]+30) ; Sélection de copier sans sous-titres (+90,+90) ou avec (+50, +30)

	Else

		MouseClick("primary", $MousePos[0]+90, $MousePos[1]+90) ; Sélection de copier sans sous-titres (+90,+90) ou avec (+50, +30)

	EndIf

	Dim $Run = Run("AssDraw3.exe", "", @SW_MAXIMIZE)
	
	WinWaitActive("ASSDraw3")
	
	Send("^v")
	Sleep(100)
	
	Dim $OpacityPos = WinGetPos("Background image opacity", "")
	Opt("WinTitleMatchMode", 2)
	
	MouseClickDrag("primary", $OpacityPos[0]+($OpacityPos[2]/2), $OpacityPos[1]+(2*$OpacityPos[3]/3), $OpacityPos[0]+$OpacityPos[2], $OpacityPos[1]+(2*$OpacityPos[3]/3))
	MouseClick("primary", $OpacityPos[0]+$OpacityPos[2]-20, $OpacityPos[1]+15)
	;MouseClickDrag("", $clean[0][1], $clean[1][1], $clean[0][1]+150, $clean[1][1]) ; Déplace la barre d'opacité à 100%
	;MouseClick( "", $clean[0][2], $clean[1][2], 1) ; Ferme la barre d'opacité
	Sleep(100)
	MouseWheel($MOUSE_WHEEL_DOWN, 50) ; Réduit le curseur à sa taille minimale
	Send("^+7") ; Origine en haut à gauche
	Send("{F2}") ; Outil Move
	Send("+{F2}") ; Fixe le BG
	
EndFunc

Func On_p1() ; Dépose le draw d'Assdraw avec les tags demandés

	Local $Clip = StringLeft(ClipGet(),1)
	
	Local $Tags = GuiCtrlRead($p1Tags)

	If $Clip == "m" Then
	;Il s'agit bien d'un draw
	ElseIf $Clip == " " Then
	
		$Clip = StringLeft(ClipGet(), 2)
		
		If $Clip == " m" Then
		;Pareil
		Else
		
			MsgBox($MB_ICONERROR, "Erreur", "Aucun draw n'est contenu dans le presse-papier." & @CRLF & "Veillez à bien copier le draw.")
			Return
			
		EndIf
	
	Else
		
		MsgBox($MB_ICONERROR, "Erreur", "Aucun draw n'est contenu dans le presse-papier." & @CRLF & "Veillez à bien copier le draw.")
		Return
		
	EndIf
	
	Dim $p1Pos = ControlGetPos("Aegisub", "", "[CLASS:wxWindowNR; INSTANCE:11]")
	Opt("WinTitleMatchMode", 2)
	MouseClick("primary", $p1Pos[0]+($p1Pos[2]/2), $p1Pos[1]+($p1Pos[3]/2))
	Send("{{}")
	Send("{\}")
	Send("p1")
	Send("{\}")
	Send("pos(0,0)")
	Send($Tags)
	Send("{}}")
	Send("^v")

EndFunc

Func On_SetHK1()

	Local $CtrlCheck = GUICtrlRead($HK_CtrlCheckBox)
	Local $AltCheck = GUICtrlRead($HK_AltCheckBox)
	local $ShiftCheck = GUICtrlRead($HK_ShiftCheckBox)

	Local $sHotkey = ""

	Local $Key = GUICtrlRead($HK_Key)

	If $CtrlCheck = 1 And $AltCheck = 1 And $ShiftCheck = 1 Then

		$sHotkey = "^!+" & $Key

	ElseIf $CtrlCheck = 1 And $AltCheck = 1 And $ShiftCheck = 4 Then

		$sHotkey = "^!" & $Key

	ElseIf $CtrlCheck = 1 And $AltCheck = 4 And $ShiftCheck = 1 Then

		$sHotkey = "^+" & $Key

	ElseIf $CtrlCheck = 1 And $AltCheck = 4 And $ShiftCheck = 4 Then

		If $Key = "a" Or $Key = "z" Or $Key = "y" Or $Key = "f" Or $Key = "h" Or $Key = "x" Or $Key = "c" Or $Key = "v" Or $Key = "n" Or $Key = "s" Then

			MsgBox($MB_ICONERROR, "Erreur", "Ce raccourci ne peut être configuré car il s'agit d'un raccourci windows.")

			Return

		EndIf

		If $Key = "i" Or $Key = "d" Or $Key = "&" Or $Key = "d" Or $Key = "'" Or $Key = "(" Or $Key = "-" Or $Key = "g" Or $Key = "p" Then

			Local $HotKeyCheck = MsgBox($MB_OKCANCEL, "Erreur", "Ce raccourci est un raccourci de base d'aegisub." & @CRLF & "Êtes-vous sûr de vouloir l'assigner ?")

			If $HotKeyCheck = 1 Then

				$sHotkey = "^" & $Key

			Else

				Return

			EndIf

		EndIf

	ElseIf $CtrlCheck = 4 And $AltCheck = 1 And $ShiftCheck = 1 Then

		$sHotkey = "!+" & $Key

	ElseIf $CtrlCheck = 4 And $AltCheck = 1 And $ShiftCheck = 4 Then

		$sHotkey = "!" & $Key

	ElseIf $CtrlCheck = 4 And $AltCheck = 4 And $ShiftCheck = 1 Then

		$sHotkey = "+" & $Key

	ElseIf $CtrlCheck = 4 And $AltCheck = 4 And $ShiftCheck = 4 Then

		MsgBox($MB_ICONERROR, "Erreur", "Aucune touche de modification sélectionnée")

		$sHotkey = ""

	EndIf

	If $Key = "" Then

		MsgBox($MB_ICONERROR, "Erreur", "Aucune touche sélectionnée")

		Return

	EndIf
	
	FileOpen($OptionPath, 1)
	
	If $CleanOrP1 = "Clean" Then
	
		$sp1Hotkey = IniRead($options, "Raccourcis", "p1", "")
		
		If $sHotkey == $sp1Hotkey Then
		
			MsgBox($MB_ICONERROR, "Erreur", "Ce raccourci est déjà utilisé par la fonction p1.")
			Return
		
		EndIf
	
	ElseIf $CleanOrP1 = "p1" Then
	
		$sCleanHotkey = IniRead($options, "Raccourcis", "Clean", "")
		
		If $sHotkey == $sCleanHotkey Then
		
			MsgBox($MB_ICONERROR, "Erreur", "Ce raccourci est déjà utilisé par la fonction clean.")
			Return
		
		EndIf
	
	EndIf
	
	
	IniWrite($options, "Raccourcis", $CleanOrP1, $sHotkey)

	If $CleanOrP1 == "Clean" Then
	
		HotKeySet($sHotkey, "On_Clean")
	
	ElseIf $CleanOrP1 == "p1" Then
	
		HotKeySet($sHotkey, "On_p1")
	
	EndIf

	FileClose ($options)

	GUIDelete($HK)

EndFunc

Func On_SetHK2()

	Local $sHK2 = ""
	
	Local $Key = GUICtrlRead($HK_Combobox)
	
	Local $IsF = StringInStr($Key, "F", 1,1,1,2)
	Local $IsPause = StringInStr($Key, "Pa", 1, 1, 1, 3)
	Local $IsArret = StringInStr($Key, "Ar", 1, 1, 1, 3)
	
	MsgBox($MB_ICONERROR,"Test",$IsF)
	
	If $Key = "" Then
	
		MsgBox($MB_ICONERROR, "Erreur", "Aucune touche sélectionnée.")
		Return
		
	ElseIf $IsF = 1 Then
	
		$sHK2 = "{" & $Key & "}"
		
	ElseIf $IsPause = 1 Then
	
		$sHK2 = "{PAUSE}"
		
	ElseIf $IsArret = 1 Then
	
		$sHK2 = "{SCROLLLOCK toggle}"
		
	Else
	
		MsgBox($MB_ICONERROR,"Erreur", "Erreur inconnue, contactez Afaren de la Owlolf")
	
	EndIf
	
	FileOpen($OptionPath, 1)
	
	If $CleanOrP1 = "Clean" Then
	
		$sp1Hotkey = IniRead($options, "Raccourcis", "p1", "")
		
		If $sHK2 == $sp1Hotkey Then
		
			MsgBox($MB_ICONERROR, "Erreur", "Ce raccourci est déjà utilisé par la fonction p1.")
			Return
		
		EndIf
	
	ElseIf $CleanOrP1 = "p1" Then
	
		$sCleanHotkey = IniRead($options, "Raccourcis", "Clean", "")
		
		If $sHK2 == $sCleanHotkey Then
		
			MsgBox($MB_ICONERROR, "Erreur", "Ce raccourci est déjà utilisé par la fonction clean.")
			Return
		
		EndIf
	
	EndIf
	
	IniWrite($options, "Raccourcis", $CleanOrP1, $sHK2)

	If $CleanOrP1 == "Clean" Then
	
		HotKeySet($sKH2, "On_Clean")
	
	ElseIf $CleanOrP1 == "p1" Then
	
		HotKeySet($sHK2, "On_p1")
	
	EndIf

	FileClose ($options)
	
	GUIDelete($HK)

EndFunc

Func On_Close_MainGui()

	Exit ; Fermeture maître du présent exe 

EndFunc

Func On_Close_Gui() ; Fermeture de la fenêtre actuelle, sauf s'il s'agit de la fenêtre principale => arrêt du présent exe (backdoor au on_close_maingui)

	Switch @GUI_WinHandle

		Case $AA
			Exit

		Case Else
			GUIDelete(@GUI_WinHandle)

	EndSwitch

EndFunc
