sub GetContent()
print "ch shuffle"
    results = LoadShowFeed(true, false, false, "")
    
    ' building rows with specific content items
    rootChildren = {
       children: []
    }
    if (results.getChildCount() > 0) then
        rootChildren.children.Push(results)
    end if

    m.top.content.Update(rootChildren)
end sub
