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
    
    ' Support deep linking
    if IsDeepLinking(args)
        PerformDeepLinking(args)
    end if
    
    m.top.signalBeacon("AppLaunchComplete")
end sub


' #### Deep Linking Support

sub Input(args as object)
    ' handle roInput event deep linking
    if IsDeepLinking(args)
        PerformDeepLinking(args)
    end if
end sub


function IsDeepLinking(args as Object)
    ' check if deep linking args is valid
    return args.mediaType <> invalid and args.mediaType <> "" and args.contentId <> invalid and args.contentId <> "" 
end function


sub PerformDeeplinking(args as Object)
    mediaType = args.mediaType
    contentId = args.contentId
    ' check if mediaType is right
    if mediaType = "episode"
        currentView = m.top.ComponentController.currentView
        if currentView.Subtype() = "MediaView" and currentView.currentItem.id = contentId
            ' if currentView is MediaView and current playing item id equal to contentId, then do nothing
            print "Content is already playing"
        else if currentView.Subtype() = "DetailsView" and currentView.currentItem.id = contentId
            ' if if currentView is DetailsView and current playing item id equal to contentId, then play it
            ShowVideoPlayer(currentView.content.getChild(currentView.itemFocused), false)
        else
            ' show media view with item id equal to contentId
            CloseAllAppViewsButHome()
            ImitateMediaViewOpening(contentId)
        end if
    else
        ShowContentNotFoundDialog()
    end if
end sub


sub CloseAllAppViewsButHome()
    ' close all views except home view
    while m.top.ComponentController.ViewManager.ViewCount > 1
        currentView = m.top.ComponentController.currentView
        currentView.close = true
    end while
end sub


sub ImitateMediaViewOpening(contentId as String)
    CloseContentNotFoundDialog()
    results = LoadShowFeed(false, false, true, contentId)
    if (results.getChildCount() > 0) then
        ShowDetailsView(results, 0, true)
        ShowVideoPlayer(results.getChild(0), true)
        return
    end if
    ShowContentNotFoundDialog()
end sub


sub ShowContentNotFoundDialog()
    ' Close previous dialog if any
    CloseContentNotFoundDialog()
    dialog = CreateObject("roSGNode", "Dialog")
    dialog.title = tr("Error")
    dialog.message = tr("Content not found")
    dialog.buttons = [tr("OK")]
    dialog.optionsDialog = true
    dialog.ObserveField("buttonSelected", "CloseContentNotFoundDialog")
    m.top.GetScene().dialog = dialog
end sub


sub CloseContentNotFoundDialog()
    if m.top.GetScene().dialog <> invalid
        m.top.GetScene().dialog.close = true
    end if
end sub
