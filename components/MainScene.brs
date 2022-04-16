sub Show(args as Object)
    m.top.GetScene().theme = {
        global: {
            backgroundColor: "#FFFFC2"
            overhangLogoUri: "pkg:/images/huell-logo-hd.png"
            overhangBackgroundUri: "pkg:/images/huell-masthead-hd.jpg"
            overhangShowOptions: false
            overhangShowClock: false
        }
        gridView: {
            textColor: "#000000"
        }
        detailsView: {
            textColor: "#000000"
        }
        searchView: {
            textColor: "#000000"
            keyboardKeyColor: "#000000"
            keyboardFocusedKeyColor: "#000000"
            itemTextBackgroundColor: "#FFFFEA"
        }
    }
    ' Show Main Menu
    ShowMenuView()
    m.top.signalBeacon("AppLaunchComplete")
end sub
