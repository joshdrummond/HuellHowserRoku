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
    
    ShowMenuView()
    m.top.signalBeacon("AppLaunchComplete")
end sub


sub OnContentLoaded(event as object)
    content = event.GetRoSGNode()
    if content.isContentLoaded then
        ' content has been loaded, process launch time deep linking
 '       if IsDeepLinking(m.args) ' if there are non-empty contentId and mediaType
 '           PerformDeeplinking(m.args)
 '       end if
        ' clear previously cached arguments
        m.args = invalid

        content.UnobserveFieldScoped("isContentLoaded")
    end if
end sub


