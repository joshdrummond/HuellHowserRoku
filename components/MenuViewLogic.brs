sub ShowMenuView()
    menuView = CreateObject("roSGNode", "HMenuView")
    menuView.observeField("itemSelected","OnButtonItemSelected")
    m.top.ComponentController.CallFunc("show", {
        view: menuView
    })
end sub


sub OnButtonItemSelected(event as Object)
    selectedIndex = event.GetData()
    if selectedIndex = 0 then
        ShowDetailsView(LoadShowFeed(true, false, false, ""), 0, true)
    else if selectedIndex = 1 then
        ShowSearchView()
    else if selectedIndex = 2 then
        ShowAboutView()
    end if
end sub
