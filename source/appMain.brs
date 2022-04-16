'********************************************************************
'**  Huell Howser Roku Channel
'**  Copyright (c) 2020 Josh Drummond
'********************************************************************

Sub Main()

    'initialize theme attributes like titles, logos and overhang color
    initTheme()

    'prepare the screen for display and get ready to begin
    screen=preShowHomeScreen("", "")
    if screen=invalid then
        print "unexpected error in preShowHomeScreen"
        return
    end if

    'set to go, time to get started
    showHomeScreen(screen)

End Sub


'*************************************************************
'** Set the configurable theme attributes for the application
'** 
'** Configure the custom overhang and Logo attributes
'** Theme attributes affect the branding of the application
'** and are artwork, colors and offsets specific to the app
'*************************************************************

Sub initTheme()

    app = CreateObject("roAppManager")
    theme = CreateObject("roAssociativeArray")

    theme.BackgroundColor = "#FFFFC2"
    theme.TextScreenBodyBackgroundColor = "#FFFFEA"
    theme.OverhangOffsetSD_X = "72"
    theme.OverhangOffsetSD_Y = "31"
    theme.OverhangSliceSD = "pkg:/images/huell-masthead-sd.jpg"
    theme.OverhangLogoSD  = "pkg:/images/huell-logo-sd.png"

    theme.OverhangOffsetHD_X = "125"
    theme.OverhangOffsetHD_Y = "35"
    theme.OverhangSliceHD = "pkg:/images/huell-masthead-hd.jpg"
    theme.OverhangLogoHD  = "pkg:/images/huell-logo-hd.png"

    app.SetTheme(theme)

End Sub
