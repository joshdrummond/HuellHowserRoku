
'******************************************************
'** Perform any startup/initialization stuff prior to 
'** initially showing the screen.  
'******************************************************
Function preShowHomeScreen(breadA=invalid, breadB=invalid) As Object

    if validateParam(breadA, "roString", "preShowHomeScreen", true) = false return -1
    if validateParam(breadA, "roString", "preShowHomeScreen", true) = false return -1

    port=CreateObject("roMessagePort")
    screen = CreateObject("roPosterScreen")
    screen.SetMessagePort(port)
    if breadA<>invalid and breadB<>invalid then
        screen.SetBreadcrumbText(breadA, breadB)
    end if

    screen.SetListStyle("flat-category")
    screen.setAdDisplayMode("scale-to-fit")
    return screen

End Function


'******************************************************
'** Display the home screen and wait for events from 
'** the screen. The screen will show retreiving while
'** we fetch and parse the feeds for the game posters
'******************************************************
Function showHomeScreen(screen) As Integer

    if validateParam(screen, "roPosterScreen", "showHomeScreen") = false return -1

    initShows()
    initCategoryList()
    screen.SetContentList(m.Categories.Kids)
    screen.SetFocusedListItem(0)
    screen.Show()

    while true
        msg = wait(0, screen.GetMessagePort())
        if type(msg) = "roPosterScreenEvent" then
            'print "showHomeScreen | msg = "; msg.GetMessage() " | index = "; msg.GetIndex()
            if msg.isListFocused() then
                'print "list focused | index = "; msg.GetIndex(); " | category = "; m.curCategory
            else if msg.isListItemSelected() then
                'print "list item selected | index = "; msg.GetIndex()
                kid = m.Categories.Kids[msg.GetIndex()]
                'print "type = "; kid.type
                'if kid.type = "special_category" then
                if msg.GetIndex() = 0 then
                    displayRandomCategoryScreen(kid)
                else if msg.GetIndex() = 1 then
                    displaySearchPosterScreen(kid)
                else if msg.GetIndex() = 2 then
                    displayAboutScreen(kid)
                'else if msg.GetIndex() = 2 then
                '    displayAllEpsPosterScreen(kid)
                end if
            else if msg.isScreenClosed() then
                return -1
            end if
        end If
    end while

    return 0

End Function


'**********************************************************
'** When a poster on the home screen is selected, we call
'** this function passing an associative array with the 
'** data for the selected show.  This data should be 
'** sufficient for the show detail (springboard) to display
'**********************************************************
Function displayAllEpsPosterScreen(category As Object) As Dynamic

    if validateParam(category, "roAssociativeArray", "displayCategoryPosterScreen") = false return -1
    screen = preShowPosterScreen(category.Title, "")
    showPosterScreen(screen, category)

    return 0
End Function

Function displaySearchPosterScreen(category As Object) As Dynamic

    if validateParam(category, "roAssociativeArray", "displaySearchPosterScreen") = false return -1
    
    displayHistory = false
    searchQuery = ""
    history = CreateObject("roArray",1,true)
    port = CreateObject("roMessagePort")
    screen = CreateObject("roSearchScreen")
    screen.SetBreadcrumbText("","Search")
    screen.SetMessagePort(port)
    if displayHistory
        screen.setSearchTermHeaderText("Recent Searches:")
        screen.SetSearchButtonText("search")
        screen.SetClearButtonText("clear history")
        screen.setClearButtonEnabled(true)
    endif
    screen.Show()
    done = false
    while done = false
        msg = wait(0, screen.GetMessagePort())
        if type(msg) = "roSearchScreenEvent"
            if msg.isScreenClosed()
                searchQuery = ""
                done = true
            else if msg.isCleared()
                history.Clear()
            else if msg.isFullResult()
                history.Push(msg.GetMessage())
                searchQuery = msg.GetMessage()
                if displayHistory
                    screen.AddSearchTerm(msg.GetMessage())
                end if
                done = true
            endif
        endif
    endwhile
    
    if searchQuery <> ""
        screen = preShowPosterScreen(category.Title, "")
        showSearchResultPosterScreen(screen, category, searchQuery)
    endif

    return 0
End Function

