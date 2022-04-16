
function ShowDetailsView(content as Object, index as Integer, isContentList = true as Boolean) as Object
    details = CreateObject("roSGNode", "HDetailsView")
    details.ObserveField("buttonSelected", "DetailsView_ButtonSelected")
    DetailsView_SetButtons(details, ["Play"])
    details.SetFields({
        content: content
        jumpToItem: index
        isContentList: isContentList
    })
    m.top.ComponentController.CallFunc("show", {
        view: details
    })
    return details
end function


sub DetailsView_SetButtons(view as object, buttons as object)
    btnsContent = CreateObject("roSGNode", "ContentNode")
    for each button in buttons
        btnContent = btnsContent.createChild("ContentNode")
        btnContent.id = button
        btnContent.title = button
    end for
    view.buttons = btnsContent
end sub


sub DetailsView_ButtonSelected(event as Object)
    details = event.GetRoSGNode()
    selectedButton = details.buttons.GetChild(event.GetData())
    if selectedButton.id = "Play"
        ShowVideoPlayer(details.content, details.itemFocused, details.isContentList)
    end if
end sub


function ShowVideoPlayer(content as Object, index as Integer, isContentList = true as Boolean) as Object
    video = CreateObject("roSGNode", "MediaView")
    video.content = content.getChild(index)
    video.jumpToItem = index
    video.isContentList = false
    video.control = "play"
    m.top.ComponentController.CallFunc("show", {
        view: video
    })
    return video
end function
