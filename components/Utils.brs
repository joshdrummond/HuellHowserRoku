Function islist(obj as dynamic) As Boolean
    if obj = invalid return false
    if GetInterface(obj, "ifArray") = invalid return false
    return true
End Function

Function validstr(obj As Dynamic) As String
    if isnonemptystr(obj) return obj
    return ""
End Function

Function isnonemptystr(obj)
    if isnullorempty(obj) return false
    return true
End Function

Function isnullorempty(obj)
    if obj = invalid return true
    if not isstr(obj) return true
    if Len(obj) = 0 return true
    return false
End Function

Function isstr(obj as dynamic) As Boolean
    if obj = invalid return false
    if GetInterface(obj, "ifString") = invalid return false
    return true
End Function

Function itostr(i As Integer) As String
    str = Stri(i)
    return strTrim(str)
End Function

Function strTrim(str As String) As String
    st=CreateObject("roString")
    st.SetString(str)
    return st.Trim()
End Function


function LoadShowFeed(isRandom As Boolean, isFilter As Boolean, filter As String) As Object
    txt = ReadASCIIFile("pkg:/data/feed.xml")
    'print "found in xml = " + itostr(Len(txt))
    xml = CreateObject("roXMLElement")
    if not xml.Parse(txt) then
        print "Can't parse feed (show)"
        return 0
    endif
    if xml.GetName() <> "feed" then
        print "no feed tag found"
        return 0
    endif
    if islist(xml.GetBody()) = false then
        print "no feed body found"
        return 0
    endif
    feed = ParseShowFeed(xml, isRandom, isFilter, filter)
    'print "found shows = " + itostr(feed.getChildCount())
    return feed
end function


'function ShuffleShows(shows as Object) as Void
'    size = shows.getChildCount()
'    for i% = size - 1 to 1 step -1
'        print i%
'        j% = Rnd(i% + 1) - 1
'        print j%
'        t = shows.getChild(i%) : shows.replaceChild(shows.getChild(j%), i%) : shows.replaceChild(t, j%)
'        print shows.getChildCount()
'    end for
'end function


function ParseShowFeed(xml As Object, isRandom As Boolean, isFilter As Boolean, filter As String) As Object
    showCount = 0
    showList = xml.GetChildElements()
    contentFeed = CreateObject("roSGNode", "ContentNode")
    for each curShow in showList
        'for now, don't process meta info about the feed size
        if curShow.GetName() = "resultLength" or curShow.GetName() = "endIndex" then
            goto skipitem
        endif
        'setup basics
        item = InitShowFeedItem()
        'fetch all values from the xml for the current show
        item.StreamContentIds = ["huell-" + validstr(curShow.uniqueId.GetText())]
        item.Title            = validstr(curShow.title.GetText()) 
        item.Description      = validstr(curShow.description.GetText()) 
        item.ReleaseDate      = validstr(curShow.date.GetText())
        'item.Runtime          = validstr(curShow.duration.GetText())
        item.StreamFormat     = validstr(curShow.streamFormat.GetText())
        if item.StreamFormat = "" then  'set default streamFormat to mp4 if doesn't exist in xml
            item.StreamFormat = "mp4"
        endif
        item.ShortDescriptionLine1 = item.Title 
        item.ShortDescriptionLine2 = item.Description
        item.Length = strtoi(validstr(curShow.duration.GetText()))
        item.Url = validstr(curShow.videoUrl.GetText())
        'item.StreamUrls = [item.Url]
        'item.Stream = {url: item.Url, contentid: item.StreamContentIds[0]}
        if validstr(curShow.videoUrl.GetText()) <> "" then
            showCount = showCount + 1
            if isFilter and isnonemptystr(filter) then
                if (LCase(item.Title).Instr(LCase(filter)) > -1) or (LCase(item.Description).Instr(LCase(filter)) > -1) then
                    contentFeed.appendChild(item)
                end if
            else if isRandom then
                ridx = Rnd(showCount+1) - 1
                contentFeed.insertChild(item, ridx)
                'print ridx
            else
                contentFeed.appendChild(item)
            end if
        end if
        skipitem:
    next
    print "huell show count = " + itostr(showCount)
    return contentFeed
end function


function InitShowFeedItem() As Object
    o = CreateObject("roSGNode", "ContentNode")
    o.StreamContentIds = CreateObject("roArray", 1, true)
    o.Title            = ""
    o.ContentType      = ""
    'o.ContentQuality   = ""
    'o.Synopsis         = ""
    'o.Genre            = ""
    'o.Runtime          = ""
    o.StreamQualities  = ["SD"]
    'o.StreamBitrates   = [0]
    'o.StreamUrls       = []
    'o.hdImg            = "pkg:/images/huell-kcet-poster-hd.png" 'validstr(curShow@hdImg) 
    'o.sdImg            = "pkg:/images/huell-kcet-poster-sd.png" 'validstr(curShow@sdImg) 
    'o.ContentType      = "Talk" 'validstr(curShow.contentType.GetText())
    'o.ContentQuality   = "SD" 'validstr(curShow.contentQuality.GetText())
    'o.Synopsis         = "" 
        'item.ReleaseDate      = Mid(item.ReleaseDate,6,2) + "/" + Mid(item.ReleaseDate,9,2) + "/" + Mid(item.ReleaseDate,1,4) 
    'o.HDBifUrl         = "" 'validstr(curShow.hdBifUrl.GetText())
    'o.SDBifUrl         = "" 'validstr(curShow.sdBifUrl.GetText())
    o.HDPosterUrl           = "pkg:/images/huell-kcet-poster-hd.png"
    o.SDPosterUrl           = "pkg:/images/huell-kcet-poster-sd.png"
    'o.Categories = CreateObject("roArray", 5, true)
    'o.Categories.Push(o.Genre)
    'o.Actors = CreateObject("roArray", 5, true)
    'o.Actors.Push(o.Genre)
        'item.Description = item.Synopsis
        'Set Default screen values for items not in feed
    o.HDBranded = false
    'o.IsHD = false
    o.StarRating = "100"
    o.ContentType = "episode" 
        'media may be at multiple bitrates, so parse an build arrays
        'for idx = 0 to 4
        '    e = curShow.media[idx]
        '    if e  <> invalid then
        '        item.StreamBitrates.Push(strtoi(validstr(e.streamBitrate.GetText())))
        '        item.StreamQualities.Push(validstr(e.streamQuality.GetText()))
        '        item.StreamUrls.Push(validstr(e.streamUrl.GetText()))
        '    endif
        'next idx
    return o
end function