
sub ShowSearchView()
    searchView = CreateObject("roSGNode", "SearchView")
    searchView.hintText = "Enter search term"
    searchView.ObserveFieldScoped("query", "OnSearchQuery")
    searchView.ObserveFieldScoped("rowItemSelected","OnSearchItemSelected")
    searchView.posterShape = "16x9" 
    m.top.ComponentController.CallFunc("show", {
        view: searchView
    })
end sub


sub OnSearchQuery(event as Object)
    query = event.GetData()
    searchView = event.GetRoSGNode()
    content = CreateObject("roSGNode", "ContentNode")
    if query.Len() > 2 ' perform search if user has typed at least three characters
        content.AddFields({
            HandlerConfigSearch: {
                name: "CHSearch"
                query: query 'pass the query to the content handler
            }
        })
    end if
    ' setting the content with handlerConfigSearch will create
    ' the content handler where search should be performed
    ' setting the clear content node or invalid will clear the grid with results
    searchView.content = content
end sub


sub OnSearchItemSelected(event as Object)
    searchView = event.GetRoSGNode()
    selectedIndex = event.GetData()
    ShowDetailsView(searchView.content.getChild(0), selectedIndex[1], true)
end sub
