sub ShowMenuView()

    menuView = CreateObject("roSGNode", "HMenuView")
    menuView.observeField("itemSelected","OnButtonItemSelected")
    
    m.top.ComponentController.CallFunc("show", {
        view: menuView
    })
end sub


function retrieveButtonContent() as Object
    buttonContent = CreateObject("roSGNode", "ContentNode")
    buttonContent.Update({
        children: [{
            title: "Random"
        }, {
            title: "Search"
        }, {
            title: "About"
        }]
    }, true)
    return buttonContent
end function


sub OnButtonItemSelected(event as Object)
    selectedIndex = event.GetData()
    if selectedIndex = -1 then
        'ShowDetailsView(LoadShowFeed(false, false, ""), 0, true)
    else if selectedIndex = 0 then
        'ShowDetailsView(LoadShowFeed(true, false, ""), 0, true)
        print "menu shuffle"
        ShowDetailsViewShuffle()
    else if selectedIndex = 1 then
        ShowSearchView()
    else if selectedIndex = 2 then
        ShowAboutView()
    end if

end sub

sub ShowMenuView2()
    content = createMainMenu()
    m.grid = CreateObject("roSGNode", "HGridView")
    m.grid.SetFields({
        style: "standard"
        posterShape: "4x3"
    })
    m.grid.content = content
    m.grid.ObserveField("rowItemSelected", "MenuView_RowItemSelected")
    m.top.ComponentController.CallFunc("show", {
        view: m.grid
    })
end sub

sub MenuView_RowItemSelected(event as Object)
    
    grid = event.GetRoSGNode()
    selectedIndex = event.GetData()
    if selectedIndex[1] = -1 then
        'ShowDetailsView(LoadShowFeed(false, false, ""), 0, true)
    else if selectedIndex[1] = 0 then
        'ShowDetailsView(LoadShowFeed(true, false, ""), 0, true)
    else if selectedIndex[1] = 1 then
        ShowSearchView()
    else if selectedIndex[1] = 2 then
        ShowAboutView()
    end if

'    rowContent = grid.content.GetChild(selectedIndex[0])
 '   nextView = ShowDetailsView(rowContent, selectedIndex[1])
  '  nextView.ObserveField("wasClosed", "GridView_NextScreenWasClosed")
end sub


sub GridView_NextScreenWasClosed(event as Object)
   ' showButtonBar()
    nextView = event.GetRoSGNode()
    if nextView.itemFocused = invalid then return

    m.grid.jumpToRowItem = [m.grid.rowItemFocused[0], nextView.itemFocused]
end sub



function createMainMenu()
    mainMenu = CreateObject("roSGNode", "ContentNode")
    row = mainMenu.createChild("ContentNode")
    row.Title = ""

    'item = row.createChild("ContentNode")
    'item.Title = "All"
    'item.Description = "All episodes"
    'item.SDPosterURL = "pkg:/images/huell-kcet-poster-sd.png"
    'item.HDPosterURL = "pkg:/images/huell-kcet-poster-hd.png"
    item = row.createChild("ContentNode")
    item.Title = "Menu"
    item.Description = "Randomize Episodes"
    item.SDPosterURL = "pkg:/images/huell-kcet-poster-sd.png"
    item.HDPosterURL = "pkg:/images/huell-kcet-poster-hd.png"
    
    item = row.createChild("ContentNode")
    item.Title = "Menu"
    item.Description = "Search Episodes"
    item.SDPosterURL = "pkg:/images/huell-kcet-poster-sd.png"
    item.HDPosterURL = "pkg:/images/huell-kcet-poster-hd.png"

    item = row.createChild("ContentNode")
    item.Title = "Menu"
    item.Description = "About/Credits"
    item.SDPosterURL = "pkg:/images/huell-kcet-poster-sd.png"
    item.HDPosterURL = "pkg:/images/huell-kcet-poster-hd.png"

    return mainMenu
end function