Function displayAboutScreen(category As Object) As Dynamic
    if validateParam(category, "roAssociativeArray", "displayAboutScreen") = false return -1
    result = -1
    port = CreateObject("roMessagePort")
    screen = CreateObject("roTextScreen")
    screen.SetBreadcrumbText("","About")
    screen.SetMessagePort(port)
    text = ReadASCIIFile("pkg:/data/about.txt")
    screen.SetText(text)
    'screen.AddButton(1, "Okay")
    screen.Show()
    while true
        msg = Wait(0, port)
        if type(msg) = "roTextScreenEvent" then
            if msg.isScreenClosed() then
                exit while
            else if msg.isButtonPressed() then
                result = msg.GetIndex()
                exit while
            endif
        endif
    endwhile
    
    screen.Close()
    return result
End Function

'**********************************************************
'** Special categories can be used to have categories that
'** don't correspond to the content hierarchy, but are
'** managed from the server by data from the feed.  In these
'** cases we might show a different type of screen other
'** than a poster screen of content. For example, a special
'** category could be search, music, options or similar.
'**********************************************************
Function displayRandomCategoryScreen(category As Object) As Dynamic
    ' do nothing, this is intended to just show how
    ' you might add a special category ionto the feed
    screen = preShowDetailScreen(category.Title, "")
    showIndex = Rnd(m.Shows.Count()) - 1
    'print "random ep #" + itostr(showIndex)
    showDetailScreen(screen, m.Shows, showIndex, true)
    return 0
End Function

Function initShows() As Void
    conn = InitShowFeedConnection()
    m.Shows = conn.LoadShowFeed(conn)
End Function

'************************************************************
'** initialize the category tree.  We fetch a category list
'** from the server, parse it into a hierarchy of nodes and
'** then use this to build the home screen and pass to child
'** screen in the heirarchy. Each node terminates at a list
'** of content for the sub-category describing individual videos
'************************************************************
Function initCategoryList() As Void

    'conn = InitCategoryFeedConnection()
    'm.Categories = conn.LoadCategoryFeed(conn)
    'm.CategoryNames = conn.GetCategoryNames(m.Categories)
    '*** Custom category list
    topNode = MakeEmptyCatNode()
    topNode.Title = "root"
    topNode.isapphome = true

    ' random
    o = init_category_item()
    o.Type = "normal"
    o.Title = "Random"
    o.Description = "Random episodes"
    o.ShortDescriptionLine1 = o.Title
    o.ShortDescriptionLine2 = o.Description
    o.SDPosterURL = "pkg:/images/huell-kcet-poster-sd.png"
    o.HDPosterURL = "pkg:/images/huell-kcet-poster-hd.png"
    topNode.AddKid(o)

    ' search
    o = init_category_item()
    o.Type = "normal"
    o.Title = "Search"
    o.Description = "Search episodes"
    o.ShortDescriptionLine1 = o.Title
    o.ShortDescriptionLine2 = o.Description
    o.SDPosterURL = "pkg:/images/huell-kcet-poster-sd.png"
    o.HDPosterURL = "pkg:/images/huell-kcet-poster-hd.png"
    'o.SDPosterURL = "file://pkg:/images/huell_sd_poster.jpg"
    'o.HDPosterURL = "file://pkg:/images/huell_hd_poster.jpg"
    topNode.AddKid(o)

    ' about
    o = init_category_item()
    o.Type = "normal"
    o.Title = "About"
    o.Description = "Credits"
    o.ShortDescriptionLine1 = o.Title
    o.ShortDescriptionLine2 = o.Description
    o.SDPosterURL = "pkg:/images/huell-kcet-poster-sd.png"
    o.HDPosterURL = "pkg:/images/huell-kcet-poster-hd.png"
    topNode.AddKid(o)
    
    ' all episodes
    'o = init_category_item()
    'o.Type = "normal"
    'o.Title = "All Episodes"
    'o.Description = "Archive of all episodes"
    'o.ShortDescriptionLine1 = o.Title
    'o.ShortDescriptionLine2 = o.Description
    'o.SDPosterURL = "file://pkg:/images/huell_sd_poster.jpg"
    'o.HDPosterURL = "file://pkg:/images/huell_hd_poster.jpg"
    'topNode.AddKid(o)

    m.Categories = topNode
    m.CategoryNames = get_category_names(m.Categories)

End Function
